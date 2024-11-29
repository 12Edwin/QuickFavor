<template>
  <div class="back-container">
    <WaveComponent />
  </div>
  <div class="container">
    <v-row justify="center">
      <v-col class="md-8">
        <v-card class="card-custom">
          <div class="card-header d-flex align-center justify-space-between">
            <h2 class="header-title">
              <v-icon icon="fa-solid fa-location-dot" style="color: white; font-size: 36px;"></v-icon> 
              <span class="ml-4 fas text-white"> D o n d e  -  e s t o y? </span>
            </h2>
            <Switch v-model="isChecked" @onFalse="stopTracking" @onTrue="startTracking"/>
          </div>
          <div class="map-container">
            <GoogleMap
              ref="mapInstance"
              :api-key="API_KEY_MAPS"
              style="width: 100%; height: 100%;"
              :center="center"
              :zoom="15"
            />
          </div>
        </v-card>
      </v-col>
    </v-row>
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';
import WaveComponent from '@/components/WaveComponent.vue';
import { GoogleMap } from 'vue3-google-map';
import Switch from '@/components/Switch.vue';
import {showErrorToast, showSuccessToast} from "@/kernel/alerts";
import {LocationUpdateEntity} from "@/modules/maps/entity/location.entity";
import {getErrorMessages, getNo_courierByToken} from "@/kernel/utils";
import {updateLocation} from "@/modules/maps/services/location.service";

export default defineComponent({
  name: "MapView",
  components: { WaveComponent, GoogleMap, Switch },
  data() {
    return {
      center: { lat: 19.42847, lng: -99.12766 },
      isChecked: false,
      userIcon: require('@/assets/location/assistant_navigation.svg'),
      API_KEY_MAPS: process.env.VUE_APP_GOOGLE_MAPS_API_KEY,
      locationInterval: null as number | null,
      marker: null as google.maps.Marker | null,
      thereConnection: true
    };
  },
  mounted() {
    
  },
  methods: {
    startTracking() {
      this.updateLocation(); 
      this.locationInterval = setInterval(() => {
        this.updateLocation();
        this.updateLocationService();
      }, 5000) as any;
    },
    stopTracking() {
      if (this.locationInterval) {
        clearInterval(this.locationInterval);
        this.locationInterval = null;
      }
      if (this.marker) {
        this.marker.setMap(null);
        this.marker = null;
      }
    },
    updateLocation() {
      if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition((position) => {
          this.center = {
            lat: position.coords.latitude,
            lng: position.coords.longitude
          };
          this.updateMarker();
        }, (error) => {
          console.error("Error obtaining location: ", error);
        });
      } else {
        console.error("Geolocation is not supported by this browser.");
      }
    },
    updateMarker() {
      const mapInstance = this.$refs.mapInstance as any;

      if (!this.marker) {
        this.marker = new google.maps.Marker({
          position: this.center,
          map: mapInstance.map, 
          icon: {
            url: this.userIcon,
            scaledSize: new google.maps.Size(40, 40)
          }
        });
      } else {
        this.marker.setPosition(this.center);
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
.card-custom {
  position: relative; 
  margin-left: 16px;
  margin-right: 16px;
  border-top-left-radius: 16px;
  border-top-right-radius: 16px;
  border-bottom-left-radius: 0;
  border-bottom-right-radius: 0;
  height: 88vh;
  background-color: rgba(255, 255, 255, 0.5); 
  backdrop-filter: blur(10px);
  overflow: hidden; 
  z-index: 1; 
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

/* map estilos */
.map-container {
  height: calc(100% - 64px); 
  width: 100%;
}
</style>
