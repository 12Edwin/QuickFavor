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
              <v-icon icon="fa-solid fa-location-dot" style="color: white;"></v-icon> 
              <span class="ml-4 bell-icon fas text-white"> D o n d e   e s t o y? </span>
            </h2>
            <div class="toggle">
              <input type="checkbox" id="btn" v-model="isChecked" @change="toggleTracking" />
              <label for="btn">
                <span class="track"></span>
                <span class="thumb">
                  <span class="icon_off"><v-icon icon="fa-solid fa-power-off"/> </span>
                </span>
                <span class="label-text" :class="{'on': isChecked, 'off': !isChecked}">
                  {{ isChecked ? 'Activo' : 'Inactivo' }}
                </span>
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

/* map estilos */
.map-container {
  height: calc(100% - 64px); 
  width: 100%;
}
</style>
