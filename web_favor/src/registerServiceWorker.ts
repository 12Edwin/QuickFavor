import firebaseMessaging from './firebase'
import { register } from 'register-service-worker'
import { showInfoToast } from "@/kernel/alerts"
import { Workbox } from 'workbox-window'

const CACHE_NAME = 'vue-app-cache-v1'
const ASSETS_TO_CACHE = [
  '/',
  'index.html',
  'manifest.json',
  '/favicon.ico',
  'js/app.js',
]

const wb = new Workbox(`${process.env.BASE_URL}service-worker.js`)

// Manejar instalación del Service Worker
wb.addEventListener('installed', (event) => {
  if (event.isUpdate) {
    console.log('Nueva versión del Service Worker instalada')
  } else {
    console.log('Service Worker instalado por primera vez')
  }
})

// Manejar actualización pendiente
wb.addEventListener('waiting', () => {
  // Mostrar notificación de actualización
  if (confirm('Nueva versión disponible. ¿Deseas actualizar?')) {
    wb.messageSkipWaiting()
    window.location.reload()
  }
})

// Registro del Service Worker
wb.register()

// Verificar estado de caché offline
window.addEventListener('offline', () => {
  console.log('Sin conexión. Usando caché.')
})

window.addEventListener('online', () => {
  console.log('Conexión restaurada.')
})

register(`${process.env.BASE_URL}service-worker.js`, {
  ready(registration) {
    console.log('Service worker is active.')
    cacheAppAssets(registration)
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
    handleServiceWorkerUpdate(registration)
  },

  offline() {
    console.log('Sin conexión a internet')
    showCachedContent()
  },

  error(error) {
    console.error('Error durante el registro del service worker:', error)
  }
})

async function cacheAppAssets(registration: ServiceWorkerRegistration) {
  try {
    const cache = await caches.open(CACHE_NAME)

    for (const asset of ASSETS_TO_CACHE) {
      try {
        const response = await fetch(asset)
        if (response.ok) {
          await cache.put(asset, response)
          console.log(`Cached successfully: ${asset}`)
        }
      } catch (error) {
        console.warn(`Failed to cache asset: ${asset}`, error)
      }
    }
  } catch (error) {
    console.error('Asset caching failed:', error)
  }
}

async function showCachedContent() {
  try {
    const cache = await caches.open(CACHE_NAME)
    const cachedResponses = await Promise.all(
        ASSETS_TO_CACHE.map(asset => cache.match(asset))
    )

    cachedResponses.forEach((response, index) => {
      if (response) {
        console.log(`Cached asset available: ${ASSETS_TO_CACHE[index]}`)
        // Aquí puedes agregar lógica para mostrar contenido cached
      } else {
        console.warn(`Asset not found in cache: ${ASSETS_TO_CACHE[index]}`)
      }
    })
  } catch (error) {
    console.error('Error mostrando contenido cached:', error)
  }
}

function handleServiceWorkerUpdate(registration: ServiceWorkerRegistration) {
  if (registration.waiting) {
    // Enviar mensaje para saltar la fase de espera
    registration.waiting.postMessage({ type: 'SKIP_WAITING' })

    // Recargar la página para usar la nueva versión
    window.location.reload()
  }
}

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
        // Envía el token al servidor para registrar el dispositivo
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