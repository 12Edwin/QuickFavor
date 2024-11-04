<template>
  <div class="back-container">
    <WaveComponent />
  </div>

  <!-- Header con fondo azul y iconos de Font Awesome -->
  <div class="title-container">
    <i class="fas fa-bell bell-icon"> O r d e n</i>
    <div class="status-container">
      <button
        class="status-button"
        :class="{ inactive: !isActive }"
        @click="toggleStatus"
      >
        <div class="icon-circle" :class="{ 'inactive-icon': !isActive }">
          <i :class="['fas', 'fa-power-off', isActive ? 'power-icon' : 'power-icon-inactive']"></i>
        </div>
        <span class="status-text">{{ isActive ? "Activo" : "Inactivo" }}</span>
      </button>
    </div>
  </div>

  <!-- Contenedor de detalles en fondo blanco -->
  <v-container class="details-container" fluid>
    <h2 class="details-title">Detalles del pedido</h2>
    <v-row justify="space-between" align="start">
      <!-- Columna Izquierda -->
      <v-col cols="4" class="left-column">
        <v-row align="center">
          <v-col cols="auto" class="profile-avatar">
            <v-avatar size="120">
              <img src="@/assets/profile.png" alt="User Avatar" />
            </v-avatar>
          </v-col>
          <v-col>
            <h2>Juan Rodrigo</h2>
            <p class="user-role">Cliente</p>
            <v-row align="center" class="info-row">
              <i class="fas fa-phone info-icon"></i>
              <span>777-234-4325</span>
            </v-row>
            <v-row align="center" class="info-row">
              <i class="fas fa-eye info-icon"></i>
              <span>Ubicación</span>
            </v-row>
          </v-col>
        </v-row>

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

      <!-- Columna del Medio -->
      <v-col cols="4" class="center-column">
        <!-- Botón de chatear -->
       <div class="chat-container">
         <div class="icon-circle">
           <i class="fas fa-comment-dots chat-icon"></i> <!-- Cambiado a un icono de mensaje tipo messenger -->
         </div>
         <span class="chat-text">Chatear</span>
       </div>



        <!-- Temporizador -->
        <div class="timer">{{ formattedTime }}</div>

        <!-- Imagen de la caja -->
        <img src="@/assets/box.png" alt="Caja" class="box-image" />
      </v-col>

      <!-- Columna Derecha -->
      <v-col cols="4" class="right-column">
        <!-- Barra de estado -->
        <v-btn :color="statusColor" class="status-bar" rounded>{{ statusText }}</v-btn>
        <!-- Botón de cancelar -->
        <v-btn :disabled="status !== 'Proceso de compra'" color="#A9A9A9" class="cancel-button" @click="cancelOrder">
          Cancelar
        </v-btn>
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
                  <v-col cols="1" class="product-number-column">
                    <span class="product-number">{{ index + 1 }}.</span>
                  </v-col>
                
                  <!-- Segunda columna: Nombre y descripción del producto -->
                  <v-col cols="8" class="product-info-column">
                    <span class="product-name">{{ product.name }}</span>
                    <p class="product-description">{{ product.detail }}</p>
                  </v-col>
                
                  <!-- Tercera columna: Icono del ojo -->
                  <v-col cols="3" class="eye-icon-column">
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
                <i class="fas fa-chevron-right step-icon"></i>
              </div>

              <!-- Segundo círculo grande -->
              <div class="step-item-large">
                <i class="fas fa-walking step-icon"></i>
              </div>

              <!-- Círculo pequeño -->
              <div class="step-item-small">
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

      </v-col>
    </v-row>
  </v-container>
</template>


<script lang="ts">
import { defineComponent } from "vue";
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
        { name: "San Antonio smog check", active: false },
        { name: "Dirección 2", active: false },
        { name: "Dirección 3", active: false },
      ] as Address[],
      products: [
        { name: "1 Lt de aceite", detail: "Aceite 123 de litro" },
        { name: "1 kg de jitomate", detail: "Jitomate maduro" },
        { name: "1 kg de arroz", detail: "Arroz" },
        { name: "3 cebollas", detail: "Cebollas moradas" },
        { name: "3 paquetes de galletas Marías", detail: "Galletas" },
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
/* Contenedor principal */
.back-container {
  width: 100%;
  overflow: hidden;
  position: absolute;
  bottom: 0;
  left: 0;
  z-index: -1;
}

.order-container {
  height: 100vh;
  padding: 16px;
  display: flex;
  flex-direction: column;
  background-color: #CBDAD5;
}

/* Header con título y botón de estado */
.title-container {
  display: flex;
  align-items: center;
  background-color: #566981; /* Fondo azul del encabezado */
  padding: 1rem;
  border-radius: 10px;
  justify-content: space-between;
}

.bell-icon {
  color: #ffffff;
  font-size: 20px; /* Tamaño del ícono */
  font-weight: bold; /* Hace que el texto "Orden" sea audaz */
  display: flex;
  align-items: center;
  gap: 8px; /* Espacio entre el ícono y el texto */
}

.titlePrincipal {
  font-size: 20px; /* Asegúrate de que el tamaño del texto sea consistente */
  font-weight: bold;
  color: #ffffff;
  display: flex;
  align-items: center;
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

.power-icon {
  color: #0066cc;
  font-size: 18px;
}

.power-icon-inactive {
  color: #f70b0b;
  font-size: 18px;
}

.status-text {
  color: white;
  margin-left: 8px;
}

/* Contenedor de detalles del pedido */
.details-container {
  background-color: #FFFFFF;
  padding: 1.5rem;
  border-radius: 10px;
}

.details-title {
  color: #4A4A4A;
  margin-bottom: 1rem;
  font-size: 1.5rem;
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
  justify-content: space-around;
  align-items: center;
  position: relative;
  margin-top: 1.5rem;
}

.chat-container {
  display: flex;
  align-items: center;
  background-color: white; /* Fondo blanco */
  border: 2px solid #b1c7d6; /* Borde para diferenciar del fondo */
  border-radius: 50px;
  padding: 8px 16px;
  cursor: pointer;
  transition: background-color 0.3s, box-shadow 0.3s;
  box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.2);
  position: relative; /* Necesario para el efecto sobresaliente */
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

.chat-button {
  display: flex;
  align-items: center;
  background-color: #E1E8F0;
  color: #4A4A4A;
  padding: 0.5rem 1rem;
  font-size: 1rem;
  margin-bottom: 1rem;
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

.cancel-button {
  background-color: #d32f2f; /* Color de fondo rojo */
  color: #ffffff; /* Color de texto blanco */
  border-radius: 20px; /* Bordes redondeados */
  padding: 6px 16px; /* Espaciado más pequeño */
  font-size: 14px; /* Tamaño de fuente más pequeño */
  font-weight: bold;
  text-align: center;
  cursor: pointer;
  box-shadow: none; /* Sin sombra */
  width: 200px;
  border: none;
  margin-top: 10px; /* Espaciado entre el botón de arriba */
  margin-bottom: 20px; /* Separación entre el botón "Cancelar" y la tabla */
  margin: 0 auto 20px auto; /* Centrado horizontal */


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
  width: 85%;
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
  width: 40px;
  height: 40px;
  background-color: #3A415A; /* Color base para círculos pequeños */
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
  border: 2px solid #d2e1e6;
}

.step-item-small .step-icon {
  color: #ffffff;
  font-size: 1.2rem; /* Ajusta el tamaño del icono */
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
