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
    <div v-if="data.length === 0" class="no-orders">
      <img
        src="../../../assets/empty2.png"
        alt="No hay pedidos"
        class="no-orders-image"
      />
      Aún no hay pedidos en esta cuenta
    </div>
    <div v-else>
      <div v-for="(item, index) in data" :key="index">
        <v-card class="white-card card-overlay">
          <div class="card-content">
            <div class="left-strip"></div>
            <div class="text-content">
              <p class="title">{{ item.numeroProductos }} productos</p>
              <p class="date">{{ item.fecha }}</p>
            </div>
            <v-chip
              :color="getChipColor(item.estatus)"
              variant="flat"
              class="chip-style"
            >
              <span style="color: white">{{ item.estatus }}</span>
            </v-chip>
            <!-- Enlace clickeable al ícono -->
            <router-link
              :to="{ name: 'historyDetails', params: { id: index } }"
              class="icon-link"
            >
              <i class="fa-solid fa-eye icon-style"></i>
            </router-link>
          </div>
        </v-card>
      </div>

      <!-- Componente de paginación debajo de las cards -->
      <v-pagination
        :length="3"
        :show-arrows="true"
        rounded="circle"
        class="pagination-style"
      ></v-pagination>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import WaveComponent from "@/components/WaveComponent.vue";

export default defineComponent({
  name: "HistoryView",
  components: { WaveComponent },
  data() {
    return {
      isActive: true, // Variable para manejar el estado del botón

      data: [
        {
          nombreCliente: "Jose",
          numeroProductos: 10,
          fecha: "29-10-2024",
          estatus: "Proceso de Compra",
          tiempoCompletado: "Aun no completado",
          subtotal: 0,
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
          nombreCliente: "Miguel",
          numeroProductos: 12,
          fecha: "28-10-2024",
          estatus: "Finalizado",
          tiempoCompletado: "120 min",
          subtotal: 300,
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
          nombreCliente: "Santiago",
          numeroProductos: 5,
          fecha: "27-10-2024",
          estatus: "Proceso de entrega",
          tiempoCompletado: "Aun no completado",
          subtotal: 0,
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
          nombreCliente: "Giovanni",
          numeroProductos: 8,
          fecha: "26-10-2024",
          estatus: "Cancelado",
          tiempoCompletado: "No completado",
          subtotal: 0,
          productos: [],
        },
      ],
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
  overflow: visible;
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

/* Ajustes solo para dispositivos móviles */
@media (max-width: 768px) {
  .history-container {
    height: 88vh;
    padding: 0px;
    position: relative;
    z-index: 1;
    overflow-y: auto; /* Permite desplazamiento vertical */
  }

  .title-container {
    flex-shrink: 0; /* Mantiene el tamaño del contenedor de título fijo */
    width: 400px;
    display: flex;
    justify-content: center; /* Centra el título y el botón de estado */
  }

  .status-container {
    flex-grow: 0;
    margin-left: 20px;
  }

  .status-button {
    width: 100%;
    max-width: 200px; /* Define un ancho máximo solo en móviles */
  }

  .v-chip.v-chip--size-default {
    padding: 0 50px !important; /* Reduce el padding en dispositivos móviles */
    font-size: 10px; /* Ajusta el tamaño de la fuente para mejorar la legibilidad */
    width: 100%; /* Hace que el chip ocupe todo el ancho disponible */
    justify-content: center; /* Centra el contenido del chip */
    overflow: hidden; /* Evita que el texto se salga del chip */
    text-overflow: ellipsis; /* Agrega puntos suspensivos si el texto es demasiado largo */
    white-space: nowrap; /* Mantiene el texto en una sola línea */
  }

  .icon-style {
    font-size: 30px;
    color: #312070;
    padding: 10px 8px 6px 0px;
  }

  .icon-link {
    margin-left: 3px; /* Espacio entre el chip y el icono */
    text-decoration: none;
  }

  .left-strip {
    width: 95px;
    min-height: 95px;
    background-color: #34344e;
    border-top-left-radius: 4px;
    border-bottom-left-radius: 4px;
  }
}
</style>
