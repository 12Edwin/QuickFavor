import * as admin from 'firebase-admin';
import { initializeApp } from 'firebase/app';
import { getAuth } from 'firebase/auth';
import { getStorage } from "firebase/storage";
import {getFirestore} from "firebase-admin/firestore";
//const serviceAccount = require('../../node-users-c60ae-firebase-adminsdk-98z1q-5f9f15525e.json');

const certificated = {
  type: "service_account",
  project_id: "node-users-c60ae",
  private_key_id: "ecba162048e1d518e25bf1260788d8f666250075",
  private_key: "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQClK07a4+JpFaN4\nIHDEO0cS4Tz9Rm62cab5WNgg43AS2OeakYdLfU2b+mcyO4/mgL1TViqLe7NlthDd\nyDUNSVHN6TXkCTn3D8nRmbOZdsR2TgYFjNmQ9+30FodWvr6A+iQe84MPauaGJPO5\n/0utzw+vqEsfTPVQF+vrJkz7Ms/HiGAgmEnIMk4mqDIHrZpNeXsU7IjsQ/YRSWyI\n5Hun1r0OoqIcaIKA5JgWLQQ8d7hJok6yLBEXKqrsft+2TbW96OHXBmQkHDPxlQx8\ntkKeq6y2+CvaE6IWFnRWEsRyrAQWMKI/Hn1OQnR1udcEDInZXKlVLyPhsJseJeoz\n+cwREPSbAgMBAAECggEARJ4N1/TlWifBrkW342YG/Gpzdns8wnHL3voQa/Vg2Yug\nCEBeNzfatqqcFavV9/pS7Ry2dxUQbfhp4GFs3NSxdfxlRZOpr6CxBPE4QlCrhMSc\nTtD5j/bYNdfoKNr8dMO2nt8mexC7rU4LrSFI9O+5Qg4GC35iyX/upFXYlGFDHc64\n15rlJhgUl2JOwSIyial7fwgyTxDvd91AgeH7ZABI4Uc3qTY9j3yoBa4Jwp3atCLa\ncqLX1N5XDiJehVsAEt1w5VkLBjKRZm9FclLwQ0DOD30OFXHStWLuyRQFp4GgLq/m\n+YZ57ycJLiFFUyITpBV9eF5WucH0NCyoXnaJ+2g0LQKBgQDPzBb8taw2qIN8M1zU\nAGxyi0LMDTetIU6RwJj2qAhCqxZQiAr8ujum567dJnZdglXsVKVK9lNnAhRvfIjo\n5GGp5aOM3Lrg2WLjvH9mLQDvG/rTX19J6bBNMcYQK4Igt5qJA9fVC94G8fXwKEV0\nlGGame2ySvTbwFNPLEqSY4MR3wKBgQDLe8cMFOe7OuM0qpUgDz9V9p5ctCRAd7Hs\nrdJy83uYYfB5zMNYctkIGhywx+uYDiy3Ka62OMc+dSzoAg2s/YHS3Ll1fBq6mmH9\nyOTcNQdnsh5zlkdKpVRM6XW+kG0T0D6EOEIbVivDuva0WT83s0WiQBCEMOH4L2rc\njj3GJNpMxQKBgDyRAgo6ca2kxF5JIj9wuCtSx+9t0tKVqK728h7Cr1WvRFvIq1sq\ndQSa9u7irRFoUd8GdP86eOjHRGmSZN1s48J/eoIuPBIZiqdSY9fGOkV3ZE6Dt+R1\nRrvZTB+ebtlWaqaRBjHEubxQfhy3wDbQoPpM72lOS7xZfG7RPBMbCjMFAoGACSQG\nTQSjZEXA7xy6ljYZIkNx2bg96Kd31qn4SjGl27KKmu4X2GFQXozNvSM98haw64lz\nz7u9N5EL82AkPSEmM9K2ghCRItDMlhnwLfQz4PSfaZHWogPLRak3INhcDgfMxyO/\n1HqKfMBpVLCtplLnTeKS211WyU9X/ZBmNgBxzgECgYEAxxzJVF/ElD5mCgAzSdY4\nrppXfXLr9ToEeMQ7qNzkgszf8ZW4e4LKvJTdZSu+2jY8bC/R8F/fyy6OA58QyWFR\nDmi0vDjSb94djJYQIPEgGNl4R6tFdAEt3w+C34SDu6jWw37L5rP/93qReCqqpWoE\nx8kDrJvS3fNI6uvZDIj5HaI=\n-----END PRIVATE KEY-----\n",
  client_email: "firebase-adminsdk-98z1q@node-users-c60ae.iam.gserviceaccount.com",
  client_id: "110889948300070683036",
  auth_uri: "https://accounts.google.com/o/oauth2/auth",
  token_uri: "https://oauth2.googleapis.com/token",
  auth_provider_x509_cert_url: "https://www.googleapis.com/oauth2/v1/certs",
  client_x509_cert_url: "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-98z1q%40node-users-c60ae.iam.gserviceaccount.com",
  universe_domain: "googleapis.com"
}

 admin.initializeApp({
    credential: admin.credential.cert(certificated as admin.ServiceAccount),
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