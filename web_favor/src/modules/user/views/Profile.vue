<template>
  <div class="back-container">
    <WaveComponent />
  </div>
  <div class="container" style="max-height: 88vh; overflow-y: auto;">
    <v-card class="bg-lighten-5 profile-card" style="height: 88vh;">
      <v-card-title class="profile-header"
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
              <v-text-field type="input" prepend-icon="fa-solid fa-phone" label="Nuevo telefono"></v-text-field>
              <v-text-field type="email" prepend-icon="fa-solid fa-envelope" label="Nuevo correo"></v-text-field>
            </div>
          </v-col>
          <v-col cols="12" md="6" class="d-flex justify-center">
            <v-btn @click="openDialog" icon>
              <v-icon icon="fa-solid fa-pen" class="icon"></v-icon>
            </v-btn>
            <v-card class="pa-2 oval-card">
              <v-card-title>
                <v-text class="text-card">Repartidor a moto</v-text>
              </v-card-title>
              <v-card-text style="align-items: center; justify-content: center; display: flex">
                <v-icon icon="fa-solid fa-motorcycle" class="icon-moto"></v-icon>
                <v-text class="moto-brand">Yamaha YBR 125 ZR 2023 Color rojo</v-text>
              </v-card-text>
              <v-card-foot class="card-footer">
                <v-card>
                  <v-card-text>
                    <v-text>123-ABC</v-text>
                  </v-card-text>
                </v-card>
              </v-card-foot>
            </v-card>
          </v-col>
          <v-col cols="12" md="2" class="d-flex justify-center">
            <v-btn class="btn">
              <v-icon class="icon-save" icon="fa-solid fa-save"></v-icon>
              <v-text>Guardar cambios</v-text>
            </v-btn>
          </v-col>
        </v-row>

      </v-card-body>
    </v-card>

    <v-dialog v-model="dialog" max-width="500px">
      <v-card>
        <v-card-title class="headline">Actualizar Información</v-card-title>
        <v-card-text>
          <form>
            <div>
              <!-- Botones en la parte superior -->
              <div class="icon-button-group">
                <button class="icon-button" @click.prevent="selectOption(1)">
                  <img src="https://cdn-icons-png.flaticon.com/128/6591/6591639.png" alt="Carro" />
                </button>
                <button class="icon-button" @click.prevent="selectOption(2)">
                  <img src="https://cdn-icons-png.flaticon.com/128/7695/7695164.png" alt="Moto" />
                </button>
                <button class="icon-button" @click.prevent="selectOption(3)">
                  <img src="https://cdn-icons-png.flaticon.com/128/732/732944.png" alt="Bicicleta" />
                </button>
                <button class="icon-button" @click.prevent="selectOption(4)">
                  <img src="https://cdn-icons-png.flaticon.com/128/10059/10059782.png" alt="Patín" />
                </button>
                <button class="icon-button" @click.prevent="selectOption(5)">
                  <img src="https://cdn-icons-png.flaticon.com/128/7512/7512332.png" alt="Caminante" />
                </button>
                <button class="icon-button" @click.prevent="selectOption(6)">
                  <img src="https://cdn-icons-png.flaticon.com/128/512/512142.png" alt="Más" />
                </button>
              </div>

              <!-- Mostrar solo descripción -->
              <div v-if="showDescriptionOnly">
                <div class="form-group">
                  <input type="text" v-model="form.descripcion" placeholder="Descripción" />
                </div>
              </div>

              <!-- Mostrar solo imagen -->
              <div v-else-if="showImageOnly">
                <div class="form-group">
                  <img src="https://cdn-icons-png.flaticon.com/128/7512/7512332.png" alt="Solo Imagen" />
                </div>
              </div>


              <div v-else>
                <div class="form-group">
                  <div class="input-icon">
                    <img src="https://cdn-icons-png.flaticon.com/128/1743/1743637.png" alt="Matrícula Icono"
                      class="flaticon-icon" />
                  </div>
                  <input type="text" v-model="form.matricula" placeholder="Matrícula" />
                </div>
                <div class="form-group">
                  <div class="input-icon">
                    <img src="https://cdn-icons-png.flaticon.com/128/5812/5812183.png" alt="Modelo Icono"
                      class="flaticon-icon" />
                  </div>
                  <input type="text" v-model="form.modelo" placeholder="Modelo" />
                </div>
                <!-- Selector de Color y Licencia -->
                <div class="form-group-row">
                  <div class="form-group color-picker">
                    <label class="color-sample" :style="{ backgroundColor: form.color }">
                      <input type="color" v-model="form.color" class="color-input" />
                    </label>
                    <div class="color-label">Color</div>
                  </div>
                  <div class="form-group small-file-input">
                    <v-file-input v-model="form.licenciaFile" color="deep-purple-accent-4" label="Licencia"
                      placeholder="Selecciona un archivo" prepend-icon="mdi-paperclip" variant="outlined" counter />
                  </div>
                </div>
              </div>
            </div>
          </form>
        </v-card-text>
        <v-card-actions>
          <v-btn text="Cerrar" @click="dialog = false"></v-btn>
          <v-btn style="background-color: #3A415A;" @click="dialog = false"><v-text
              style="color: #ffff;">Guardar</v-text></v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref } from 'vue'
