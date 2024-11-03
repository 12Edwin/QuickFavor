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
              <v-icon icon="fa:fas fa-circle-notch fa-spin"></v-icon> ¿Dónde Estoy?
            </h2>
            <div class="switch-container">
              <label class="switch">
                <input type="checkbox" v-model="isChecked" @change="toggleTracking">
                <span class="slider"></span>
              </label>
            </div>
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

export default defineComponent({
  name: "MapView",
  components: { WaveComponent, GoogleMap },
  data() {
    return {
      center: { lat: 19.42847, lng: -99.12766 },
      isChecked: false,
      isTracking: false,
      userIcon: require('@/assets/location/assistant_navigation.svg'),
      API_KEY_MAPS: process.env.VUE_APP_GOOGLE_MAPS_API_KEY,
      locationInterval: null as number | null,
      marker: null as google.maps.Marker | null
    };
  },
  mounted() {
    if (this.isChecked) {
      this.toggleTracking();
    }
  },
  methods: {
    toggleTracking() {
      this.isTracking = this.isChecked;
      if (this.isTracking) {
        this.startTracking();
      } else {
        this.stopTracking();
      }
    },
    startTracking() {
      this.updateLocation(); 
      this.locationInterval = setInterval(() => {
        this.updateLocation(); 
      }, 5000);
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
  justify-content: space-between;
  padding: 0 16px;
  background-color: #566981;
  border-top-left-radius: 16px;
  border-top-right-radius: 16px;
  height: 64px;
}
.header-title {
  color: white;
  font-size: 1.25rem;
}
.switch-container {
  display: flex;
  align-items: center;
}
.switch {
  position: relative;
  display: inline-block;
  width: 48px;
  height: 24px;
}
.switch input {
  opacity: 0;
  width: 0;
  height: 0;
}
.slider {
  position: absolute;
  cursor: pointer;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: #CB5E5E;
  transition: 0.4s;
  border-radius: 24px; 
}
.slider:before {
  position: absolute;
  content: "";
  height: 18px;
  width: 18px;
  left: 4px;
  bottom: 3px;
  background-color: white;
  transition: 0.4s;
  border-radius: 50%;
}
input:checked + .slider {
  background-color: #4caf50;
}
input:checked + .slider:before {
  transform: translateX(24px);
}
.map-container {
  height: calc(100% - 64px); 
  width: 100%;
}
.wave-animation {
  position: absolute;
  top: 50%;
  left: 50%;
  width: 200px; 
  height: 200px; 
  background: rgba(75, 192, 192, 0.5);
  border-radius: 50%;
  animation: wave-animation 3s infinite;
  transform: translate(-50%, -50%);
  z-index: -1; 
}
@keyframes wave-animation {
  0% {
    transform: translate(-50%, -50%) scale(1);
    opacity: 1;
  }
  100% {
    transform: translate(-50%, -50%) scale(5);
    opacity: 0;
  }
}
</style>
