<template>
  <div class="back-container">
    <WaveComponent />
  </div>
  <div class="history-container">
    <div class="card-header d-flex align-center justify-space-between">
      <h2 class="header-title">
        <i class="fas fa-history fa-lg text-white" style="font-size: 36px"></i>
        <span class="ml-4 fas text-white">D E T A L L E S</span> <span class="ml-4 fas text-white">D E </span> <span class="ml-4 fas text-white">H I S T O R I A L </span>
      </h2>
      <Switch @onFalse="toggleStatus" @onTrue="toggleStatus" />
    </div>
    <div class="content-container">
      <transition-group>
        <transition name="fade" key="loading">
          <div v-if="isLoading" class="loader-container">
            <v-progress-circular indeterminate color="primary"></v-progress-circular>
          </div>
        </transition>
        <transition name="fade" key="content">
          <div v-if="!isLoading" class="left-section">
          <div class="left-content">
            <v-avatar color="#D9D9D9D9" size="200" class="avatar-border">
              <img
                src="@/assets/profile.png"
                alt="User Avatar"
                style="width: 100%; height: 100%; border-radius: 50%"
              />
            </v-avatar>
            <p class="username">{{ historyItem.customer_name || '' }} {{ historyItem.customer_surname || '' }}</p>
            <v-chip
              :color="getChipColor(historyItem.status)"
              variant="flat"
              class="chip-style"
            >
              <span style="color: white">{{getStatus (historyItem.status) }}</span>
            </v-chip>
            <v-divider
              class="chip-divider border-opacity-100"
              :thickness="4"
              color="#A3BBBF"
            ></v-divider>
            <div v-if="historyItem.status != 'Canceled'">
              <p class="completion-text">Tiempo transcurrido:</p>
              <p class="completion-status">{{ getMinutesDifference(historyItem.order_created_at, historyItem.order_finished_at) }} / 120 minutos</p>
            </div>
            <div v-else>
              <p class="completion-text">Tiempo transcurrido:</p>
              <p class="completion-status">Cancelado</p>
            </div>
          </div>
        </div>
        </transition>
        <transition name="fade" key="content2">
          <div v-if="!isLoading" class="details-section">
        <div class="header-container">
          <div class="left-stripe"></div>
          <p class="header-text">Productos</p>
        </div>

        <div v-if="historyItem.products.length === 0" class="no-products">
          <img
            src="../../../assets/carro-vacio.png"
            alt="No hay productos"
            class="no-products-image"
          />
          <p class="no-products-text">Aún no hay productos en esta orden</p>
        </div>

        <v-table v-else height="320px" fixed-header>
          <thead>
            <tr>
              <th class="text-center">Nombre</th>
              <th class="text-center">Detalles</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="producto in historyItem.products" :key="producto.name">
              <td>{{ producto.name }}</td>
              <td>
                <v-icon
                  @click="viewDetails(producto)"
                  color="#0066cc"
                  class="fa-solid fa-eye icon-eye"
                >
                  mdi-eye
                </v-icon>
              </td>
            </tr>
          </tbody>
        </v-table>

        <div class="summary-container">
          <div class="summary-details">
            <div v-if="historyItem.cost !== null">
              <div class="summary-item">
                <span>Costo de la orden:</span>
                <span class="summary-value">$ {{ historyItem.cost }}</span>
              </div>
              <div class="summary-item">
                <span>Costo de servicio:</span>
                <span class="summary-value">$100</span>
              </div>
              <div class="summary-item total">
                <span>Total:</span>
                <span class="summary-value total-value"
                  >$ {{ historyItem.cost + 100 }}</span
                >
              </div>
            </div>
            <div v-else>
              <p class="summary-placeholder text-center">Por establecer</p>
            </div>
          </div>

          <div class="summary-button-container">
            <button
              class="summary-button"
              v-if="historyItem.receipt_url"
              @click="viewReceipt"
            >
              <div class="icon-circle-summary">
                <i class="fa-solid fa-eye"></i>
              </div>
              Factura
            </button>
          </div>
        </div>
      </div>
        </transition>
      </transition-group>
    </div>

    <v-dialog v-if="!isLoading" v-model="dialog" max-width="600" class="centered-dialog">
      <v-card>
        <v-card-title>Detalles del Producto</v-card-title>
        <v-card-text class="product-details">
          <div class="product-info">
            <div class="product-left">
              <p class="product-name">{{ selectedProduct.name }}</p>
              <div class="product-description">
                <span>{{ selectedProduct.description }}</span>
              </div>
            </div>
            <div class="product-right">
              <p class="product-quantity-title">Cantidad</p>
              <p class="product-quantity">{{ selectedProduct.amount }}</p>
            </div>
          </div>
        </v-card-text>
        <v-card-actions>
          <v-btn class="ms-auto" @click="dialog = false">Cerrar</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <v-dialog v-if="!isLoading" v-model="receiptDialog" max-width="800" class="centered-dialog">
      <v-card>
        <v-card-title>Factura</v-card-title>
        <v-card-text>
          <img
            :src="historyItem.receipt_url"
            alt="Factura"
            class="receipt-img"
          />
        </v-card-text>
        <v-card-actions>
          <v-btn class="ms-auto" @click="receiptDialog = false">Cerrar</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>

