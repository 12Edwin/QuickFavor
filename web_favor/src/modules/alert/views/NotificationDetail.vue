<template>
  <v-dialog v-model="isVisible" max-width="800px" @open="getOrder">
    <v-card class="modal-container">
      <v-card-title>
        <span class="headline">Detalles de la Notificación</span>
        <v-btn icon @click="close" position="absolute" class="top-0 right-0">
          <i class="fas fa-times"></i>
        </v-btn>
      </v-card-title>
      <v-card-text>
        <div v-if="loading" class="loader-container">
          <v-progress-circular indeterminate color="primary"></v-progress-circular>
        </div>
        <div v-else>
          <!-- Contenido del modal -->
          <h2 class="details-title">Detalles del pedido</h2>
          <v-row justify="space-between">
            <v-col xl="6" lg="6" md="12" sm="12">
              <div class="d-flex justify-start">
                <div class="profile-avatar">
                  <v-avatar size="120">
                    <img alt="User Avatar" width="120" src="@/assets/profile.png"/>
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
                <div class="direction-b h-100"
                  v-for="(address, index) in order?.deliveryPoints || []"
                  :key="index">
                <div
                    class="direction-button"
                    @click="()=> !address.isClosed ? showAddress(address) : null"
                >
                  <i :class="['fas', address.isClosed ? 'fa-ban' : 'fa-eye', 'direction-icon']"></i>
                </div>
                <p v-if="!address.isClosed" class="address-name">{{ address.name }}</p>
                </div>
              </div>
            </v-col>
            <v-col xl="6" lg="6" md="12" sm="12" class="d-block" >
              <div class="d-flex justify-center">
                <div class="timer text-center"><p>{{ formattedTime }}</p></div>
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
            <div class="buttons-container">
              <div class="icon-button" @click="openPopup">
                <div class="icon-circle-large" style="background: red" @click="showConfirm('Reject', 'Rechazado')">
                  <i class="fas fa-cancel icon"></i>
                </div>
                <span class="button-text">Rechazar</span>
              </div>

              <div class="icon-button ms-4" @click="openPopup">
                <div class="icon-circle-large" @click="showConfirm('Accept', 'Aceptado')">
                  <i class="fas fa-check-circle icon"></i>
                </div>
                <span class="button-text">Aceptar</span>
              </div>
            </div>
          </div>
        </div>
      </v-card-text>
    </v-card>
  </v-dialog>
  <MapModal v-if="showMap" :lat="selectedAddress.lat" :lng="selectedAddress.lng" @close="()=> showMap = false"/>
  <ConfirmationModal :message="`Estás seguro de cambiar el estado a ${statusToChange}`" :is-visible="showConfirmation" title="Editar estado" @confirm="() => changeStatus(newStatus)" @cancel="() => showConfirmation = false"/>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import WaveComponent from "@/components/WaveComponent.vue";
import Switch from "@/components/Switch.vue";
import { getOrderDetails } from "@/modules/order/services/order.service";
import { Delivery, OrderPreviewEntity} from "@/modules/order/entity/order.entity";
import { showErrorToast, showPromiseToast, showWarningToast } from "@/kernel/alerts";
import {
  getCurrentLocation,
  getErrorMessages,
  getNo_courierByToken,
  setNo_order
} from "@/kernel/utils";
import MapModal from "@/components/map_modal.vue";
import ConfirmationModal from "@/kernel/confirmation_modal.vue";
import { ResponseEntity } from "@/kernel/error-response";
import {AcceptFavorEntity, LocationEntity} from "@/modules/alert/entity/notification.entity";
import {acceptFavor, rejectFavor} from "@/modules/alert/services/notification.service";
import Router from "@/router";

