<template>
  <div class="back-container">
    <WaveComponent />
  </div>
  <div class="container" style="max-height: 88vh; overflow-y: auto;">
    <v-card class="bg-lighten-5" style="height: 88vh;">
      <v-card-title
        style="background-color: #566981; display: flex; justify-content: space-between; align-items: center;">
        <div>
          <h1 style="color: white;">Perfil</h1>
        </div>
        <div class="switch-container">
          <label class="switch">
            <input type="checkbox">
            <span class="slider"></span>
          </label>
        </div>
      </v-card-title>
      <v-card-body>
        <v-row justify="center" no-gutters style="margin-top: 100px;">
          <v-col cols="12" md="3" class="text-center">
            <v-avatar
              image="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcThnnN0Nj42DW5N9u177sXStr7NPl1JZSOODQ&s"
              size="200">
            </v-avatar>
            <h3>Juan Rodrigo</h3>
            <div class="d-flex align-center justify-center">
              <v-icon icon="mdi-phone" style="color: black !important"></v-icon>
              <span class="ml-1">777-234-4325</span>
            </div>
          </v-col>

          <v-col cols="12" md="6">
            <v-card class="pa-4 card-custom">
              <v-card-title class="text-h6" align="center">Repartidor</v-card-title>
              <v-card-text>
                <v-row>
                  <v-col align="center" cols="4"><strong>CURP</strong></v-col>
                  <v-col align="center" cols="8">OOAZ900824MTSRLL08</v-col>

                  <v-col align="center" cols="4"><strong>SEXO</strong></v-col>
                  <v-col align="center" cols="8">Masculino</v-col>

                  <v-col align="center" cols="4"><strong>CORREO</strong></v-col>
                  <v-col align="center" cols="8">correo@gmail.com</v-col>
                </v-row>
              </v-card-text>
            </v-card>
          </v-col>
          <v-col cols="12" md="6">
            <div style="padding: 20px;">
              <v-text-field type="input" prepend-icon="mdi-phone" label="Nuevo telefono"></v-text-field>
              <v-text-field type="email" prepend-icon="mdi-email" label="Nuevo correo"></v-text-field>
            </div>
          </v-col>
          <v-col cols="12" md="6" class="d-flex justify-center">
            <v-btn icon>
              <v-icon icon="fa-solid fa-pen" class="icon"></v-icon>
              <i class="fa-solid fa-pen icon"></i>
            </v-btn>
            <v-card class="pa-2 oval-card">
              <v-card-title>
                <v-text class="text-card">Repartidor a moto</v-text>
              </v-card-title>
              <v-card-text>
                <v-icon icon="fa-solid"></v-icon>
                <v-text>Yamaha YBR 125 ZR 2023 Color rojo</v-text>
              </v-card-text>
            </v-card>
          </v-col>
        </v-row>
      </v-card-body>
    </v-card>
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue'
import WaveComponent from "@/components/WaveComponent.vue";

export default defineComponent({
  name: "Profile",
  components: { WaveComponent },
})
</script>

<style scoped>
.card-custom {
  position: relative;
  z-index: 1;
  border-radius: 32px;
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

input:checked+.slider {
  background-color: #4caf50;
}

input:checked+.slider:before {
  transform: translateX(24px);
}

.back-container {
  width: 100%;
  overflow: hidden;
  position: absolute;
  bottom: 0;
  left: 0;
  z-index: -1;
}

.text-card {
  color: white;
  justify-content: center;
  align-items: center;
  display: flex;
}

.icon {
  color: #0000;
}

.oval-card {
  border-radius: 50%;
  width: 300px;
  height: 150px;
  max-width: 400px;
  max-height: 200px;
  background-color: #89A7B1;
}

@media (max-width: 768px) {
  .oval-card {
    width: 70vw;
    height: 25vh;
  }
}

@media (max-width: 480px) {
  .oval-card {
    width: 90vw;
    height: 30vh;
  }
}
</style>