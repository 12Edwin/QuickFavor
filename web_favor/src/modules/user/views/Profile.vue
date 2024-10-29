<template>
  <div class="back-container">
    <WaveComponent />
  </div>
  <v-responsive class="mx-auto">
    <v-card class="bg-lighten-5" style="height: 88vh;">
      <v-card-title style="background-color: #566981;">
        <h1 style="color: white;">Perfil</h1>
      </v-card-title>
      <v-card-body>
        <v-row align="center" justify="center" style=" margin-top: 20px;">
          <v-col cols="3" class="text-center">
            <v-avatar
              image="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcThnnN0Nj42DW5N9u177sXStr7NPl1JZSOODQ&s"
              size="200"></v-avatar>
            <h3>Juan Rodrigo</h3>
            <div class="d-flex align-center justify-center">
              <v-icon icon="mdi-phone" style="color: black !important"></v-icon>
              <span sclass="ml-1">777-234-4325</span>
            </div>
          </v-col>
          <v-col cols="6">
            <v-card class="pa-4" outlined>
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
          <v-col cols="6">
            <div style="padding: 40px;"> 
              <v-text-field  max-width="500" type="input" prepended-icon="mdi-phone" v-model="model"  label="Nuevo telefono">
              </v-text-field>
              <v-text-field  type="email" max-width="500" prepended-icon="mdi-email" v-model="model"  label="Nuevo correo">
              </v-text-field>
            </div>
          </v-col>
          <v-col cols="6">
            <div style="background-color: #89A7B1; border-radius: 50%; width: 700px; height: 400px; margin: 0 auto;">

              <v-row align="center" justify="center">
                <v-col cols="6">
                  <v-text>
                    <h3>Reparidor a moto</h3>
                  </v-text>
                </v-col>
              </v-row>
            </div>
          </v-col>
        </v-row>
      </v-card-body>
    </v-card>
  </v-responsive>
</template>

<script lang="ts">
import { defineComponent } from 'vue'
import WaveComponent from "@/components/WaveComponent.vue";

export default defineComponent({
  name: "Profile",
  components: { WaveComponent }
})
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
</style>