<template>
  <div class="switch-container">
    <div class="toggle">
              <input :disabled="isBusy" type="checkbox" id="btn" v-model="isEnabled" @change="toggleSwitch" />
              <label for="btn">
                <span class="track" :class="{'busy': isBusy}"></span>
                <span class="thumb">
                  <span class="icon_off"><v-icon icon="fa-solid fa-power-off"/> </span>
                </span>
                <span class="label-text" :class="{'on': isEnabled, 'off': !isEnabled}">
                  {{isBusy ? 'Pedido activo' : isEnabled ? 'Activo' : 'Inactivo' }}
                </span>
              </label>
            </div>
  </div>
</template>

<script lang="ts">
import {getErrorMessages, getNo_courierByToken, getNo_order, getStatusCourier, setStatusCourier} from '@/kernel/utils';
import {defineComponent} from 'vue'
import {showErrorToast, showSuccessToast} from "@/kernel/alerts";
import {LocationUpdateEntity} from "@/modules/maps/entity/location.entity";
import {updateLocation} from "@/modules/maps/services/location.service";

export default defineComponent({
  name: "Switch",

  data() {
    return {
      thereOrder: false,
      isEnabled: false,
      locationInterval: null as any,
      thereConnection: true
    }
  },

  mounted() {
    this.toggleCheckedCourier();
  },

  computed: {
    isBusy(): boolean {
      return this.thereOrder && this.isEnabled;
    }
  },

  watch: {
    async isEnabled(val) {
      if (val) {
        this.startTracking();
        this.thereOrder = typeof (await getNo_order()) === 'string';
        this.$emit('onTrue');
      }else {
        this.stopTracking();
        this.$emit('onFalse');
      }
    }
  },

  methods: {
    async toggleCheckedCourier() {
      let status = await getStatusCourier();
      this.isEnabled = (status === 'true');
    },

    toggleSwitch(event: Event) {
      this.isEnabled = (event.target as HTMLInputElement).checked;
      if (this.isEnabled) {
        setStatusCourier(true);
      }else {
        setStatusCourier(false);
      }
    },

    startTracking() {
      if (this.locationInterval) {
        clearInterval(this.locationInterval);
        this.locationInterval = null;
      }
      this.updateLocationService();
      this.locationInterval = setInterval(() => {
        this.updateLocationService();
      }, 10000) as any;
    },

    stopTracking() {
      if (this.locationInterval) {
        clearInterval(this.locationInterval);
        this.locationInterval = null;
      }
    },

    async updateLocationService() {
      if (!navigator.onLine) {
        showErrorToast("No hay conexión a Internet.");
        this.thereConnection = false;
        return;
      }
      if (navigator.onLine && !this.thereConnection) {
        this.thereConnection = true;
        showSuccessToast("Conexión a Internet restablecida.");
      }

      if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(async (position) => {
          const no_courier = await getNo_courierByToken()
          const request = {
            no_courier,
            lat: position.coords.latitude,
            lng: position.coords.longitude
          } as LocationUpdateEntity;
          const res = await updateLocation(request);
          if (res.error){
            showErrorToast(getErrorMessages(res.message));
          }
        }, (error) => {
          console.error("Error obtaining location: ", error);
        });
      } else {
        showErrorToast("La geolocalización no está soportada por este navegador.");
      }
    }
  },

  beforeUnmount() {
    this.stopTracking();
  }

})
</script>



<style scoped>
.switch-container {
  display: flex;
  align-items: center;
}
.toggle {
  position: relative;
  display: inline-block;
  width: 300px;
  height: 40px;
  box-shadow: #666;
}

.toggle input[type="checkbox"] {
  display: none;
}

.toggle label {
  position: relative;
  display: block;
  background-color: #ccc; /* color por defecto (rojo) */
  border-radius: 20px;
  width: 100%;
  height: 100%;
  transition: background-color 0.6s;
  cursor: pointer;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
}

/* La palanca (thumb) del toggle */
.toggle .thumb {
  position: absolute;
  top: -3px;
  left: -10px;
  width: 45px;
  height: 45px;
  background-color: #fff;
  border-radius: 50%;
  transition: left 0.6s;
  z-index: 1;
  border: 2px solid #999; 
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3); 
}

.toggle input:checked + label .thumb {
  left: 260px; 
  background-color: #fff;
}

.toggle .label-text {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 2;
  text-align: center;
  line-height: 40px;
  font-size: 14px;
  font-weight: bold;
  color: #fff;
}

.toggle .label-text.on {
  color: #fff;
}

.toggle .label-text.off {
  color: #fff;
}

.toggle input:checked + label {
  background-color: #89A7B1;
}

.busy {
  background-color: #8a529c !important;
}

.toggle input:checked + label .busy {
  background-color: #8a529c !important;
  box-shadow: 0 4px 8px rgba(0, 128, 0, 0.3);
}

.toggle input:checked + label .track {
  background-color: #89A7B1; 
  box-shadow: 0 4px 8px rgba(0, 128, 0, 0.3); 
}

.toggle input:checked + label .label-text {
  color: #fff;
}

.toggle input:checked + label .thumb {
  background-color: #fff;
}

.toggle input:not(:checked) + label {
  background-color: #e74c3c; /* Rojo cuando está desactivado */
}

.toggle .thumb .icon_off {
  position: absolute;
  top: 49%;
  left: 49%;
  transform: translate(-50%, -50%);
  font-size: 14px;
  color: #666; 
  transition: color 0.6s;
  box-shadow: #666;
}

.toggle input:checked + label .thumb .icon_off {
  color:  #0672ff; 
}

.toggle .track {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: transparent;
  border-radius: 20px;
  z-index: 0;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
}

@media screen and (max-width: 768px) {
  .toggle {
    width: 180px;
  }
  .toggle input:checked + label .thumb {
    left: 150px; 
    background-color: #fff;
  }
  
}

</style>