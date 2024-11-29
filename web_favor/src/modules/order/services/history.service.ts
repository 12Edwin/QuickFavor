import api from "@/config/http-client-gateway";
import { getErrorMessages, ResponseEntity } from "@/kernel/error-response";
import { AxiosError } from "axios"; // Importamos AxiosError

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

  try {
    // Hace la solicitud a la API usando el no_user en la URL
    const response = await api.doGet(`/favor/history-courier/${noUser}`);

    // Verifica si la respuesta contiene los datos esperados
    if (response?.data?.data) {
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
