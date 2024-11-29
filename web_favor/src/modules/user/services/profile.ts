import api from '@/config/http-client-gateway';
import { getErrorMessages, ResponseEntity } from "@/kernel/error-response";
import { ProfileEntity } from "@/modules/user/entity/profile.entity";

// Tiempo de expiración de caché (2 horas)
const CACHE_EXPIRATION_TIME = 2 * 60 * 60 * 1000; 

const getCache = (credential: string) => {
  const cachedData = localStorage.getItem(credential);
  if (cachedData) {
    try {
      return JSON.parse(cachedData);
    } catch (e) {
      console.error("Error al parsear el caché:", e);
      return null;
    }
  }
  return null;
};

const setCache = (credential: string, data: any) => {
  const cacheData = {
    data,
    timestamp: new Date().getTime(),
  };
  localStorage.setItem(credential, JSON.stringify(cacheData));
};

const isCacheValid = (timestamp: number) => {
  return new Date().getTime() - timestamp < CACHE_EXPIRATION_TIME;
};

export const getProfile = async (): Promise<ResponseEntity> => {
  const credential = localStorage.getItem("credential");

  if (!credential) {
    return { error: true, message: 'No credential found in localStorage', code: 401, data: null };
  }

  // Intenta recuperar los datos del caché
  const cachedData = getCache(credential);

  if (cachedData && isCacheValid(cachedData.timestamp)) {
    return cachedData.data;
  }

  // Si el caché no es válido o no existe, intenta hacer la solicitud a la API
  try {
    const response = await api.doGet(`/courier/profile/${credential}`);
    
    if (response?.data?.data) {
      setCache(credential, response.data);
    }

    return response.data;
  } catch (error: any) {
    if (cachedData) {
      // Si hay datos en el caché pero no se puede conectar, se retorna el caché si es válido
      if (isCacheValid(cachedData.timestamp)) {
        return cachedData.data;
      } else {
        return { error: true, message: 'Cache expired and no internet connection', code: 500, data: null };
      }
    }

    // Si no hay caché válido, se manejan los errores de la API
    if (error.response) {
      return getErrorMessages(error.response.data);
    }

    return { error: true, message: 'Unknown error occurred', code: 500, data: null };
  }
};
