importScripts('https://cdnjs.cloudflare.com/ajax/libs/firebase/9.23.0/firebase-app-compat.min.js');
importScripts('https://cdnjs.cloudflare.com/ajax/libs/firebase/9.23.0/firebase-messaging-compat.min.js');

firebase.initializeApp({
  apiKey: "AIzaSyD32IFZRZpSi30w3Zlznlb3sWhtpxg5ilw",
  authDomain: "node-users-c60ae.firebaseapp.com",
  projectId: "node-users-c60ae",
  storageBucket: "node-users-c60ae.firebasestorage.app",
  messagingSenderId: "505924088824",
  appId: "1:505924088824:web:5c1b9b19ff6ec28767dc0d",
  measurementId: "G-TV8HCZ3TNR"
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage(function(payload) {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: payload.notification.icon
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});