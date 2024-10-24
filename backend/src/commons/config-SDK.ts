import * as admin from 'firebase-admin';
import { initializeApp } from 'firebase/app';
import { getAuth } from 'firebase/auth';
const serviceAccount = require('../../node-users-c60ae-firebase-adminsdk-98z1q-5654a6305c.json');

 admin.initializeApp({
    credential: admin.credential.cert(serviceAccount as admin.ServiceAccount),
    databaseURL: 'https://node-users-c60ae.firebaseio.com'
});

 const firebaseConfig = {
    apiKey: "AIzaSyD32IFZRZpSi30w3Zlznlb3sWhtpxg5ilw",
    authDomain: "https://node-users-c60ae.firebaseio.com",
    projectId: "node-users-c60ae",
};

const app = initializeApp(firebaseConfig);
const auth = getAuth(app);

export {
    admin,
    auth
};