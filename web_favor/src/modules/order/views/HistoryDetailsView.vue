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
          <p class="username">{{ historyItem.nombreCliente }}</p>
          <v-chip
            :color="getChipColor(historyItem.estatus)"
            variant="flat"
            class="chip-style"
          >
            <span style="color: white">{{ historyItem.estatus }}</span>
          </v-chip>
          <v-divider
            class="chip-divider border-opacity-100"
            :thickness="4"
            color="#A3BBBF"
          ></v-divider>
          <p class="completion-text">Completado en</p>
          <p class="completion-status">{{ historyItem.tiempoCompletado }}</p>
        </div>
      </div>

      <!-- Sección derecha con los detalles -->
      <div class="details-section">
        <div class="header-container">
          <div class="left-stripe"></div>
          <p class="header-text">Productos</p>
        </div>

        <div v-if="historyItem.productos.length === 0" class="no-products">
          <img
            src="../../../assets/carro-vacio.png"
            alt="No hay productos"
            class="no-products-image"
          />
          <p class="no-products-text">Aún no hay productos en esta cuenta</p>
        </div>

        <v-table v-else height="320px" fixed-header>
          <thead>
            <tr>
              <th class="text-center">Nombre</th>
              <th class="text-center">Detalles</th>
            </tr>
          </thead>
          <tbody>
            <tr
              v-for="producto in historyItem.productos"
              :key="producto.nombre"
            >
              <td>{{ producto.nombre }}</td>
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
          <!-- Contenedor izquierdo para los datos -->
          <div class="summary-details">
            <div v-if="historyItem.subtotal > 0">
              <div class="summary-item">
                <span>Subtotal:</span>
                <span class="summary-value">$ {{ historyItem.subtotal }}</span>
              </div>
              <div class="summary-item">
                <span>Costo de servicio:</span>
                <span class="summary-value">$100</span>
              </div>
              <div class="summary-item total">
                <span>Total:</span>
                <span class="summary-value total-value"
                  >$ {{ historyItem.subtotal + 100 }}</span
                >
              </div>
            </div>
            <div v-else>
              <p class="summary-placeholder text-center">Por establecer</p>
            </div>
          </div>

          <!-- Contenedor derecho para el botón -->
          <div class="summary-button-container">
            <button class="summary-button">
              <div class="icon-circle-summary">
                <i class="fa-solid fa-eye"></i>
              </div>
              Factura
            </button>
          </div>
        </div>
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

    <v-dialog v-model="dialog" max-width="600" class="centered-dialog">
      <v-card>
        <v-card-title>Detalles del Producto</v-card-title>
        <v-card-text class="product-details">
          <div class="product-info">
            <div class="product-left">
              <p class="product-name">{{ selectedProduct.nombre }}</p>
              <div class="product-description">
                <span>{{ selectedProduct.descripcion }}</span>
              </div>
            </div>
            <div class="product-right">
              <p class="product-quantity-title">Cantidad</p>
              <p class="product-quantity">{{ selectedProduct.cantidad }}</p>
            </div>
          </div>
        </v-card-text>
        <v-card-actions>
          <v-btn class="ms-auto" @click="dialog = false">Cerrar</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script lang="ts">
import WaveComponent from "@/components/WaveComponent.vue";
import { defineComponent, computed } from "vue";

// Define el tipo para cada elemento en `data`
interface Producto {
  nombre: string;
  descripcion: string;
  cantidad: number;
}

interface HistorialItem {
  nombreCliente: string;
  numeroProductos: number;
  fecha: string;
  estatus: string;
  tiempoCompletado: string;
  subtotal: number;
  productos: Producto[];
}

export default defineComponent({
  name: "HistoryDetailsView",
  components: { WaveComponent },
  props: {
    id: {
      type: Number,
      required: true,
    },
  },
  data() {
    return {
      isActive: true, // Variable para manejar el estado del botón
      dialog: false,
      selectedProduct: {} as Producto,
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
    viewDetails(producto: Producto) {
      this.selectedProduct = producto;
      this.dialog = true;
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

.products-table {
  max-height: 350px; /* Ajusta esta altura según tus necesidades */
  overflow-y: auto; /* Permite que la tabla tenga desplazamiento vertical */
  text-align: center;
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

/* Estilo para el contenedor del título */
.title-container {
  width: 100%;
  background-color: #566981; /* Color de fondo azul claro */
  padding: 16px;
  display: flex;
  justify-content: left;
  align-items: center;
  margin-bottom: 20px;
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
  margin-bottom: 30px;
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
    flex-direction: column; /* Muestra las secciones en columna */
    align-items: center; /* Centra los elementos horizontalmente */
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

  /* Ajuste del botón de factura */
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
    max-width: 200px; /* Define un ancho máximo solo en móviles */
  }
}
</style>