</template>

<script lang="ts">
import { defineComponent, ref } from "vue";
import axios from "axios";
import WaveComponent from "@/components/WaveComponent.vue";

export default defineComponent({
  name: "HistoryDetailsView",
  components: { WaveComponent },
  props: {
    id: {
      type: String,
      required: true,
    },
  },
  data() {
    return {
      isLoading: true,
      isActive: true,
      dialog: false,
      receiptDialog: false, // Nuevo estado para el modal de factura
      selectedProduct: { name: "", description: "", amount: 0 },
      historyItem: null as any,
    };
  },
  mounted() {
    this.fetchOrderDetails();
  },
  methods: {
    toggleStatus() {
      this.isActive = !this.isActive;
    },
    getMinutesDifference(startDate: string | null, endDate: string | null) {
      if (!startDate || !endDate) {
        return 0;
      }
      const start = new Date(startDate);
      const end = new Date(endDate);
      const diffMs = end.getTime() - start.getTime();
      return Math.floor(diffMs / 60000);
    },
    async fetchOrderDetails() {
      try {
        const token = localStorage.getItem("token");
        if (!token) {
          console.error("Token no encontrado en el localStorage.");
          return;
        }

        const response = await axios.get(
          `http://54.164.226.143:3000/favor/details/${this.id}`,
          {
            headers: {
              Authorization: `Bearer ${token}`,
            },
          }
        );

        if (response.data.code === 200 && !response.data.error) {
          this.historyItem = response.data.data;
        } else {
          console.error(
            "Error al obtener los detalles de la orden:",
            response.data.message
          );
        }
      } catch (error) {
        console.error("Error al hacer la solicitud al backend:", error);
      } finally {
        this.isLoading = false;
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

    getStatus(status: string) {
      switch (status) {
        case "Pending":
          return "Pendiente";
        case "In delivery":
          return "En entrega";
        case "In shopping":
          return "En compra";
        case "Finished":
          return "Finalizado";
        case "Canceled":
          return "Cancelado";
        default:
          return "Desconocido";
      }
    },
    viewDetails(product: any) {
      this.selectedProduct = product;
      this.dialog = true;
    },
    viewReceipt() {
      this.receiptDialog = true;
    },
    formatDate(dateString: string) {
      return new Date(dateString).toLocaleString();
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

/* Contenedor principal para la sección izquierda y derecha */
.content-container {
  background-color: rgba(255, 255, 255, 0.4);
  display: flex;
  gap: 20px;
  align-items: flex-start; /* Alinea los elementos al inicio verticalmente */
  padding: 20px;
}

/* Estilo para la sección izquierda */
.left-section {
  flex-basis: 20%;
  display: flex;
  justify-content: center;
}

.left-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  margin-top: 0; /* Ajuste adicional si es necesario */
}

.chip-divider {
  margin-top: 20px; /* Ajusta este valor si es necesario para la distancia deseada */
  width: 100%; /* Asegura que el divider ocupe todo el ancho del contenedor */
}

.completion-text,
.completion-status {
  margin: 8px 0 0; /* Ajusta el margen superior para controlar el espacio entre el divider y el texto */
  font-size: 20px;
  color: #34344e;
  text-align: center;
}

.completion-status {
  font-weight: bold;
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
}

.details-section table th,
.details-section table td {
  text-align: center;
  vertical-align: middle;
}

.summary-placeholder {
  font-size: 18px;
  font-weight: bold;
  color: #34344e;
  text-align: center;
}

.summary-container {
  background-color: #ffffff;
  border-radius: 12px;
  padding: 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
  margin-top: 40px;
}

.summary-details {
  flex: 0 0 80%; /* Ocupa el 80% del ancho */
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.summary-item {
  display: flex;
  justify-content: space-between;
  font-size: 18px;
  color: #34344e;
}

.summary-value {
  font-weight: normal;
}

.total {
  font-weight: bold;
}

.total-value {
  font-weight: bold;
  color: #34344e;
}

.summary-button-container {
  flex: 0 0 20%; /* Ocupa el 20% del ancho */
  display: flex;
  justify-content: center;
  align-items: center;
}

.summary-button {
  background-color: #fff;
  color: #34344e;
  border: none;
  border-radius: 30px;
  padding: 8px 20px 8px 40px; /* Espacio adicional a la izquierda para el icono */
  font-size: 16px;
  font-weight: bold;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 8px;
  box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.2);
  position: relative;
  overflow: visible; /* Permite que el círculo sobresalga */
}

.icon-circle-summary {
  background-color: #ffffff;
  color: #312070;
  border-radius: 50%;
  width: 50px;
  height: 50px;
  display: flex;
  align-items: center;
  justify-content: center;
  position: absolute;
  left: -20px; /* Ajusta la posición para que sobresalga */
  box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.15);
  border: 2px solid #89a7b1; /* Borde de color #89A7B1 */
}

.summary-button i {
  color: #312070;
}

.no-products {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100%;
  text-align: center;
}

.no-products-image {
  width: 200px; /* Ajusta el tamaño según sea necesario */
  height: auto;
  margin-top: 20px;
}

.no-products-text {
  margin-top: 10px;
  font-size: 18px;
  color: #34344e;
}

.centered-dialog {
  display: flex;
  justify-content: center;
  align-items: center;
}

.product-details {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.product-info {
  display: flex;
  justify-content: space-between;
  align-items: center;
  width: 100%;
}

.product-left {
  text-align: left;
  flex: 1;
}

.product-name {
  font-size: 16px;
  font-weight: bold;
  margin-bottom: 10px;
  color: #34344e;
}

.product-description {
  background-color: #d3d3d3;
  border-radius: 8px;
  padding: 10px;
  text-align: center;
  color: #34344e;
  font-size: 14px;
  margin-top: 1px;
  height: 80px;
}

.product-right {
  text-align: right;
  flex: 1;
}

.product-quantity-title {
  font-weight: bold;
  color: #34344e;
  margin-left: 10px;
}

.product-quantity {
  font-size: 50px;
  font-weight: bold;
  color: #34344e;
  margin-right: 25px;
}

/* Estilo para el contenedor de Productos */
.header-container {
  display: flex;
  align-items: center;
  background-color: #566981;
  color: #ffffff;
  border-radius: 4px;
  margin-top: 10px; /* Aju    ste para posicionarlo más arriba */
  height: 40px;
}

.icon-eye {
  cursor: pointer;
  font-size: 24px;
  color: #312070;
}

.left-stripe {
  width: 20px;
  background-color: #89a7b1;
  height: 100%;
  margin-right: 15px;
}

.header-text {
  font-size: 20px;
  font-weight: bold;
  color: #ffffff;
}

.avatar-border {
  border: 4px solid #89a7b1; /* Borde de color #89a7b1 */
  border-radius: 50%; /* Mantiene la forma circular */
  padding: 4px; /* Espacio entre la imagen y el borde */
  box-sizing: border-box; /* Asegura que el tamaño total del avatar incluya el borde */
  margin-top: 20px;
}

.chip-style {
  font-size: 14px;
  font-weight: bold;
  width: 150px; /* Ancho fijo para el chip */
  display: flex;
  justify-content: center;
  margin-top: 12px;
}


@media (max-width: 768px) {
  .history-container {
    height: 88vh; /* Ocupa toda la altura de la pantalla */
    overflow-y: auto; /* Permite desplazamiento vertical */
    padding: 0px;
    display: flex;
    flex-direction: column;
    gap: 10px; /* Espacio entre los elementos */
    align-items: center; /* Centra los elementos horizontalmente */
  }

  /* Contenedor para la sección de título */
  .title-container {
    flex-shrink: 0; /* Mantiene el tamaño del contenedor de título fijo */
    width: 400px;
    display: flex;
    justify-content: center; /* Centra el título y el botón de estado */
  }

  .header-container {
    width: 100%; /* Asegura que abarque todo el ancho de la tabla */
    display: flex;
    align-items: center;
    justify-content: center; /* Centra el texto horizontalmente */
    background-color: #566981;
    color: #ffffff;
    border-radius: 4px 4px 0 0; /* Bordes redondeados en la parte superior */
    height: 40px;
    margin-top: 10px;
  }

  .header-text {
    font-size: 20px;
    font-weight: bold;
    color: #ffffff;
    text-align: center;
    width: 100%; /* Hace que el texto ocupe todo el ancho disponible */
    margin: 0; /* Elimina el margen */
  }

  .v-table {
    width: 100%; /* Hace que la tabla abarque el mismo ancho que el contenedor */
    border-collapse: collapse; /* Opcional: ayuda a eliminar espacios entre las celdas */
  }

  .v-table th,
  .v-table td {
    text-align: center;
    padding: 8px; /* Ajusta el espaciado si es necesario */
  }

  /* Contenedor para el contenido principal */
  .content-container {
    flex-direction: column;
    align-items: center;
    width: 100%;
  }

  /* Estilo para la sección izquierda */
  .left-section {
    flex-basis: 100%;
    display: flex;
    justify-content: center;
    align-items: center;
    margin-bottom: 20px; /* Añade espacio inferior para separación */
    width: 100%;
  }

  /* Estilo para la sección de detalles */
  .details-section {
    flex-basis: 100%;
    display: flex;
    flex-direction: column;
    align-items: center; /* Centra el contenido horizontalmente */
    width: 100%;
  }

  /* Ajuste para la tabla de productos */
  .v-table {
    max-width: 100%;
    overflow-y: auto;
  }

  /* Ajuste para el contenedor de sumario */
  .summary-container {
    display: flex;
    flex-direction: column;
    align-items: center; /* Centra el contenido del sumario */
    margin-top: 20px;
    width: 100%;
    height: 290px;
  }

  .summary-item {
    display: flex;
    justify-content: space-between;
    font-size: 22px;
    color: #34344e;
  }

  .summary-button-container {
    display: flex;
    justify-content: center;
    align-items: center;
    position: relative;
    margin-bottom: 50px;
  }

  .status-container {
    flex-grow: 0;
    margin-left: 20px;
  }

  .status-button {
    width: 100%;
    max-width: 200px;
  }
}

.loader-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100%;
}

.fade-enter-active, .fade-leave-active {
  transition: opacity 0.5s;
}
.fade-enter, .fade-leave-to /* .fade-leave-active in <2.1.8 */ {
  opacity: 0;
}
</style>
