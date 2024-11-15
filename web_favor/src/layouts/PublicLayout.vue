<template>
  <div class="public-layout">
    <router-view />
    <button class="my-button" @click="startLocationStream">Iniciar</button>
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';
import {SearchDriversRequest} from "@/config/proto/delivery";
import {deliveryService} from "@/config/protoLoader";

export default defineComponent({
  name: "PublicLayout",

  methods: {
    async startLocationStream() {
      console.log('Iniciando stream de ubicaciones');
      try {
        const searchRequest = SearchDriversRequest.create({
          noOrder: '123',
          deliveryPoint: {
            address: '123 Main St',
            lat: 37.7749,
            lng: -122.4194,
          },
          searchRadiusKm: 5,
        });

        const call = deliveryService.searchDrivers(searchRequest);

        // Suscribirse al stream

          call.responses.onNext ((response: any) => {
            console.log('Drivers:', response);
          })
          call.responses.onError ((error: any) => {
            console.error('Error en el stream:', error);
          })
          call.responses.onComplete (() => {
            console.log('Stream completado');
          })


        // Opcional: Guardar la suscripción para limpiarla después
        // this.streamSubscription = subscription;

      } catch (err: any) {
        console.error('Error al iniciar el stream:', err);
      }
    }
  },
});
</script>

<style scoped>
.public-layout {
  width: 100%;
  height: 100%;
  margin: 0;
  padding: 0;
}

.my-button {
  position: fixed;
  bottom: 20px;
  right: 20px;
  background-color: #4CAF50;
  border-radius: 20px;
  color: white;
  padding: 10px 24px;
  text-align: center;
  text-decoration: none;
}
</style>