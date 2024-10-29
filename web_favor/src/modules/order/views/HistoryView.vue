<template>
  <div class="back-container">
    <WaveComponent />
  </div>
  <div class="history-container">
    <h1 class="titlePrincipal">Historial</h1>
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
          <router-link to="/ruta-deseada" class="icon-link">
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
</template>

<script lang="ts">
import { defineComponent } from "vue";
import WaveComponent from "@/components/WaveComponent.vue";

export default defineComponent({
  name: "HistoryView",
  components: { WaveComponent },
  data() {
    return {
      data: [
        {
          numeroProductos: 10,
          fecha: "29-10-2024",
          estatus: "Proceso de Compra",
        },
        { numeroProductos: 12, fecha: "28-10-2024", estatus: "Finalizado" },
        {
          numeroProductos: 5,
          fecha: "27-10-2024",
          estatus: "Proceso de entrega",
        },
        { numeroProductos: 8, fecha: "26-10-2024", estatus: "Cancelado" },
      ],
    };
  },
  methods: {
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

.titlePrincipal {
  margin-bottom: 25px;
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

/* Estilos para el componente de paginación */
.pagination-style {
  color: #2c3e50; /* Color de texto de la paginación */
  --v-pagination-active-color: #2c3e50; /* Color para el número activo */
}

.pagination-style .v-pagination__item--active {
  background-color: #b0bec5 !important; /* Fondo para el número activo */
  color: #ffffff !important; /* Color del número activo */
}

.pagination-style .v-pagination__item {
  color: #2c3e50 !important; /* Color de los números no activos */
}

.pagination-style .v-pagination__item--arrow {
  color: #2c3e50 !important; /* Color de las flechas */
}
</style>
