<template>
  <div class="back-container">
    <WaveComponent :wave-height="800"/>
  </div>

  <div class="container-detail">
    <!-- Header con fondo azul y iconos de Font Awesome -->
    <div class="title-container">
      <i class="fas fa-bell bell-icon"> <span class="ml-4 bell-icon fas"> O r d e n </span></i>
      <div class="status-container">
        <button
            :class="{ inactive: !isActive }"
            class="status-button"
            @click="toggleStatus"
        >
          <div :class="{ 'inactive-icon': !isActive }" class="icon-circle">
            <i :class="['fas', 'fa-power-off', isActive ? 'power-icon' : 'power-icon-inactive']"></i>
          </div>
          <span class="status-text">{{ isActive ? "Activo" : "Inactivo" }}</span>
        </button>
      </div>
    </div>

    <!-- Contenedor de detalles en fondo blanco -->
    <div class="details-container">
      <div class="d-flex w-100 justify-space-between">
        <h2 class="details-title">Detalles del pedido</h2>
        <div>
          <div class="badge-style" :style="{'background-color': '#FFA500'}">
            {{statusText}}
          </div>
        </div>
      </div>
      <div class="w-100 d-flex justify-end mb-5">
        <v-btn :disabled="status !== 'Proceso de compra'" rounded class="cancel-button" color="red" @click="cancelOrder">
          <span class="font-weight-bold" style="color: white"> Cancelar </span>
        </v-btn>
      </div>

      <v-row justify="space-between">
        <v-col xl="6" lg="6" md="12" sm="12">
          <div class="d-flex justify-start">
            <div class="profile-avatar">
              <v-avatar size="120">
                <img alt="User Avatar" src="@/assets/profile.png"/>
              </v-avatar>
            </div>
            <div class="ml-4">
              <h2>Juan Rodrigo</h2>
              <p class="user-role">Cliente</p>
              <span class="info-row">
                <i class="fas fa-phone info-icon"></i>
                <span>777-234-4325</span>
              </span>
              <br>
              <span class="info-row">
                <i class="fas fa-eye info-icon"></i>
                <span>Ubicación</span>
              </span>
            </div>
          </div>

          <!-- Step Progress de Direcciones -->
          <div class="direction-buttons">
            <div class="line-connector"></div>
            <div
                v-for="(address, index) in addresses"
                :key="index"
                class="direction-button"
                @click="toggleAddress(index)"
            >
              <i :class="['fas', address.active ? 'fa-eye' : 'fa-ban', 'direction-icon']"></i>
              <p v-if="address.active" class="address-name">{{ address.name }}</p>
            </div>
          </div>
        </v-col>

        <v-col xl="6" lg="6" md="12" sm="12" class="d-block" >
          <div class="d-flex justify-center">
            <div>
            <div class="chat-container mx-auto" style="width: auto; max-width: 150px">
              <div class="icon-circle">
                <i class="fas fa-comment-dots chat-icon"></i>
              </div>
              <span class="chat-text">Chatear</span>
            </div>

              <div class="timer text-center"><p>{{ formattedTime }}</p></div>

            <!-- Imagen de la caja -->
            <img alt="Caja" class="box-image position-static" src="@/assets/box.png"/>
            </div>
          </div>
        </v-col>
      </v-row>

      <div class="h-100 w-100">
        <!-- Lista de productos -->
        <div class="product-section-title">Productos</div>
        <v-card class="product-list" outlined>
          <v-list>
            <v-list-item
                v-for="(product, index) in products"
                :key="index"
                class="product-item"
            >
              <v-row align="center" no-gutters>
                <!-- Primera columna: Número del producto -->
                <v-col class="product-number-column" cols="1">
                  <span class="product-number">{{ index + 1 }}.</span>
                </v-col>

                <!-- Segunda columna: Nombre y descripción del producto -->
                <v-col class="product-info-column" cols="8">
                  <span class="product-name">{{ product.name }}</span>
                  <p class="product-description">{{ product.detail }}</p>
                </v-col>

                <!-- Tercera columna: Icono del ojo -->
                <v-col class="eye-icon-column" cols="3">
                  <i class="fas fa-eye eye-icon"></i>
                </v-col>
              </v-row>
            </v-list-item>
          </v-list>
        </v-card>

        <!-- Step Progress Component -->
        <div class="step-progress">
          <!-- Primer círculo grande con estilo específico -->
          <div class="step-item-large step-item-large-first">
            <i class="fas fa-shopping-cart step-icon"></i>
          </div>

          <!-- Círculo pequeño -->
          <div class="step-item-small">
            <span>Sig</span>
            <i class="fas fa-chevron-right step-icon"></i>
          </div>

          <!-- Segundo círculo grande -->
          <div class="step-item-large">
            <i class="fas fa-walking step-icon"></i>
          </div>

          <!-- Círculo pequeño -->
          <div class="step-item-small">
            <span>Sig</span>
            <i class="fas fa-chevron-right step-icon"></i>
          </div>

          <!-- Tercer círculo grande -->
          <div class="step-item-large">
            <i class="fas fa-dollar-sign step-icon"></i>
          </div>
        </div>

        <div class="buttons-container">
          <div class="icon-button">
            <div class="icon-circle-large">
              <i class="fas fa-dollar-sign icon"></i>
            </div>
            <span class="button-text">Monto</span>
          </div>

          <div class="icon-button">
            <div class="icon-circle-large">
              <i class="fas fa-file-invoice icon"></i>
            </div>
            <span class="button-text">Factura</span>
          </div>
        </div>

      </div>
    </div>
  </div>
