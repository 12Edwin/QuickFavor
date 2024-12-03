<template>
  <div class="back-container">
    <WaveComponent :wave-height="800"/>
  </div>

  <div class="container-detail">
    <div class="card-header d-flex align-center justify-space-between">
      <h2 class="header-title">
        <i class="fas fa-cart-shopping fa-lg text-white" style="font-size: 36px;"></i>
        <span class="ml-4 fas text-white">O r d e n</span>
      </h2>
      <Switch @onFalse="" @onTrue=""/>
    </div>

    <div class="details-container">
      <div v-if="nothingToShow" class="no-orders-container">
        <img src="@/assets/empty2.png" width="200" alt="No Orders" class="no-orders-image"/>
        <p class="no-orders-text">No hay pedidos activos</p>
      </div>
      <div v-else>
      <div v-if="loading" class="loader-container">
        <v-progress-circular indeterminate color="primary"></v-progress-circular>
      </div>
      <div v-else>
        <div class="d-flex w-100 justify-space-between flex-wrap ga-1 mb-3">
          <h2 class="details-title">Detalles del pedido</h2>
          <div class="ml-auto">
            <div class="badge-style" :style="{'background-color': statusColor}">
              {{statusText}}
            </div>
          </div>
        </div>
        <div class="w-100 d-flex justify-end mb-5">
          <v-btn :disabled="status !== 'In shopping'" rounded class="cancel-button" color="red" @click="showConfirm('Canceled', 'Cancelado' )">
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
                <h2>{{ order?.customer_name }} {{ order?.customer_surname }}</h2>
                <p class="user-role">Cliente</p>
                <span class="info-row">
                  <i class="fas fa-phone info-icon"></i>
                  <span>{{ order?.customer_phone }}</span>
                </span>
                <br>
                <v-btn class="info-row" rounded @click="showAddress({lat: order?.place_lat, lng: order?.place_lng, name: 'Ubicación'})">
                  <i class="fas fa-eye info-icon"></i>
                  <span>Ubicación</span>
                </v-btn>
              </div>
            </div>

            <div class="direction-buttons">
              <div class="line-connector"></div>
              <div
                  v-for="(address, index) in order?.deliveryPoints || []"
                  :key="index"
                  class="direction-button"
                  @click="()=> !address.isClosed ? showAddress(address) : null"
              >
                <i :class="['fas', address.isClosed ? 'fa-ban' : 'fa-eye', 'direction-icon']"></i>
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

                <img alt="Caja" class="box-image position-static" src="@/assets/box.png"/>
              </div>
            </div>
          </v-col>
        </v-row>

        <div class="h-100 w-100">
          <div class="product-section-title">Productos</div>
          <v-card class="product-list" outlined>
            <v-list>
              <v-list-item
                  v-for="(product, index) in order?.products || []"
                  :key="index"
                  class="product-item"
              >
                <v-row align="center" no-gutters>
                  <v-col cols="1">
                    <span class="product-number">{{ index + 1 }}.</span>
                  </v-col>

                  <v-col class="product-info-column" cols="8">
                    <span class="product-name">{{ product.name }}</span>
                    <p class="product-description">{{ product.description }}</p>
                    <p class="product-amount">Cantidad: {{ product.amount }}</p>
                  </v-col>

                  <v-col class="eye-icon-column" cols="3">
                    <i class="fas fa-eye eye-icon"></i>
                  </v-col>
                </v-row>
              </v-list-item>
            </v-list>
          </v-card>

          <div class="step-progress">
            <div class="step-item-large step-item-large-first">
              <i class="fas fa-shopping-cart step-icon"></i>
            </div>

            <div class="step-item-small hovered" @click="status == 'In shopping' ? showConfirm('In delivery', 'En entrega'): null">
              <span>-</span>
              <i class="fas fa-chevron-right step-icon"></i>
            </div>

            <div class="step-item-large" :class="{'step-item-large-first': status == 'In delivery'}">
              <i class="fas fa-walking step-icon"></i>
            </div>

            <div class="step-item-small hovered" @click="status == 'In delivery' ? showConfirm('Finished', 'Completado'): null">
              <span>-</span>
              <i class="fas fa-chevron-right step-icon"></i>
            </div>

            <div class="step-item-large">
              <i class="fas fa-dollar-sign step-icon"></i>
            </div>
          </div>

          <div class="w-100">
            <v-progress-linear
                :color="white"
                height="15"
                rounded
                :active="true"
                :striped="true"
                :model-value="status === 'In shopping' ? 33 : status === 'In delivery' ? 66 : 100"
            ></v-progress-linear>
          </div>

          <div class="buttons-container">
            <div class="icon-button">
              <div class="input-container">
                <v-text-field
                  v-model="cost"
                  placeholder="Monto"
                  type="number"
                  outlined
                  rounded
                  :rules="[value => value > 0 || 'El monto debe ser al menos 100']"
                />
                <div class="icon-circle-large">
                  <i class="fas fa-dollar-sign icon"></i>
                </div>
              </div>
            </div>

            <TakePhoto label="Factura" @photo-taken="(value) => receipt = value"/>
          </div>

        </div>
      </div>
    </div>
    </div>
  </div>
  <MapModal v-if="showMap" :lat="selectedAddress.lat" :lng="selectedAddress.lng" @close="()=> showMap = false"/>
  <ConfirmationModal :message="`Estás seguro de cambiar el estado a ${statusToChange}`" :extraText="newStatus == 'Canceled' ? 'Ya has rechazado 2 pedidos, si cancelas este, se te penalizará': ''" :is-visible="showConfirmation" title="Editar estado" @confirm="() => changeStatus(newStatus)" @cancel="() => showConfirmation = false"/>
