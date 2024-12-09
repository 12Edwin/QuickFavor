

import { register } from 'register-service-worker'
import firebaseMessaging from './firebase'
import {showInfoToast} from "@/kernel/alerts";


  const CACHE_NAME = 'vue-app-cache-v1'
  const ASSETS_TO_CACHE = [
    '/',
    'index.html',
    'manifest.json',
    '/favicon.ico',
    'js/app.js',
  ]

  const messaging = firebaseMessaging

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
      showInfoToast('App available offline')
    },
    updatefound(registration) {
      console.log('New content downloading')
      registration.installing?.addEventListener('statechange', () => {
        if (registration.waiting) {
          showUpdateAvailableNotification()
        }
      })
    },
    updated(registration) {
      console.log('New content available')
      handleServiceWorkerUpdate(registration)
    },
    offline() {
      console.log('No internet connection')
      showCachedContent()
    },
    error(error) {
      console.error('Error during service worker registration:', error)
    }
  });

async function cacheAppAssets(registration: ServiceWorkerRegistration) {
  try {
    console.log('Caching assets');
    const cache = await caches.open(CACHE_NAME);
    for (const asset of ASSETS_TO_CACHE) {
      try {
        await cache.add(asset);
      } catch (error) {
        console.error(`Failed to cache asset: ${asset}`, error);
      }
    }
  } catch (error) {
    console.error('Asset caching failed:', error);
  }
}

async function showCachedContent() {
  try {
    const cache = await caches.open(CACHE_NAME);
    const cachedResponses = await Promise.all(
        ASSETS_TO_CACHE.map(asset => cache.match(asset))
    );

    cachedResponses.forEach((response, index) => {
      if (response) {
        console.log(`Cached asset available: ${ASSETS_TO_CACHE[index]}`);
        // Display the cached content as needed
      } else {
        console.warn(`Asset not found in cache: ${ASSETS_TO_CACHE[index]}`);
      }
    });
  } catch (error) {
    console.error('Error showing cached content:', error);
  }
}

function handleServiceWorkerUpdate(registration: ServiceWorkerRegistration) {
  // Prompt user to reload for new version
  if (registration.waiting) {
    registration.waiting.postMessage({ type: 'SKIP_WAITING' })
    window.location.reload()
  }
}

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

function checkForUpdates(registration: ServiceWorkerRegistration) {
  // Implement update checking logic
  if (registration.waiting) {
    showUpdateAvailableNotification()
  }
}

function showUpdateAvailableNotification() {
  showInfoToast('New version available. Refresh to update.')
}

function sendPendingRequests() {
  //const pendingRequests = await getPendingRequests()
  //pendingRequests.forEach(sendRequest)
  clearPendingRequests()
}

async function getPendingRequests() {
  // Obtener las solicitudes pendientes almacenadas en IndexedDB u otra fuente de datos
  //const db = await openDatabase()
  //return db.getPendingRequests()
}

function sendRequest(request: any) {
  // Enviar la solicitud al servidor
  fetch('/api/favors', {
    method: 'POST',
    body: JSON.stringify(request),
    headers: {
      'Content-Type': 'application/json'
    }
  })
      .then(() => {
        // Eliminar la solicitud de la lista de pendientes
        //db.deletePendingRequest(request.id)
      })
      .catch((error) => {
        // Volver a intentar enviar la solicitud más tarde
        //db.addPendingRequest(request)
      })
}

function clearPendingRequests() {
  // Eliminar todas las solicitudes pendientes de la base de datos
  //const db = await openDatabase()
  //db.clearPendingRequests()
}