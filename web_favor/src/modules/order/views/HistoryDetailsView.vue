<template>
  <div class="back-container">
    <WaveComponent />
  </div>
  <div class="history-container">
    <div class="title-container">
      <i class="fa-solid fa-bell bell-icon"></i>
      <h1 class="titlePrincipal">Historial</h1>
      <div class="status-container">
        <button
          class="status-button"
          :class="{ inactive: !isActive }"
          @click="toggleStatus"
        >
          <div class="icon-circle" :class="{ 'inactive-icon': !isActive }">
            <i
              class="fa-solid fa-power-off power-icon"
              :class="{ 'inactive-icon': !isActive }"
            ></i>
          </div>
          <span class="status-text">{{
            isActive ? "Activo" : "Inactivo"
          }}</span>
        </button>
      </div>
    </div>

    <div class="content-container">
      <!-- Sección izquierda con el avatar y nombre -->
      <div class="left-section">
        <div class="left-content">
          <v-avatar color="#D9D9D9D9" size="200" class="avatar-border">
            <img
              src="../../../assets/oldManUser.png"
              alt="User Avatar"
              style="width: 100%; height: 100%; border-radius: 50%"
            />
          </v-avatar>
          <p class="username">Jose</p>
          <v-chip
            :color="getChipColor(historyItem.estatus)"
            variant="flat"
            class="chip-style"
          >
            <span style="color: white">{{ historyItem.estatus }}</span>
          </v-chip>
          <v-divider :thickness="4" color="#89a7b1"></v-divider>
        </div>
      </div>

      <!-- Sección derecha con los detalles -->
      <div class="details-section">
        <h1>Detalles del Historial</h1>
        <p>Producto: {{ historyItem.numeroProductos }} productos</p>
        <p>Fecha: {{ historyItem.fecha }}</p>
        <!-- Aquí puedes mostrar más detalles según el objeto -->
      </div>
    </div>

    <div v-if="data.length === 0" class="no-orders">
      <img
        src="../../../assets/empty2.png"
        alt="No hay pedidos"
        class="no-orders-image"
      />
      Aún no hay pedidos en esta cuenta
    </div>
    <div v-else></div>
  </div>
</template>

<script lang="ts">
import { defineComponent, computed } from "vue";

// Define el tipo para cada elemento en `data`
interface Producto {
  nombre: string;
  descripcion: string;
  cantidad: number;
}

interface HistorialItem {
  numeroProductos: number;
  fecha: string;
  estatus: string;
  productos: Producto[];
}

