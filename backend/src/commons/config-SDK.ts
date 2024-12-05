import * as admin from 'firebase-admin';
import { initializeApp } from 'firebase/app';
import { getAuth } from 'firebase/auth';
import { getStorage } from "firebase/storage";
import {getFirestore} from "firebase-admin/firestore";
const serviceAccount = require('../../node-users-c60ae-firebase-adminsdk-98z1q-e21ba254fa.json');

 admin.initializeApp({
    credential: admin.credential.cert(serviceAccount as admin.ServiceAccount),
    databaseURL: 'https://node-users-c60ae.firebaseio.com'
});

 const firebaseConfig = {
    apiKey: "AIzaSyD32IFZRZpSi30w3Zlznlb3sWhtpxg5ilw",
    authDomain: "https://node-users-c60ae.firebaseio.com",
    projectId: "node-users-c60ae",
    storageBucket: "node-users-c60ae.firebasestorage.app",
};

const app = initializeApp(firebaseConfig);
const auth = getAuth(app);
const storage = getStorage(app);
const db = getFirestore();

export {
    admin,
    auth,
    storage,
    db
};
export const messaging = admin.messaging();