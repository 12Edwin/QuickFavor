<template>
  <div class="back-container">
    <WaveComponent />
  </div>
  <div class="history-container">
    <div class="card-header d-flex align-center justify-space-between">
      <h2 class="header-title">
        <i class="fas fa-history fa-lg text-white" style="font-size: 36px"></i>
        <span class="ml-4 fas text-white">H i s t o r i a l</span>
      </h2>
      <Switch @onFalse="toggleStatus" @onTrue="toggleStatus" />
    </div>
    <div class="details-container">
      <div v-if="history.length === 0" class="no-orders">
        <img
          src="../../../assets/empty2.png"
          alt="No hay pedidos"
          class="no-orders-image"
        />
        Aún no hay pedidos en esta cuenta
      </div>
      <div class="h-100" v-else>
        <div
          class="h-100"
          v-for="(item, index) in paginatedHistory"
          :key="item.no_order"
        >
          <v-card class="white-card d-flex h-100 w-100">
            <div class="left-strip"></div>
            <div class="d-flex w-100 justify-space-between flex-wrap ga-2 pa-2">
              <div class="d-flex mx-2 flex-column justify-center mr-auto">
                <v-card-title class="px-0"
                  >{{ item.products }} productos</v-card-title
                >
                <p class="date ma-0 py-1">{{ formatDate(item.created_at) }}</p>
              </div>
              <div class="d-flex justify-center mx-2 align-center">
                <v-chip
                  :color="getChipColor(item.status)"
                  variant="flat"
                  class="chip-style"
                >
                  <span style="color: white">{{ item.status }}</span>
                </v-chip>
              </div>
              <div class="my-auto ml-auto">
                <v-btn class="rounded-pill">
                  <router-link
                    :to="{
                      name: 'historyDetails',
                      params: { id: item.no_order },
                    }"
                    class="icon-link"
                  >
                    <i class="fa-solid fa-eye icon-style"></i>
                  </router-link>
                </v-btn>
              </div>
            </div>
          </v-card>
        </div>
      </div>

      <!-- Componente de paginación debajo de las cards -->
      <v-pagination
        v-if="totalPages > 1"
        v-model="currentPage"
        :length="totalPages"
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
import Switch from "@/components/Switch.vue";
import { getOrderHistory } from "../services/history.service";
import { HistoryOrder } from "../entity/history.entity";
import { getProfile } from "@/modules/user/services/profile";

export default defineComponent({
  name: "HistoryView",
  components: { Switch, WaveComponent },
  data() {
    return {
      isActive: true, // Variable para manejar el estado del botón
      history: [] as HistoryOrder[], // Datos del historial de órdenes
      currentPage: 1, // Página actual para la paginación
      perPage: 5, // Número de elementos por página
      courierId: "", // Nuevo campo para almacenar el courierId
    };
  },
  computed: {
    // Datos paginados para mostrar solo una parte del historial
    paginatedHistory(): HistoryOrder[] {
      const start = (this.currentPage - 1) * this.perPage;
      const end = start + this.perPage;
      return this.history.slice(start, end);
    },
    totalPages(): number {
      return Math.ceil(this.history.length / this.perPage); // Anotamos el tipo explícito como 'number'
    },
  },
  methods: {
    toggleStatus() {
      this.isActive = !this.isActive;
    },

    async getHistory() {
      try {
        const response = await getOrderHistory(); // No necesitas pasar el courierId
        if (response.code === 200) {
          this.history = response.data; // Asignamos los datos del historial
        } else {
          console.error("Error en la respuesta:", response.message);
        }
      } catch (error) {
        console.error("Error al obtener el historial de pedidos:", error);
      }
    },

    getChipColor(estatus: string) {
      switch (estatus) {
        case "Pending":
          return "#fdab30";
        case "In delivery":
          return "#89a7b1";
        case "In shopping":
          return "#89a7b1";
        case "Finished":
          return "#3a415a";
        case "Canceled":
          return "#f70b0b";
        default:
          return "#b0bec5"; // Gris por defecto si no coincide con ningún estado
      }
    },

    formatDate(dateString: string) {
      const options: Intl.DateTimeFormatOptions = {
        weekday: "long",
        year: "numeric",
        month: "long",
        day: "numeric",
        hour: "numeric",
        minute: "numeric",
      };
      const date = new Date(dateString);
      return date.toLocaleDateString("es-MX", options);
    },
  },
  mounted() {
    this.getHistory(); // Llamamos a la función al cargar el componente
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
  position: static;
  padding-bottom: 20px;
  padding-left: 4vw;
  padding-right: 4vw;
  height: 100%;
}
.card-header {
  display: flex;
  align-items: center;
  background-color: #566981;
  padding: 1.5rem;
  border-radius: 10px;
  justify-content: space-between;
  flex-wrap: wrap;
  gap: 1rem;
}

.header-title {
  color: #ffffff;
  font-size: 20px;
  font-weight: bold;
  display: flex;
  align-items: center;
  gap: 8px;
}
.details-container {
  background-color: rgba(255, 255, 255, 0.4);
  padding: 2rem;
  border-radius: 10px;
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
  gap: 8px;
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
  margin-bottom: 20px;
  padding: 0;
}

.card-content {
  display: flex;
  align-items: center;
  width: 95%;
  gap: 15px;
}

.left-strip {
  width: 16px;
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
}

.chip-style {
  font-size: 14px;
  font-weight: bold;
  width: 150px; /* Ancho fijo para el chip */
  display: flex;
  justify-content: center;
}

.icon-style {
  font-size: 20px;
  color: #312070;
}

.icon-link {
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