export default defineComponent({
  name: "HistoryDetailsView",
  props: {
    id: {
      type: Number,
      required: true,
    },
  },
  data() {
    return {
      isActive: true, // Variable para manejar el estado del botón

      data: [
        {
          numeroProductos: 10,
          fecha: "29-10-2024",
          estatus: "Proceso de Compra",
          productos: [
            {
              nombre: "1 litro aceite",
              descripcion: "Aceite 123 de litro",
              cantidad: 1,
            },
            {
              nombre: "2 kg arroz",
              descripcion: "Arroz blanco 2 kg",
              cantidad: 2,
            },
            {
              nombre: "500 g pasta",
              descripcion: "Pasta integral 500 g",
              cantidad: 1,
            },
            {
              nombre: "3 litros leche",
              descripcion: "Leche entera 3 litros",
              cantidad: 3,
            },
            {
              nombre: "1 kg azúcar",
              descripcion: "Azúcar blanca 1 kg",
              cantidad: 1,
            },
            {
              nombre: "250 g café",
              descripcion: "Café molido 250 g",
              cantidad: 1,
            },
            {
              nombre: "1 kg frijoles",
              descripcion: "Frijoles negros 1 kg",
              cantidad: 1,
            },
            {
              nombre: "1 paquete tortillas",
              descripcion: "Tortillas de maíz",
              cantidad: 1,
            },
            {
              nombre: "500 ml jugo",
              descripcion: "Jugo de naranja 500 ml",
              cantidad: 1,
            },
            {
              nombre: "750 ml salsa",
              descripcion: "Salsa de tomate 750 ml",
              cantidad: 1,
            },
          ],
        },
        {
          numeroProductos: 12,
          fecha: "28-10-2024",
          estatus: "Finalizado",
          productos: [
            {
              nombre: "1 litro aceite",
              descripcion: "Aceite 123 de litro",
              cantidad: 1,
            },
            {
              nombre: "2 kg arroz",
              descripcion: "Arroz blanco 2 kg",
              cantidad: 2,
            },
            {
              nombre: "500 g pasta",
              descripcion: "Pasta integral 500 g",
              cantidad: 1,
            },
            {
              nombre: "3 litros leche",
              descripcion: "Leche entera 3 litros",
              cantidad: 3,
            },
            {
              nombre: "1 kg azúcar",
              descripcion: "Azúcar blanca 1 kg",
              cantidad: 1,
            },
            {
              nombre: "250 g café",
              descripcion: "Café molido 250 g",
              cantidad: 1,
            },
            {
              nombre: "1 kg frijoles",
              descripcion: "Frijoles negros 1 kg",
              cantidad: 1,
            },
            {
              nombre: "1 paquete tortillas",
              descripcion: "Tortillas de maíz",
              cantidad: 1,
            },
            {
              nombre: "500 ml jugo",
              descripcion: "Jugo de naranja 500 ml",
              cantidad: 1,
            },
            {
              nombre: "750 ml salsa",
              descripcion: "Salsa de tomate 750 ml",
              cantidad: 1,
            },
          ],
        },
        {
          numeroProductos: 5,
          fecha: "27-10-2024",
          estatus: "Proceso de entrega",
          productos: [
            {
              nombre: "1 litro aceite",
              descripcion: "Aceite 123 de litro",
              cantidad: 1,
            },
            {
              nombre: "2 kg arroz",
              descripcion: "Arroz blanco 2 kg",
              cantidad: 2,
            },
            {
              nombre: "500 g pasta",
              descripcion: "Pasta integral 500 g",
              cantidad: 1,
            },
            {
              nombre: "3 litros leche",
              descripcion: "Leche entera 3 litros",
              cantidad: 3,
            },
            {
              nombre: "1 kg azúcar",
              descripcion: "Azúcar blanca 1 kg",
              cantidad: 1,
            },
            {
              nombre: "250 g café",
              descripcion: "Café molido 250 g",
              cantidad: 1,
            },
            {
              nombre: "1 kg frijoles",
              descripcion: "Frijoles negros 1 kg",
              cantidad: 1,
            },
            {
              nombre: "1 paquete tortillas",
              descripcion: "Tortillas de maíz",
              cantidad: 1,
            },
            {
              nombre: "500 ml jugo",
              descripcion: "Jugo de naranja 500 ml",
              cantidad: 1,
            },
            {
              nombre: "750 ml salsa",
              descripcion: "Salsa de tomate 750 ml",
              cantidad: 1,
            },
          ],
        },
        {
          numeroProductos: 8,
          fecha: "26-10-2024",
          estatus: "Cancelado",
          productos: [],
        },
      ] as HistorialItem[], // Define el tipo de `data` como un arreglo de `HistorialItem`
    };
  },
  methods: {
    toggleStatus() {
      this.isActive = !this.isActive;
    },
    getChipColor(estatus: string) {
      switch (estatus) {
        case "Proceso de Compra":
          return "#fdab30";
        case "Proceso de entrega":
          return "#89a7b1";
        case "Finalizado":
          return "#3a415a";
        case "Cancelado":
          return "#f70b0b";
        default:
          return "#b0bec5"; // Gris por defecto si no coincide con ningún estado
      }
    },
  },
  computed: {
    historyItem(): HistorialItem {
      return this.data[this.id];
    },
  },
});
</script>

<style scoped>
.back-container {
  width: 100%;
  overflow: hidden;
  position: absolute;
  bottom: 0;
  left: 0;
  z-index: -1;
}