export default defineComponent({
  name: "NotificationDetail",
  components: {
    Switch,
    WaveComponent,
    MapModal,
    ConfirmationModal
  },
  props: {
    isVisible: {
      type: Boolean,
      required: true
    },
    id_order: {
      type: String,
      required: true
    }
  },

  watch: {
    isVisible(val) {
      if (val) {
        this.getOrder()
      }
    }
  },
  data() {
    return {
      statusToChange: '',
      newStatus: '',
      showConfirmation: false,
      remainingTime: 3600,
      order: null as OrderPreviewEntity | null,
      showMap: false,
      selectedAddress: { lat: 0, lng: 0, name: '' } as Delivery,
      loading: true
    };
  },
  computed: {
    formattedTime(): string {
      const minutes = Math.floor(this.remainingTime / 60);
      const seconds = this.remainingTime % 60;
      return `${String(minutes).padStart(2, "0")}:${String(seconds).padStart(2, "0")}`;
    }
  },
  methods: {
    async getOrder() {
      this.loading = true;
      const no_order = this.id_order;
      const resp = await getOrderDetails(no_order);
      if (resp.error) {
        showErrorToast(getErrorMessages(resp.message));
      } else {
        this.order = resp.data as OrderPreviewEntity;
        this.remainingTime = Math.max(0, 600 - Math.floor((Date.now() - new Date(this.order.order_created_at).getTime()) / 1000));
        if (!this.order?.deliveryPoints) {
          return;
        }
        for (let i = this.order?.deliveryPoints.length || 0; i < 3; i++) {
          this.order?.deliveryPoints.push({ name: '', lat: 0, lng: 0, isClosed: true });
        }
      }
      this.startCountdown();
      this.loading = false;
    },
    close() {
      this.$emit('onClose');
    },
    showConfirm(new_status: string, newStatusText: string) {
      this.statusToChange = newStatusText;
      this.newStatus = new_status;
      this.showConfirmation = true;
    },
    async changeStatus(new_status: string) {
      this.showConfirmation = false;
      const location = await getCurrentLocation();
      if (!location) {
        showWarningToast("No se pudo obtener la ubicación actual");
        return;
      }
      const courier_id = await getNo_courierByToken();
      if (!courier_id) {
        showErrorToast("No se pudo obtener la información del repartidor");
        return;
      }
      const payload = {
        courier_id,
        order_id: this.id_order,
        location: location as LocationEntity,
      } as AcceptFavorEntity

      let resp = {} as ResponseEntity;
      const promise = new Promise(async (resolve, reject) => {
        resp = new_status.includes('Reject') ? await rejectFavor(payload) : await acceptFavor(payload);
        if (resp.error) {
          reject(resp);
        } else {
          resolve(resp);
        }
      });
      try {
        await showPromiseToast(promise, {
          pending: new_status.includes('Reject') ? "Rechazando orden..." : 'Aceptando orden...',
          success: new_status.includes('Reject') ? "Orden rechazada con éxito" : 'Orden aceptada con éxito',
          error: "Error al actualizar la orden"
        });
      } catch (e) { } finally {
        if (resp.error) {
          showErrorToast(getErrorMessages(resp.message));
        }else{
          this.close();
          new_status.includes('Accept') ? await setNo_order(this.id_order): null;
          new_status.includes('Accept') ? await Router.push({name: 'order'}) : null;
        }
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
      this.selectedAddress = { lat: address.lat, lng: address.lng, name: address.name } as Delivery;
      this.showMap = true;
    }
  },
});
</script>

<style scoped>
.modal-container{
  padding: 8px;
  position: relative;
  background-color: rgba(245, 245, 245, 0.7);
  backdrop-filter: blur(10px);
}

.loader-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100%;
}

.details-title {
  font-size: 24px;
  font-weight: bold;
  margin-bottom: 16px;
}

.profile-avatar {
  margin-right: 16px;
}

.user-role {
  font-size: 14px;
  color: #666;
}

.info-row {
  display: flex;
  align-items: center;
  margin-top: 8px;
}

.info-icon {
  margin-right: 8px;
}

.direction-buttons {
  display: flex;
  justify-content: space-between;
  align-items: start;
  position: relative;
  margin-top: 1.5rem;
  width: 100%;
}

.line-connector {
  position: absolute;
  top: 25%;
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

.direction-b{
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: start;
  width: 80px;
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

.timer {
  font-size: 32px;
  font-weight: bold;
}

.box-image {
  width: 100px;
  height: auto;
}

.product-section-title {
  font-size: 20px;
  font-weight: bold;
  margin-top: 16px;
  margin-bottom: 8px;
}

.product-list {
  margin-top: 8px;
}

.product-item {
  padding: 8px 0;
}

.product-number {
  font-weight: bold;
}

.product-info-column {
  padding-left: 16px;
}

.product-name {
  font-size: 16px;
  font-weight: bold;
}

.product-description {
  font-size: 14px;
  color: #666;
}

.product-amount {
  font-size: 14px;
  color: #333;
}

.eye-icon-column {
  display: flex;
  justify-content: center;
  align-items: center;
}

.eye-icon {
  font-size: 20px;
  color: #666;
}

.buttons-container {
  display: flex;
  justify-content: center;
  margin-top: 16px;
}

.icon-button:hover {
  transform: scale(1);
  transition: all 0.3s;
}

.icon-button:hover {
  transform: scale(1.1);
  cursor: pointer;
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
</style>