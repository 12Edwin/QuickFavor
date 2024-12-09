import api from '@/config/http-client-gateway';
import { getErrorMessages, ResponseEntity } from "@/kernel/error-response";
import { ProfileEntity } from "@/modules/user/entity/profile.entity";
import { openDB } from 'idb';  // Importación de `idb` al principio del archivo
import { toRaw } from 'vue';


// Tiempo de expiración de caché (2 horas)
const CACHE_EXPIRATION_TIME = 200 * 60 * 60 * 1000; // 2 horas

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

// Función para agregar una solicitud a las pendientes
const addToPendingRequests = async (requestKey: string, requestData: any) => {
  const db = await initDB();
  const store = db.transaction(PENDING_REQUESTS_STORE_NAME, 'readwrite').objectStore(PENDING_REQUESTS_STORE_NAME);

  // Convertir `profileData` a un objeto plano
  const simplifiedProfileData = toRaw(requestData.profileData);

  const simplifiedRequestData = {
    requestKey,
    url: requestData.url,  // Solo guardamos la URL
    profileData: simplifiedProfileData,  // Solo los datos del perfil
    timestamp: new Date().getTime(),  // Timestamp para control de expiración
  };

  console.log('Guardando solicitud pendiente:', simplifiedRequestData);

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
      const response = await api.doPut(request.url, request.profileData);  // Usamos los datos simplificados
      if (response?.data?.data) {
        // Guardamos la respuesta y la solicitud en caché
        await setCache(request.requestKey, response.data, { url: request.url, profileData: request.profileData });
      }
      // Eliminar la petición procesada
      await removeFromPendingRequests(request.requestKey);
    } catch (error) {
      console.error('Error procesando solicitud pendiente:', error);
    }
  }
};

// Función para verificar si estamos online
const isOnline = () => navigator.onLine;

// Función para guardar caché en IndexedDB
const setCache = async (requestKey: string, responseData: any, requestData: any) => {
  const db = await initDB();
  const store = db.transaction(CACHE_STORE_NAME, 'readwrite').objectStore(CACHE_STORE_NAME);
  const cacheData = {
    requestKey,
    responseData,  // Guardamos la respuesta de la API
    requestData,    // Guardamos los detalles de la solicitud
    timestamp: new Date().getTime(),
  };
  await store.put(cacheData);
};

// Función para obtener caché desde IndexedDB
const getCache = async (requestKey: string) => {
  const db = await initDB();
  const store = db.transaction(CACHE_STORE_NAME).objectStore(CACHE_STORE_NAME);
  return await store.get(requestKey);
};

// Verifica si el caché es válido
const isCacheValid = (timestamp: number) => {
  return new Date().getTime() - timestamp < CACHE_EXPIRATION_TIME;
};

// Obtiene el perfil del usuario
export const getProfile = async (): Promise<ResponseEntity> => {
  const credential = localStorage.getItem("credential");

  if (!credential) {
    return { error: true, message: 'No credential found in localStorage', code: 401, data: null };
  }

  const requestData = { url: `/courier/profile/${credential}`, credential }; // Detalles de la solicitud

  // Si estamos offline, intentamos traer la información desde la base de datos
  if (!isOnline()) {
    const cachedData = await getCache('getProfile');
    if (cachedData && isCacheValid(cachedData.timestamp)) {
      return cachedData.responseData;  // Devolvemos los datos del caché si es válido
    } else {
      return { error: true, message: 'No internet connection and no cached data available', code: 503, data: null };
    }
  }

  try {
    const response = await api.doGet(requestData.url);  // Realizamos la solicitud a la API

    if (response?.data?.data) {
      // Guardamos tanto la respuesta como los detalles de la solicitud
      await setCache('getProfile', response.data, requestData);
    }

    return response.data;
  } catch (error: any) {
    // Si no hay conexión y no hay caché, manejamos el error
    if (error.response) {
      return getErrorMessages(error.response.data);
    }

    return { error: true, message: 'Unknown error occurred', code: 500, data: null };
  }
};

// Actualiza el perfil del usuario
export const updateProfile = async (profile: ProfileEntity): Promise<ResponseEntity> => {
  const credential = localStorage.getItem("credential");

  if (!credential) {
    return { error: true, message: 'No credential found in localStorage', code: 401, data: null };
  }

  const requestData = { url: `courier/profile/`, profileData: profile }; // Detalles de la solicitud

  // Si estamos offline, guardamos la solicitud pendiente
  if (!isOnline()) {
    console.log('No internet connection. Request saved for later.');
    await addToPendingRequests('updateProfile', requestData);
    return { error: false, message: 'Data guardada en local.', code: 200, data: null };
  }

  try {
    const response = await api.doPut(requestData.url, profile);  // Realizamos la solicitud de actualización
    return response.data;
  } catch (error: any) {
    if (error.response) {
      return getErrorMessages(error.response.data);
    }

    return { error: true, message: 'Unknown error occurred', code: 500, data: null };
  }
}

// Actualiza el transporte del usuario
export const updateTransport = async (profile: ProfileEntity): Promise<ResponseEntity> => {
  const credential = localStorage.getItem("credential");

  if (!credential) {
    return { error: true, message: 'No credential found in localStorage', code: 401, data: null };
  }

  const requestData = { url: `courier/vehicle`, profileData: profile }; // Detalles de la solicitud

  // Si estamos offline, guardamos la solicitud pendiente
  if (!isOnline()) {
    console.log('No internet connection. Request saved for later.');
    await addToPendingRequests('updateTransport', requestData);
    return { error: false, message: 'Data guardada en local.', code: 200, data: null };
  }

  try {
    const response = await api.doPut(requestData.url, profile);  // Realizamos la solicitud de actualización
    return response.data;
  } catch (error: any) {
    if (error.response) {
      return getErrorMessages(error.response.data);
    }

    return { error: true, message: 'Unknown error occurred', code: 500, data: null };
  }
}

// Escuchar cuando la conexión vuelva a estar online y procesar las peticiones pendientes
window.addEventListener('online', processPendingRequests);

// Función para eliminar una solicitud de las pendientes en IndexedDB
const removeFromPendingRequests = async (requestKey: string) => {
  const db = await initDB();  // Abre la base de datos
  const store = db.transaction(PENDING_REQUESTS_STORE_NAME, 'readwrite').objectStore(PENDING_REQUESTS_STORE_NAME);  // Accede al objeto de almacenamiento de solicitudes pendientes

  try {
    await store.delete(requestKey);  // Elimina la solicitud con el `requestKey` especificado
    console.log(`Solicitud pendiente con key "${requestKey}" eliminada.`);
  } catch (error) {
    console.error(`Error al eliminar la solicitud pendiente con key "${requestKey}":`, error);
  }
};


