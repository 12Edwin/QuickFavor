<template>
  <div>
    <div v-if="showPopup" class="popup-overlay">
      <div class="popup-content">
        <button @click="closePopup" class="close-btn">×</button>
        <GoogleMap
            :api-key="apiKey"
            :center="mapCenter"
            :zoom="15"
            style="width: 100%; height: 70vh; backdrop-filter: blur(10px); opacity: 0.7;"
        >
          <Marker
              v-if="providedLocation"
              :options="{
              position: providedLocation,
              title: 'Ubicación Proporcionada'
            }"
          />
          <Marker
              v-if="currentLocation"
              :options="{
              position: currentLocation,
              title: 'Tu Ubicación Actual',
              icon: 'http://maps.google.com/mapfiles/ms/icons/blue-dot.png'
            }"
          />
        </GoogleMap>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue'
import { GoogleMap, Marker } from 'vue3-google-map'

export default defineComponent({
  name: 'MapModal',
  components: {
    GoogleMap,
    Marker
  },
  props: {
    lat: {
      type: Number,
      required: true
    },
    lng: {
      type: Number,
      required: true
    }
  },
  data() {
    return {
      apiKey: process.env.VUE_APP_GOOGLE_MAPS_API_KEY || '', // Reemplaza con tu API key real
      showPopup: true,
      currentLocation: null as { lat: number, lng: number } | null,
      mapCenter: null as { lat: number, lng: number } | null
    }
  },
  computed: {
    providedLocation(): { lat: number, lng: number } {
      return {
        lat: this.lat,
        lng: this.lng
      } as {lat: number, lng: number}
    }
  },
  methods: {
    closePopup() {
      this.showPopup = false
      this.$emit('close')
    },
    getCurrentLocation() {
      if ('geolocation' in navigator) {
        navigator.geolocation.getCurrentPosition(
            (position) => {
              this.currentLocation = {
                lat: position.coords.latitude,
                lng: position.coords.longitude
              }
              // Centrar el mapa entre la ubicación proporcionada y la actual
              if (this.providedLocation) {
                this.mapCenter = {
                  lat: (this.providedLocation.lat + this.currentLocation.lat) / 2,
                  lng: (this.providedLocation.lng + this.currentLocation.lng) / 2
                }
              } else {
                this.mapCenter = this.currentLocation
              }
            },
            (error) => {
              console.error('Error obteniendo la ubicación:', error)
              // Si falla la geolocalización, centrar en la ubicación proporcionada
              this.mapCenter = this.providedLocation
            }
        )
      } else {
        console.error('Geolocalización no soportada')
        this.mapCenter = this.providedLocation
      }
    }
  },
  mounted() {
    // Establecer la ubicación proporcionada como centro inicial
    this.mapCenter = this.providedLocation

    // Obtener la ubicación actual
    this.getCurrentLocation()
  }
})
</script>

<style scoped>
.popup-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 9999;
}

.popup-content {
  background: white;
  padding: 20px;
  border-radius: 8px;
  position: relative;
  width: 90%;
  max-width: 90vw;
  max-height: 80%;
  overflow: auto;
}

.close-btn {
  position: absolute;
  top: 10px;
  right: 10px;
  background: none;
  border: none;
  font-size: 24px;
  cursor: pointer;
}
</style>