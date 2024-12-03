// history.entity.ts

export interface Product {
  nombre: string;
  descripcion: string;
  cantidad: number;
}

export interface HistoryOrder {
  no_order: string; // ID único de la orden
  status: string; // Estado de la orden (Cancelado, Finalizado, etc.)
  created_at: string; // Fecha de creación de la orden
  products: number; // Número total de productos en la orden
}

// Mensaje que se recibe por el flujo SSE para el estado de una orden
export interface SSEOrderMessage {
  orderId: string;
  status: string;
  created_at: string;
  products: number;
}

export interface HistoryResponseEntity {
  code: number; // Código de la respuesta HTTP
  error: boolean; // Si hubo error
  message: string; // Mensaje de la respuesta
  data: HistoryOrder[]; // Lista de órdenes en el historial
}
