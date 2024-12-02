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
import { GoogleMap, Marker } from 'vue3-google-map';
import Switch from '@/components/Switch.vue';

export default defineComponent({
  name: "MapView",
  components: { WaveComponent, GoogleMap, Switch },
  data() {
    return {
      center: { lat: 19.42847, lng: -99.12766 }, // Default location
      isChecked: false,
      userIcon: require('@/assets/location/assistant_navigation.svg'),
      API_KEY_MAPS: process.env.VUE_APP_GOOGLE_MAPS_API_KEY,
      locationInterval: null as number | null,
      marker: null as google.maps.Marker | null,
      thereConnection: true, // Flag to manage connectivity
    };
  },
  mounted() {
    this.checkConnection();
    window.addEventListener('online', this.checkConnection);
    window.addEventListener('offline', this.checkConnection);

    // Try to load the last known location if available
    const savedLocation = localStorage.getItem('lastLocation');
    if (savedLocation) {
      this.center = JSON.parse(savedLocation);
    }
  },
  beforeUnmount() {
    this.stopTracking();
    window.removeEventListener('online', this.checkConnection);
    window.removeEventListener('offline', this.checkConnection);
  },
  methods: {
    checkConnection() {
      this.thereConnection = navigator.onLine;
      if (!this.thereConnection) {
        this.showNoConnectionMap();  
      }
    },
    startTracking() {
      if (!this.thereConnection) {
        console.warn('No connection. Tracking will not start.');
        return;
      }
      if (this.locationInterval) {
        clearInterval(this.locationInterval);
        this.locationInterval = null;
      }
      this.updateLocation();
      this.locationInterval = setInterval(() => {
        this.updateLocation();
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
        navigator.geolocation.getCurrentPosition(
          (position) => {
            this.center = {
              lat: position.coords.latitude,
              lng: position.coords.longitude
            };
            this.updateMarker();
            // Save the last known location in localStorage
            localStorage.setItem('lastLocation', JSON.stringify(this.center));
          },
          (error) => {
            console.error("Error obtaining location: ", error);
          }
        );
      } else {
        console.error("Geolocation is not supported by this browser.");
      }
    },
    updateMarker() {
      try {
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
      } catch (error) {
        console.error("Error updating marker: ", error);
      }
    },
    showNoConnectionMap() {
      // Optional: Replace this with a static image or map fallback
      console.log('Showing static map or fallback');
    }
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
