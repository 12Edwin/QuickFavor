import firebase from "firebase/compat/app"
import "firebase/compat/messaging";
import { showErrorToast } from "./kernel/alerts";


const firebaseConfig = {
  apiKey: "AIzaSyD32IFZRZpSi30w3Zlznlb3sWhtpxg5ilw",
  authDomain: "node-users-c60ae.firebaseapp.com",
  projectId: "node-users-c60ae",
  storageBucket: "node-users-c60ae.firebasestorage.app",
  messagingSenderId: "505924088824",
  appId: "1:505924088824:web:5c1b9b19ff6ec28767dc0d",
  measurementId: "G-TV8HCZ3TNR"
};

try{
  firebase.initializeApp(firebaseConfig);
  firebase.messaging();
}catch(e){
  showErrorToast('Tu conexión a internet es inestable o no es segura para soportar notificaciones push')
  console.log(e)
}

firebase.initializeApp(firebaseConfig);
const messaging = firebase.messaging();



export default messaging;