<template>
  <div class="back-container">
    <WaveComponent />
  </div>
  <div class="history-container">
    <div class="title-container">
      <div>
        <i class="fas fa-history bell-icon"> <span class="ml-4 bell-icon fas"> H i s t o r i a l </span></i>
      </div>
      <Switch @onFalse="" @onTrue=""/>

    </div>
    <div class="details-container">
      <div v-if="data.length === 0" class="no-orders">
        <img
          src="../../../assets/empty2.png"
          alt="No hay pedidos"
          class="no-orders-image"
        />
        Aún no hay pedidos en esta cuenta
      </div>
      <div class="h-100" v-else>
        <div class="h-100" v-for="(item, index) in data" :key="index">
          <v-card class="white-card d-flex h-100 w-100">
            <div class="left-strip"></div>
            <v-row class="h-100">
              <v-col xl="4" lg="4" md="4" sm="6" class="d-flex align-center flex-column justify-center">
                <p class="title">{{ item.numeroProductos }} productos</p>
                <p class="date">{{ item.fecha }}</p>
              </v-col>
              <v-col xl="5" lg="5" md="5" sm="6" class="d-flex justify-center align-center">
                <v-chip :color="getChipColor(item.estatus)" variant="flat" class="chip-style">
                  <span style="color: white">{{ item.estatus }}</span>
                </v-chip>
              </v-col>
              <v-col xl="2" lg="2" md="2" sm="6" class="d-flex justify-end align-center">
                <router-link
                  :to="{ name: 'historyDetails', params: { id: index } }"
                  class="icon-link">
                  <i class="fa-solid fa-eye icon-style"></i>
                </router-link>
              </v-col>
            </v-row>
          </v-card>
        </div>
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
import Switch from "@/components/Switch.vue";

export default defineComponent({
  name: "HistoryView",
  components: {Switch, WaveComponent },
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
  position: static;
  padding-bottom: 20px;
  padding-left: 4vw;
  padding-right: 4vw;
  height: 100%;
}

.title-container {
  display: flex;
  align-items: center;
  background-color: #566981;
  padding: 1.5rem;
  border-radius: 10px;
  justify-content: space-between;
  flex-wrap: wrap;
  gap: 1rem;
}

.title-container > *:nth-child(n+4) {
  justify-content: center;
  width: 100%;
  display: flex;
}

.details-container{
  background-color: rgba(255, 255, 255, 0.4);
  padding: 2rem;
  border-radius: 10px;
}

.bell-icon {
  color: #ffffff;
  font-size: 20px;
  font-weight: bold;
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
  width: 20px;
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