.history-container {
  height: 88vh;
  padding: 16px;
  position: relative;
  z-index: 1;
}

/* Contenedor principal para la sección izquierda y derecha */
.content-container {
  display: flex;
  gap: 20px;
  padding: 20px;
}

/* Estilo para la sección izquierda */
.left-section {
  flex-basis: 20%;
  display: flex;
  justify-content: center;
  align-items: center;
}

.left-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
}

.username {
  margin-top: 10px;
  font-size: 22px;
  color: #34344e;
}

/* Estilo para la sección derecha */
.details-section {
  flex-basis: 80%;
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.avatar-border {
  border: 4px solid #89a7b1; /* Borde de color #89a7b1 */
  border-radius: 50%; /* Mantiene la forma circular */
  padding: 4px; /* Espacio entre la imagen y el borde */
  box-sizing: border-box; /* Asegura que el tamaño total del avatar incluya el borde */
}

/* Estilo para el contenedor del título */
.title-container {
  width: 100%;
  background-color: #566981; /* Color de fondo azul claro */
  padding: 16px;
  display: flex;
  justify-content: left;
  align-items: center;
  margin-bottom: 25px;
}

.titlePrincipal {
  color: #ffffff; /* Color de texto blanco */
  margin: 0;
  font-size: 24px;
  font-weight: bold;
}

.bell-icon {
  color: #ffffff; /* Mismo color que el texto del título */
  font-size: 30px; /* Tamaño del icono */
  margin-right: 30px;
}

/* Estilos para el botón de estado */
.status-container {
  margin-left: auto;
  display: flex;
  align-items: center;
}

.status-button {
  display: flex;
  align-items: center;
  background-color: #89a7b1;
  border: none;
  border-radius: 50px;
  padding: 8px 16px;
  color: white;
  font-size: 16px;
  font-weight: bold;
  cursor: pointer;
  box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.2);
  width: 350px;
  position: relative;
  overflow: visible; /* Permite que el icono salga del botón */
}

.status-button.inactive {
  background-color: #f70b0b;
}

.icon-circle {
  background-color: white;
  border-radius: 50%;
  padding: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 16px;
  position: absolute;
  left: -8px; /* Ajusta cuánto sobresale el icono */
}

.icon-circle.inactive-icon {
  background-color: #ffffff;
}

.power-icon {
  color: #0066cc; /* Color del icono de encendido */
  font-size: 24px;
}

.power-icon.inactive-icon {
  color: #f70b0b;
}

.status-text {
  color: white;
  margin-left: 30px;
}

/* Contenedor para centrar solo la sección de no-orders */
.no-orders-wrapper {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}

.no-orders {
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  color: #34344e;
  font-size: 18px;
}

.no-orders-image {
  width: 300px;
  height: auto;
  margin-bottom: 10px;
}

.white-card {
  background-color: white;
  width: 85%;
  margin: 0 auto;
  margin-bottom: 20px; /* Espacio entre cards */
  padding: 0;
  display: flex;
  align-items: center;
}

.card-overlay {
  z-index: 2;
}

.card-content {
  display: flex;
  align-items: center;
  width: 95%;
  gap: 15px;
}

.left-strip {
  width: 20px;
  min-height: 78px;
  background-color: #34344e;
  border-top-left-radius: 4px;
  border-bottom-left-radius: 4px;
}

.text-content {
  display: flex;
  flex-direction: column;
  justify-content: center;
  flex-grow: 1;
}

.title {
  font-size: 16px;
  font-weight: bold;
  color: #34344e;
  margin: 0;
}

.date {
  font-size: 14px;
  color: #6b7280;
  margin: 0;
  margin-left: 20px;
}

.chip-style {
  font-size: 14px;
  font-weight: bold;
  width: 150px; /* Ancho fijo para el chip */
  display: flex;
  justify-content: center;
  margin-top: 12px;
}

.icon-style {
  font-size: 30px;
  color: #312070;
  padding: 15px;
}

.icon-link {
  margin-left: 100px; /* Espacio entre el chip y el icono */
  text-decoration: none;
}
</style>
