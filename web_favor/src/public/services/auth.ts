import api from '@/config/http-client-gateway';
import { showErrorToast, showSuccessToast } from '@/kernel/alerts';
import { getErrorMessages, ResponseEntity } from "@/kernel/error-response";
import { RegisterCourierEntity, LoginEntity } from "@/public/entity/auth.entity";
import { openDB } from 'idb'; // Importa `idb` para trabajar con IndexedDB

// Tiempo de expiración de caché (2 horas)
const CACHE_EXPIRATION_TIME = 200 * 60 * 60 * 1000; // 200 horas

const DB_NAME = 'appDB';
const CACHE_STORE_NAME = 'cache';
const PENDING_REQUESTS_STORE_NAME = 'pendingRequests';

// Inicializa la base de datos de IndexedDB
const initDB = async () => {
  return openDB(DB_NAME, 1, {
    upgrade(db) {
      // Crea un almacén para caché si no existe
      if (!db.objectStoreNames.contains(CACHE_STORE_NAME)) {
        db.createObjectStore(CACHE_STORE_NAME, { keyPath: 'requestKey' });
      }
      // Crea un almacén para peticiones pendientes
      if (!db.objectStoreNames.contains(PENDING_REQUESTS_STORE_NAME)) {
        db.createObjectStore(PENDING_REQUESTS_STORE_NAME, { keyPath: 'requestKey' });
      }
    },
  });
};

// Función para agregar una solicitud de registro a las pendientes
const addToPendingRequests = async (requestKey: string, requestData: any) => {
  const db = await initDB();
  const store = db.transaction(PENDING_REQUESTS_STORE_NAME, 'readwrite').objectStore(PENDING_REQUESTS_STORE_NAME);

  // Convertir `requestData` a un objeto plano
  const simplifiedRequestData = {
    requestKey,
    url: requestData.url,  // Solo guardamos la URL
    credentials: requestData.credentials,  // Solo los datos de registro
    timestamp: new Date().getTime(),  // Timestamp para control de expiración
  };

  console.log('Guardando solicitud pendiente de registro:', simplifiedRequestData);

  try {
    await store.put(simplifiedRequestData);
  } catch (error) {
    console.error("Error al guardar la solicitud pendiente:", error);
  }
};

// Función para procesar las peticiones pendientes
const processPendingRequests = async () => {
  const db = await initDB();
  const store = db.transaction(PENDING_REQUESTS_STORE_NAME).objectStore(PENDING_REQUESTS_STORE_NAME);
  const pendingRequests = await store.getAll();

  for (const request of pendingRequests) {
    try {
      const response = await api.doPost(request.url, request.credentials);
      if (response?.data?.data) {
        console.log('Solicitud pendiente procesada con éxito.');
        showSuccessToast('Solicitud procesada exitosamente.');
        // Aquí puedes guardar en caché si lo deseas
        // await setCache(request.requestKey, response.data, { url: request.url, credentials: request.credentials });
      }
      // Eliminar la petición procesada
      await removeFromPendingRequests(request.requestKey);
    } catch (error) {
      showErrorToast('Error al procesar la solicitud pendiente.');
      console.error('Error procesando solicitud pendiente:', error);
    }
  }
};

// Función para eliminar una solicitud de las pendientes en IndexedDB
const removeFromPendingRequests = async (requestKey: string) => {
  const db = await initDB();
  const store = db.transaction(PENDING_REQUESTS_STORE_NAME, 'readwrite').objectStore(PENDING_REQUESTS_STORE_NAME);

  try {
    await store.delete(requestKey);
    console.log(`Solicitud pendiente con key "${requestKey}" eliminada.`);
  } catch (error) {
    console.error(`Error al eliminar la solicitud pendiente con key "${requestKey}":`, error);
  }
};

// Función para verificar si estamos online
const isOnline = () => navigator.onLine;

// Registro de usuario
export const register = async (credentials: RegisterCourierEntity): Promise<ResponseEntity> => {
    const requestData = { url: "/auth/courier-register", credentials }; // Detalles de la solicitud

    // Si estamos offline, guardamos la solicitud pendiente
    if (!isOnline()) {
        console.log('No internet connection. Request saved for later.');
        await addToPendingRequests('register', requestData);
        showSuccessToast('No hay conexión a internet. La solicitud se guardará para más tarde.');
        return { error: false, message: 'Data guardada en local.', code: 201, data: null };
    }

    // Si estamos online, realizamos la solicitud de registro
    try {
        const response = await api.doPost(requestData.url, credentials);
        return response.data;
    } catch (error: any) {
        if (error.response && error.response.data) {
            const errorMessages = getErrorMessages(error.response.data);
            return errorMessages || { error: true, message: 'Error desconocido al registrar al usuario.', code: 500, data: null };
        }
        return { error: true, message: 'Error desconocido al registrar al usuario.', code: 500, data: null };
    }
}

// Login de usuario
export const login = async (credentials: LoginEntity): Promise <ResponseEntity> => {
    try {
        const fcmToken = await localStorage.getItem('firebase-token');
        if(fcmToken) credentials.token = fcmToken;

        const response = await api.doPost("/auth/login", credentials);
        localStorage.setItem("token", response.data.data.token);
        localStorage.setItem("no_user", response.data.data.user.no_user);
        localStorage.setItem("credential", response.data.data.user.uid);

        return response.data;
    } catch (error: any) {
        if (error.response && error.response.data) {
            const errorMessages = getErrorMessages(error.response.data);
            return errorMessages || { error: true, message: 'Error al intentar hacer login.', code: 500, data: null };
        }
        return { error: true, message: 'Error desconocido al intentar hacer login.', code: 500, data: null };
    }
}

// Escuchar cuando la conexión vuelva a estar online y procesar las peticiones pendientes
window.addEventListener('online', processPendingRequests);