</template>

<script lang="ts">
import {defineComponent} from "vue";
import WaveComponent from "@/components/WaveComponent.vue";
import Switch from "@/components/Switch.vue";
import {cancelOrder, getOrderDetails, getStreamAxios, updateOrderState} from "@/modules/order/services/order.service";
import {
  Delivery,
  OrderPreviewEntity,
  SSEOrderMessage,
  UpdateStateOrderEntity
} from "@/modules/order/entity/order.entity";
import {showErrorToast, showPromiseToast, showWarningToast} from "@/kernel/alerts";
import {getErrorMessages, getNo_order, removeNo_order} from "@/kernel/utils";
import MapModal from "@/components/map_modal.vue";
import router from "@/router";
import ConfirmationModal from "@/kernel/confirmation_modal.vue";
import {ResponseEntity} from "@/kernel/error-response";
import TakePhoto from "@/components/take_photo.vue";

export default defineComponent({
  name: "Order",
  components: {
    TakePhoto,
    Switch,
    WaveComponent,
    MapModal,
    ConfirmationModal
  },
  data() {
    return {
      statusToChange: '',
      newStatus: '',
      cost: 0,
      receipt: '',
      showConfirmation: false,
      nothingToShow: false,
      remainingTime: 3600,
      order: null as OrderPreviewEntity | null,
      status: "In shopping",
      showMap: false,
      selectedAddress: { lat: 0, lng: 0, name: '' } as Delivery,
      loading: true
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
    statusColor(): string {
      switch (this.status) {
        case "In shopping":
          return "#FFA500";
        case "In delivery":
          return "#B1C7D6";
        case "Canceled":
          return "#FF4E4E";
        default:
          return "#B1C7D6";
      }
    },
    statusText(): string {
      switch (this.status) {
        case "In shopping":
          return "En Compras";
        case "In delivery":
          return "En Entrega";
        case "Canceled":
          return "Cancelado";
        default:
          return "Completado";
      }
    }
  },
  methods: {

    async connectToSSE() {
      try {
        const no_order = await getNo_order()
        if (!no_order) {
          this.nothingToShow = true;
          return;
        }
        await getStreamAxios(no_order, this.updateStatus);
      } catch (connectionError) {
        console.log("Error de conexión:", connectionError);
      }
    },

    async updateStatus(response: SSEOrderMessage){
      console.log(response);
      this.status = response.data.status
      this.remainingTime = Math.max(0, 7200 - Math.floor((Date.now() - new Date(response.data.order_created_at).getTime()) / 1000));
      if (this.status == 'Finished' || this.status == 'Canceled'){
        this.loading = false;
        await removeNo_order()
        await router.push({name: "map"});
      }
    },

    async getOrder(){
      this.loading = true;
      const no_order = await getNo_order()
      if (!no_order) {
        this.nothingToShow = true;
        return;
      }
      const resp = await getOrderDetails(no_order);
      console.log(resp);
      if (resp.error){
        showErrorToast(getErrorMessages(resp.message));
      } else {
        this.order = resp.data as OrderPreviewEntity;
        if (!this.order?.deliveryPoints){
          return;
        }
        for (let i = this.order?.deliveryPoints.length || 0; i < 3; i++){
          this.order?.deliveryPoints.push({name: '', lat: 0, lng: 0, isClosed: true});
        }
      }
      this.loading = false;
    },

    showConfirm(new_status: string, newStatusText: string){
      if (new_status == 'Finished'){
        if (this.cost < 1) return showWarningToast('El monto debe ser mayor a 0');
        if (!this.receipt) return showWarningToast('Debes subir una foto de la factura');
        if (this.receipt.includes('data:image/png;base64,')){
          this.receipt = this.receipt.replace('data:image/png;base64,', '');
        }
      }
      this.statusToChange = newStatusText;
      this.newStatus = new_status;
      this.showConfirmation = true;
    },

    async changeStatus(new_status: string){
      this.showConfirmation = false;
      const payload = {
        newStatus: new_status,
        no_order: await getNo_order()
      } as UpdateStateOrderEntity

      if (new_status == 'Canceled'){
        let resp = {} as ResponseEntity;
        const promise = new Promise(async (resolve, reject) => {
          resp = await cancelOrder(payload);
          if (resp.error){
            reject(resp);
          } else {
            resolve(resp);
          }
        });

        try {
          await showPromiseToast(promise,
              {
                pending: "Cancelando orden...",
                success: "Orden cancelada con éxito",
                error: "Error al actualizar la orden"
              }
          )
        } catch (e){}
        if (resp.error) {
          showErrorToast(getErrorMessages(resp.message));
        }
        return
      }

      if (new_status == 'Finished'){
        payload.cost = this.cost;
        payload.receipt = this.receipt;
      }

      let resp = {} as ResponseEntity;
      const promise = new Promise(async (resolve, reject) => {
        resp = await updateOrderState(payload);
        if (resp.error){
          reject(resp);
        } else {
          resolve(resp);
        }
      });
      try {
        await showPromiseToast(promise,
            {
              pending: "Actualizando estado de la orden...",
              success: "Orden actualizada con éxito",
              error: "Error al actualizar la orden"
            }
        )
      } catch (e){}
      if (resp.error) {
        showErrorToast(getErrorMessages(resp.message));
      }else {
        this.showConfirmation = false;
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

    showAddress(address: Delivery) {
      this.selectedAddress = {lat: address.lat, lng: address.lng, name: address.name} as Delivery
      console.log(this.selectedAddress);
      this.showMap = true;
    }
  },
  mounted() {
    this.startCountdown();
    this.getOrder();
    this.connectToSSE();
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

.badge-style {
  color: white;
  padding: 8px 16px;
  border-radius: 32px;
  font-size: 14px;
  font-weight: bold;
}

.bell-icon {
  color: #ffffff;
  font-size: 20px;
  font-weight: bold;
  display: flex;
  align-items: center;
  gap: 8px;
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

.details-container {
  background-color: rgba(255, 255, 255, 0.4);
  padding: 2rem;
  border-radius: 10px;
}

.loader-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100%;
}

.details-title {
  color: #4A4A4A;
  margin-bottom: 1rem;
  font-size: 2rem;
  font-weight: bold;
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
  justify-content: space-between;
  align-items: center;
  position: relative;
  margin-top: 1.5rem;
  width: 100%;
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
  opacity: 0.8;
  backdrop-filter: blur(10px);
  border-radius: 8px;
  margin: 8px;
  box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
}

/* Estilos para las columnas */
.product-number {
  font-weight: bold;
  font-size: 1rem;
  color: #34344e;
  text-align: left;
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
  justify-content: space-evenly;
  margin-top: 16px;
  padding: 10px;
  flex-wrap: wrap;
  gap: 1rem;
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
  width: 60px;
  background-color: #3A415A; /* Color base para círculos pequeños */
  border-radius: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
  border: 2px solid #d2e1e6;
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
}

.step-item-small .step-icon {
  color: #ffffff;
  font-size: 1.2rem; /* Ajusta el tamaño del icono */
}

.buttons-container {
  display: flex;
  justify-content: space-evenly;
  align-items: center;
  margin-top: 16px;
  padding: 10px;
  flex-wrap: wrap;
  gap: 1rem;
}

.icon-button {
  display: flex;
  flex-direction: column;
  align-items: center;
  cursor: pointer;
  transition: transform 0.3s;
}

.icon-button:hover {
  transform: scale(1.1);
}

.icon-circle-large {
  width: 56px;
  height: 56px;
  background-color: #566981;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
  border: 2px solid #d2e1e6;
}

.icon-circle-large .icon {
  color: #ffffff;
  font-size: 1.5rem; /* Ajusta el tamaño del icono */
}

.button-text {
  margin-top: 8px;
  font-size: 1rem;
  color: #4A4A4A;
}

.no-orders-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100%;
  text-align: center;
}

.no-orders-image {
  max-width: 300px;
  margin-bottom: 20px;
}

.no-orders-text {
  font-size: 1.5rem;
  color: #4A4A4A;
}

.hovered:hover {
  transform: scale(1.2);
  transition: all 0.3s;
  cursor: pointer;
  box-shadow: 0px 8px 8px rgba(0, 0, 0, 0.3);
}

.hovered {
  transition: all 0.3s;
  transform: scale(1);
  cursor: pointer;
}

.input-container {
  position: relative;
  display: flex;
  align-items: center;
}

.input-container input {
  flex: 1;
  padding-right: 40px; /* Espacio para el icono */
}

.input-container .icon-circle-large {
  position: absolute;
  top: 0;
  right: 0;
}
</style>