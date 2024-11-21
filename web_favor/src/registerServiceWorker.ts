import { register } from 'register-service-worker'
import firebaseMessaging from './firebase'

const messaging = firebaseMessaging

if (true) {
  register(`${process.env.BASE_URL}service-worker.js`, {
    ready() {
      console.log(
          'App is being served from cache by a service worker.\n' +
          'For more details, visit https://goo.gl/AFskqB'
      )

      initOfflineMode()
      requestPushPermission()
    },
    registered() {
      console.log('Service worker has been registered.')
      checkForUpdates()
    },
    cached() {
      console.log('Content has been cached for offline use.')
      showOfflineReadyMessage()
    },
    updatefound() {
      console.log('New content is downloading.')
      showUpdateProgressIndicator()
    },
    updated() {
      console.log('New content is available; please refresh.')
      showUpdateAvailableMessage()
      sendPendingRequests()
    },
    offline() {
      console.log('No internet connection found. App is running in offline mode.')
      enableOfflineMode()
      showCachedContent()
    },
    error(error) {
      console.error('Error during service worker registration:', error)
      showServiceWorkerErrorMessage(error)
    }
  })
}

async function requestPushPermission() {
  try {
    Notification.requestPermission().then(async (permission) => {
      if (permission === 'granted') {
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
    await fetch('/api/push-tokens', {
      method: 'POST',
      body: JSON.stringify({ token }),
      headers: {
        'Content-Type': 'application/json'
      }
    });
  } catch (error) {
    console.error('Error sending token to server:', error);
  }
}

messaging.onMessage((payload: any) => {
  console.log('Received foreground message:', payload);
  showPushNotification(payload);
});

function showPushNotification(payload: any) {
  const { title, body, icon } = payload.notification;
  if (title && body && icon) {
    navigator.serviceWorker.getRegistration().then((registration) => {
      registration?.showNotification(title, {
        body,
        icon,
        data: payload.data
      });
    });
  }
}

function initOfflineMode() {
  //cacheUserFavorRequests()
  //cacheLocationData()
  //showToast('App is now available for offline use')
}

async function checkForUpdates() {
  try {
    //const response = await fetch('/app-version.json')
    //const { version } = await response.json()

    //if (version > APP_VERSION) {
    //  showUpdateAvailableModal()
    //}
  } catch (error) {
    console.error('Error checking for updates:', error)
  }
}

function showOfflineReadyMessage() {
  const offlineReadyMessage = document.createElement('div')
  offlineReadyMessage.textContent = 'App is now available for offline use'
  offlineReadyMessage.classList.add('offline-ready-message')
  document.body.appendChild(offlineReadyMessage)
}

function showUpdateProgressIndicator() {
  const updateProgressIndicator = document.createElement('div')
  updateProgressIndicator.classList.add('update-progress-indicator')
  document.body.appendChild(updateProgressIndicator)

  let progress = 0
  const interval = setInterval(() => {
    updateProgressIndicator.style.width = `${progress}%`
    progress += 10
    if (progress >= 100) {
      clearInterval(interval)
      updateProgressIndicator.remove()
    }
  }, 100)
}

function showUpdateAvailableMessage() {
  const updateModal = document.createElement('div')
  updateModal.classList.add('update-modal')
  updateModal.textContent = 'New version available. Please refresh the app.'
  document.body.appendChild(updateModal)
}

function enableOfflineMode() {
  //enableDeferredDataSync()
  //showOfflineModeToast()
  showCachedContent()
}

function showServiceWorkerErrorMessage(error: any) {
  const errorMessage = document.createElement('div')
  errorMessage.classList.add('service-worker-error-message')
  errorMessage.textContent = `Error registering service worker: ${error.message}`
  errorMessage.innerHTML += '<p>Please try refreshing the page or check your internet connection.</p>'
  document.body.appendChild(errorMessage)
}

async function showCachedContent() {
  try {
    const cachedData = await caches.match('/favor-data')
    if (cachedData) {
      const data = await cachedData.json()
      //renderFavorRequests(data)
    } else {
      //showOfflineMessage()
    }
  } catch (error) {
    console.error('Error showing cached content:', error)
    //showOfflineMessage()
  }
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