import WaveComponent from "@/components/WaveComponent.vue";

export default defineComponent({
  name: "Profile",
  components: { WaveComponent },
  setup() {
    const dialog = ref(false);
    const form = ref({
      matricula: '',
      modelo: '',
      color: '',
      licenciaFile: [] as File[],
      rostroFile: [] as File[],
      ineFile: [] as File[],
      descripcion: '',
    });
    const showDescriptionOnly = ref(false);
    const showImageOnly = ref(false);
    const selectOption = (index: number) => {
      if ([3, 4, 6].includes(index)) {
        showDescriptionOnly.value = true;
        showImageOnly.value = false;
      } else if (index === 5) {
        showImageOnly.value = true;
        showDescriptionOnly.value = false;
      } else {
        showDescriptionOnly.value = false;
        showImageOnly.value = false;
      }
    };
    return {
      dialog,
      form,
      showDescriptionOnly,
      showImageOnly,
      selectOption
    };
  },
  methods: {
    openDialog() {
      this.dialog = true;
      console.log("Dialog opened");

    },
  },

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

.card-footer {
  display: flex;
  justify-content: center;
}

.profile-card {
  max-height: 80vh;
  background-color: rgba(255, 255, 255, 0.5);
  overflow-y: auto;
}

.profile-header {
  position: sticky;
  top: 0;
  z-index: 10;
}

.btn {
  background-color: #566981;
  color: white;
}

.btn v-icon {
  color: white !important;
}

.btn v-text {
  color: white;
}

@media (max-width: 768px) {
  .profile-card {
    max-height: 60vh;
    /* Ajusta la altura máxima para pantallas pequeñas */
  }

  .btn-save {
    display: flex;
    justify-content: center;
    width: 100%;
    /* Asegúrate de que el botón ocupe todo el ancho del contenedor */
  }
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

.card-footer {
  display: flex;
  justify-content: center;
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
  color: #000000;
}

.icon-save {
  color: white;
}

.icon-moto {
  font-size: 70px;
  margin-right: 20px;
  color: #ffffff;
}

.oval-card {
  border-radius: 50%;
  width: 500px;
  height: 250px;
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

.register-container {
  display: flex;
  align-items: center;
  justify-content: flex-start;
  /* Alinea a la izquierda dentro del círculo */
  height: 100vh;
  background-color: #d0dadb;
  padding: 20px;
  position: relative;
}

/* Centrar el formulario en pantallas móviles */
.register-container {
  justify-content: center;
}

.half-circle-background {
  position: absolute;
  width: 80%;
  height: 150%;
  border-radius: 60%;
  background-color: #95abb3;
  left: -30%;
  top: -20%;
  z-index: 0;
}

.register-form {
  background-color: #ffffff;
  padding: 2rem;
  border-radius: 10px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
  width: 100%;
  max-width: 400px;
  text-align: center;
  z-index: 1;
  margin-left: -50vw;
  /* Usar unidades relativas para ajustar el margen */
  position: relative;
}

.logo {
  width: 80px;
  margin-bottom: 1rem;
}

.form-group {
  display: flex;
  align-items: center;
  border: 1px solid #89A7B1;
  border-radius: 25px;
  margin-bottom: 1rem;
  padding: 0.5rem;
  background-color: #f0f5f8;
}

.form-group-row {
  display: flex;
  justify-content: space-between;
  gap: 10px;
}

.small-file-input .v-input__control {
  height: 30px;
  padding: 0 8px;
}

.small-file-input .v-file-input .v-label {
  font-size: 0.8rem;
}

.input-icon {
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #ffffff;
  border-radius: 50%;
  color: #fff;
  margin-right: 8px;
}

.flaticon-icon {
  width: 24px;
  height: 24px;
  filter: invert(54%) sepia(35%) saturate(2120%) hue-rotate(195deg) brightness(95%) contrast(90%);
}

.scrollable-step {
  max-height: 300px;
  overflow-y: auto;
}

.button-group {
  display: flex;
  justify-content: center;
  gap: 10px;
  margin-top: 1rem;
}

.next-button {
  background-color: #505c86;
  color: #ffffff !important;
  font-weight: bold;
  font-size: 1.1rem;
  letter-spacing: 0.5px;
}

.back-link {
  text-align: center;
  margin-top: 10px;
  font-size: 0.9rem;
  color: #A0A0A0;
}

.back-link a {
  color: #A0A0A0;
  cursor: pointer;
  text-decoration: none;
}

/* Ocultar el contenedor del logo y el texto */
.right-logo-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  text-align: center;
  position: absolute;
  right: 10%;
  top: 50%;
  transform: translateY(-50%);
}

/* Estilos del logo en el lado derecho */
.right-logo-container img {
  width: 300px;
  /* Incrementa este valor para hacer el logo más grande */
  height: auto;
  /* Mantiene la proporción */
  margin-bottom: 0.5rem;
}

.right-logo-container p {
  font-size: 2.0rem;
  color: #505c86;
  font-weight: bold;
}

.right-logo {
  width: 100px;
  /* Ajusta el tamaño si es necesario */
}

.right-logo-text {
  font-size: 1.5rem;
  color: #505c86;
  /* Color del texto */
}

/* Media query para ocultar el contenedor en pantallas pequeñas */
@media (max-width: 768px) {
  .right-logo-container {
    display: none;
  }
}

.icon-button-group {
  display: flex;
  justify-content: space-around;
  margin-bottom: 1rem;
}

.icon-button {
  background-color: #d0dadb !important;
  border: none;
  padding: 6px !important;
  border-radius: 6px !important;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: background-color 0.3s;
}

.icon-button img {
  width: 18px !important;
  height: 18px !important;
}

.icon-button:hover {
  transform: scale(1.1);
}

/* Estilos para el selector de color */
.color-picker {
  display: flex;
  align-items: center;
  background-color: #f0f5f8;
  border: 1px solid #89A7B1;
  border-radius: 25px;
  padding: 0.5rem;
  gap: 10px;
}

.color-input-wrapper {
  display: flex;
  align-items: center;
}

.color-sample {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
  cursor: pointer;
  position: relative;
  overflow: hidden;
}

.color-input {
  opacity: 0;
  width: 100%;
  height: 100%;
  position: absolute;
  top: 0;
  left: 0;
  cursor: pointer;
}

.color-label {
  width: 60px;
  height: 32px;
  background-color: #f0f5f8;
  border: 1px solid #89A7B1;
  border-radius: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1rem;
  color: #333;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
}

/* Media query para dispositivos móviles */
@media (max-width: 768px) {
  .register-container {
    padding: 0;
    align-items: center;
    justify-content: center;
  }

  /* Centrar el formulario en dispositivos móviles */
  .register-form {
    margin: 0 auto;
  }

  .logo {
    width: 60px;
  }

  .half-circle-background {
    display: none;
  }
}

@media (max-width: 768px) {
  .register-form {
    margin-left: 0;
    /* Centrar en pantallas pequeñas */
  }

  .form-group {
    display: flex;
    align-items: center;
    border: 1px solid #89A7B1;
    border-radius: 25px;
    margin-bottom: 1rem;
    padding: 0.5rem;
    background-color: #f0f5f8;
  }

  .input-icon {
    width: 32px;
    height: 32px;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-right: 8px;
    background-color: #ffffff;
    border-radius: 50%;
  }

  .button-group {
    flex-direction: column;
  }
}
</style>