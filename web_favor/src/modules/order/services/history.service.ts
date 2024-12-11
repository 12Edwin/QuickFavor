import api from "@/config/http-client-gateway";
import { getErrorMessages, ResponseEntity } from "@/kernel/error-response";
import { AxiosError } from "axios"; // Importamos AxiosError
import { openDB } from "idb"; // Importación de `idb` al principio del archivo
import { toRaw } from "vue";

const CACHE_EXPIRATION_TIME = 200 * 60 * 60 * 1000; // 200 horas
const DB_NAME = "appDB";
const CACHE_STORE_NAME = "cache";
const PENDING_REQUESTS_STORE_NAME = "pendingRequests";

// Inicializa la base de datos de IndexedDB
const initDB = async () => {
  return openDB(DB_NAME, 1, {
    upgrade(db) {
      if (!db.objectStoreNames.contains(CACHE_STORE_NAME)) {
        db.createObjectStore(CACHE_STORE_NAME, { keyPath: "requestKey" });
      }
      if (!db.objectStoreNames.contains(PENDING_REQUESTS_STORE_NAME)) {
        db.createObjectStore(PENDING_REQUESTS_STORE_NAME, { keyPath: "requestKey" });
      }
    },
  });
};

const isOnline = () => navigator.onLine;

// Función para guardar caché
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

// Función para obtener caché
const getCache = async (requestKey: string) => {
  const db = await initDB();
  const store = db.transaction(CACHE_STORE_NAME).objectStore(CACHE_STORE_NAME);
  return store.get(requestKey);
};

// Verifica si el caché es válido
const isCacheValid = (timestamp: number) => {
  return new Date().getTime() - timestamp < CACHE_EXPIRATION_TIME;
};

// Función para agregar una solicitud pendiente
const addToPendingRequests = async (requestKey: string, requestData: any) => {
  const db = await initDB();
  const store = db.transaction(PENDING_REQUESTS_STORE_NAME, "readwrite").objectStore(PENDING_REQUESTS_STORE_NAME);
  
  const simplifiedRequestData = {
    requestKey,
    url: requestData.url,  // Solo guardamos la URL
    timestamp: new Date().getTime(),  // Timestamp para control de expiración
  };

  await store.put(simplifiedRequestData);
};

// Función para procesar las solicitudes pendientes
const processPendingRequests = async () => {
  const db = await initDB();
  const store = db.transaction(PENDING_REQUESTS_STORE_NAME).objectStore(PENDING_REQUESTS_STORE_NAME);
  const pendingRequests = await store.getAll();

  for (const request of pendingRequests) {
    try {
      const response = await api.doGet(request.url); // Realiza la solicitud original
      if (response?.data?.data) {
        await setCache(request.requestKey, response.data, { url: request.url });
      }
      await removeFromPendingRequests(request.requestKey); // Elimina la solicitud procesada
    } catch (error) {
      console.error('Error procesando solicitud pendiente:', error);
    }
  }
};

// Eliminar solicitud de pendientes
const removeFromPendingRequests = async (requestKey: string) => {
  const db = await initDB();
  const store = db.transaction(PENDING_REQUESTS_STORE_NAME, 'readwrite').objectStore(PENDING_REQUESTS_STORE_NAME);
  await store.delete(requestKey);
};

// Función para obtener el historial de pedidos de un repartidor
export const getOrderHistory = async (): Promise<ResponseEntity> => {
  const noUser = localStorage.getItem("no_user"); // Recupera el no_user de localStorage

  if (!noUser) {
    return {
      error: true,
      message: "No user found in localStorage",
      code: 401,
      data: null,
    };
  }

  const requestData = { url: `/favor/history-courier/${noUser}`, noUser }; // Datos de la solicitud

  // Si estamos offline, intentamos traer la información desde la base de datos
  if (!isOnline()) {
    const cachedData = await getCache(`history-${noUser}`);
    if (cachedData && isCacheValid(cachedData.timestamp)) {
      return cachedData.responseData;  // Devolvemos los datos del caché si es válido
    } else {
      console.log('No internet connection. Request saved for later.');
      await addToPendingRequests(`history-${noUser}`, requestData);
      return { error: false, message: 'Data saved locally and will sync when online.', code: 200, data: null };
    }
  }

  try {
    // Hace la solicitud a la API usando el no_user en la URL
    const response = await api.doGet(requestData.url);

    // Verifica si la respuesta contiene los datos esperados
    if (response?.data?.data) {
      await setCache(`history-${noUser}`, response.data, requestData);
      return response.data;
    } else {
      return { error: true, message: "No data found", code: 404, data: null };
    }
  } catch (error: unknown) {
    // Asegúrate de que el error es un AxiosError antes de acceder a 'response'
    if ((error as AxiosError).response) {
      // Aquí hacemos un type assertion de la data a ResponseEntity
      return getErrorMessages(
        (error as AxiosError).response?.data as ResponseEntity
      );
    }
    return {
      error: true,
      message: "Unknown error occurred",
      code: 500,
      data: null,
    };
  }
};

// Escuchar cuando la conexión vuelva a estar online y procesar las peticiones pendientes
window.addEventListener('online', processPendingRequests);