</template>


<script lang="ts">
import {defineComponent} from "vue";
import WaveComponent from "@/components/WaveComponent.vue";

type Address = {
  name: string;
  active: boolean;
};

type Product = {
  name: string;
  detail: string;
};

export default defineComponent({
  name: "Order",
  components: {
    WaveComponent,
  },
  data() {
    return {
      isActive: true, // Estado del botón de encendido
      remainingTime: 2 * 60 * 60, // Temporizador inicial (en segundos)
      addresses: [
        {name: "San Antonio smog check", active: false},
        {name: "Dirección 2", active: false},
        {name: "Dirección 3", active: false},
      ] as Address[],
      products: [
        {name: "1 Lt de aceite", detail: "Aceite 123 de litro"},
        {name: "1 kg de jitomate", detail: "Jitomate maduro"},
        {name: "1 kg de arroz", detail: "Arroz"},
        {name: "3 cebollas", detail: "Cebollas moradas"},
        {name: "3 paquetes de galletas Marías", detail: "Galletas"},
      ] as Product[],
      status: "Proceso de compra" as
          | "Proceso de compra"
          | "Proceso de entrega"
          | "Favor cancelado",
    };
  },
  computed: {
    formattedTime(): string {
      const hours = Math.floor(this.remainingTime / 3600);
      const minutes = Math.floor((this.remainingTime % 3600) / 60);
      const seconds = this.remainingTime % 60;
      return `${String(hours).padStart(2, "0")}:${String(minutes).padStart(
          2,
          "0"
      )}:${String(seconds).padStart(2, "0")}`;
    },
    statusText(): string {
      return this.status;
    },
    statusColor(): string {
      switch (this.status) {
        case "Proceso de compra":
          return "#FFA500";
        case "Proceso de entrega":
          return "#B1C7D6";
        case "Favor cancelado":
          return "#FF4E4E";
        default:
          return "#B1C7D6";
      }
    },
  },
  methods: {
    toggleStatus() {
      this.isActive = !this.isActive;
    },
    toggleAddress(index: number) {
      this.addresses[index].active = !this.addresses[index].active;
    },
    cancelOrder() {
      if (this.status === "Proceso de compra") {
        this.status = "Favor cancelado";
      }
    },
    startCountdown() {
      if (this.remainingTime > 0) {
        setInterval(() => {
          if (this.remainingTime > 0) {
            this.remainingTime--;
          }
        }, 1000);
      }
    },
    openProductModal(product: Product) {
      console.log("Abriendo modal para:", product);
    },
  },
  mounted() {
    this.startCountdown();
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

.container-detail {
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
}

.badge-style {
  color: white;
  padding: 8px 16px;
  border-radius: 32px;
  font-size: 14px;
  font-weight: bold;
}

.bell-icon {
  color: #ffffff;
  font-size: 28px;
  font-weight: bold;
  display: flex;
  align-items: center;
  gap: 8px;
}


.status-container {
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
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: white;
  border-radius: 50%;
  padding: 6px;
  margin-right: 8px;
}

.status-text {
  color: white;
  margin-left: 8px;
}

/* Contenedor de detalles del pedido */
.details-container {
  background-color: rgba(255, 255, 255, 0.7);
  padding: 2rem;
  border-radius: 10px;
}

.details-title {
  color: #4A4A4A;
  margin-bottom: 1rem;
  font-size: 2rem;
  font-weight: bold;
}

/* Columna Izquierda (Perfil e Información del Usuario) */
.left-column {
  text-align: left;
}

.profile-avatar img {
  border-radius: 50%;
  width: 120px;
  height: 120px;
  object-fit: cover;
}

.user-info h2 {
  font-size: 1.25rem;
  margin-top: 0.5rem;
  font-weight: bold;
}

.user-role {
  font-size: 1rem;
  color: #4A8DA6;
}

.info-row {
  align-items: center;
  font-size: 0.9rem;
  margin-top: 0.5rem;
}

.info-icon {
  color: #4A4A4A;
  margin-right: 8px;
}

/* Step Progress de Direcciones */
.direction-buttons {
  display: flex;
  justify-content: space-evenly;
  align-items: center;
  position: relative;
  margin-top: 1.5rem;
}

.chat-container {
  display: flex;
  align-items: center;
  background-color: white;
  border: 2px solid #b1c7d6;
  border-radius: 50px;
  padding: 8px 16px;
  cursor: pointer;
  transition: background-color 0.3s, box-shadow 0.3s;
  box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.2);
}

.line-connector {
  position: absolute;
  top: 50%;
  left: 12%;
  right: 12%;
  height: 4px;
  background-color: #A0A0A0;
  z-index: -1;
}

.direction-button {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background-color: #B1C7D6;
  width: 80px;
  height: 80px;
  border-radius: 50%;
  cursor: pointer;
  transition: background-color 0.3s;
  z-index: 1;
}

.direction-button .direction-icon {
  color: #FFFFFF;
  font-size: 24px;
}

.direction-button.inactive .direction-icon {
  color: #A0A0A0;
}

.address-name {
  font-size: 0.8rem;
  color: #4A4A4A;
  text-align: center;
  margin-top: 1rem;
}

/* Columna del Medio */
.center-column {
  text-align: center;
  display: flex;
  flex-direction: column;
  align-items: center;
  padding-top: 2rem;
}

.chat-icon {
  color: #0066cc;
  font-size: 18px;
}

.chat-text {
  color: rgb(0, 0, 0);
  font-weight: bold;
  font-size: 16px;
}

.timer {
  font-size: 2rem;
  font-weight: bold;
  color: #4A8DA6;
  margin: 1rem 0;
}

.box-image {
  width: 256px;
  height: 128px;
  margin-top: 1rem;
}

/* Columna Derecha */
.right-column {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.status-bar {
  background-color: #f9a825; /* Color de fondo naranja claro */
  color: #ffffff; /* Color de texto blanco */
  border-radius: 20px; /* Bordes redondeados */
  padding: 6px 16px; /* Espaciado más pequeño */
  font-size: 14px; /* Tamaño de fuente más pequeño */
  font-weight: bold;
  text-align: center;
  cursor: pointer;
  box-shadow: none; /* Sin sombra */
  width: 350px;
  border: none;
  margin-bottom: 20px; /* Espaciado entre el botón y la tabla */

}

/* Título de la sección de productos */
.product-section-title {
  background-color: #566981;
  color: white;
  font-weight: bold;
  padding: 10px;
  border-radius: 8px 8px 0 0;
  text-align: left;
  font-size: 1.2rem;
  margin-top: 8px;
  width: 100%;
}

/* Contenedor principal de la lista de productos */
.product-list {
  max-height: 350px;
  overflow-y: auto;
  background-color: #e0e8f1;
  border-radius: 0 0 8px 8px;
  padding: 8px;
}

/* Elemento individual de la lista */
.product-item {
  display: grid;
  grid-template-columns: 0.5fr 3fr 0.5fr; /* Proporción para el número, producto y el icono */
  align-items: center;
  padding: 12px;
  border-bottom: 1px solid #ccc;
  background-color: white;
  border-radius: 8px;
  margin-bottom: 8px;
  box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
}

/* Estilos para las columnas */
.product-number {
  font-weight: bold;
  font-size: 1.2rem;
  color: #34344e;
  text-align: center;
}

.product-info {
  display: flex;
  flex-direction: column;
  color: #34344e;
  padding-left: 8px;
}

.product-name {
  font-weight: bold;
  font-size: 1rem;
  color: #34344e;
}

.product-description {
  font-size: 0.9rem;
  color: #6b7280;
  margin-top: 4px;
}

/* Columna del icono del ojo */
.eye-icon-column {
  text-align: right;
}

.eye-icon {
  color: #312070;
  font-size: 1.2rem;
  cursor: pointer;
}

/* Step Progress Component */

.step-progress {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-top: 16px;
  padding: 10px;
}

/* Estilo para los círculos grandes */
.step-item-large {
  width: 56px;
  height: 56px;
  background-color: #89A7B1; /* Color base para círculos grandes */
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
  border: 2px solid #d2e1e6;
}

.step-item-large-first {
  background-color: #566981; /* Color específico para el primer círculo grande */
}

.step-item-large .step-icon,
.step-item-large-first .step-icon {
  color: #ffffff;
  font-size: 1.5rem; /* Ajusta el tamaño del icono */
}

/* Estilo para los círculos pequeños */
.step-item-small {
  height: 40px;
  background-color: #3A415A; /* Color base para círculos pequeños */
  border-radius: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
  border: 2px solid #d2e1e6;
  padding: 16px;
  cursor: pointer;
}

.step-item-small .step-icon {
  color: #ffffff;
  font-size: 1.2rem; /* Ajusta el tamaño del icono */
}

.step-item-small span {
  color: #ffffff;
  margin-right: 8px;
}

.buttons-container {
  display: flex;
  justify-content: center;
  gap: 20px;
  margin-top: 20px;
}

.icon-button {
  display: flex;
  align-items: center;
  background-color: white;
  padding: 10px 15px;
  border-radius: 25px;
  box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease;
}

.icon-circle-large {
  width: 40px;
  height: 40px;
  background-color: #e6eef5;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 10px;
  border: 2px solid #b7cadb;
}

.icon-circle-large .icon {
  color: #4a8ada; /* Color del icono */
  font-size: 1.2rem;
}

.button-text {
  font-size: 1rem;
  color: #4a4a4a;
  font-weight: bold;
}

</style>
