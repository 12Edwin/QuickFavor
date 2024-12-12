import firebaseMessaging from './firebase'
import { register } from 'register-service-worker'
import { showInfoToast } from "@/kernel/alerts"
import { Workbox } from 'workbox-window'

const wb = new Workbox(`${process.env.BASE_URL}service-worker.js`)

// Manejar actualización pendiente
wb.addEventListener('waiting', () => {
  wb.messageSkipWaiting()
})

// Registro del Service Worker
wb.register()

register(`${process.env.BASE_URL}service-worker.js`, {
  ready(registration) {
    console.log('Service worker is active.')
    requestPushPermission()
  },

  registered(registration) {
    console.log('Service worker has been registered.')
    checkForUpdates(registration)
  },

  cached() {
    console.log('Content cached for offline use')
    showInfoToast('App disponible sin conexión')
  },

  updatefound(registration) {
    console.log('Nuevo contenido descargándose')
    const installingWorker = registration.installing
    if (installingWorker) {
      installingWorker.addEventListener('statechange', () => {
        if (installingWorker.state === 'installed') {
          if (navigator.serviceWorker.controller) {
            showUpdateAvailableNotification()
          }
        }
      })
    }
  },

  updated(registration) {
    console.log('Nuevo contenido disponible')
  },

  offline() {
    console.log('Sin conexión a internet')
  },

  error(error) {
    console.error('Error durante el registro del service worker:', error)
  }
})

function checkForUpdates(registration: ServiceWorkerRegistration) {
  if (registration.waiting) {
    showUpdateAvailableNotification()
  }
}

function showUpdateAvailableNotification() {
  showInfoToast('Nueva versión disponible. Actualiza para continuar.')
}

// -----------------------Firebase----------------------------------------------

const messaging = firebaseMessaging

async function requestPushPermission() {
  try {
    Notification.requestPermission().then(async (permission) => {
      if (permission === 'granted') {
        console.log('Notification permission granted.');
        const token = await messaging.getToken({vapidKey: 'BAUkujxVC6KfNTvjW7OrSz_e7Ca70ja3f6k_aP-U_DzKYXsM6C3nmMlDvQyPOTIVwABnelhf8LYEdCw9FurJyyU'});
        console.log('Firebase Messaging token:', token);
        await sendTokenToServer(token);
      } else {
        console.log('Unable to get permission to notify.');
      }
    })
  } catch (error) {
    console.error('Error requesting push permission:', error);
  }
}

async function sendTokenToServer(token: any) {
  try {
    await localStorage.setItem('firebase-token', token)
  } catch (error) {
    console.error('Error sending token to server:', error);
  }
}

messaging.onMessage(async (payload: any) => {
  console.log('Received foreground message:', payload);
  await showPushNotification(payload);
});

async function showPushNotification(payload: any) {
  const { title, body, icon } = payload.notification;
  if (title && body) {
    showInfoToast(body);
    navigator.serviceWorker.getRegistration().then((registration) => {
      registration?.showNotification(title, {
        body,
        icon,
        data: payload.data
      });
    });
  }
}