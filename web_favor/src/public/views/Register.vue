<template>
  <v-container fluid class="register-container">
    <v-row class="fill-height" align="center" justify="center">
      <v-col>
        <v-card class="pa-4 card-custom">
          <img src="../../assets/car.png" width="200px" alt="auto" class="car-image">
          <div class="register-form">
            <div class="text-center mb-7">
              <h2>Registro</h2>
            </div>

            <!-- Stepper de Vuetify debajo del formulario -->
            <v-stepper v-model="step" class="custom-stepper" flat>
              <v-stepper-header>
                <template v-for="(item, i) in items" :key="i">
                  <v-stepper-item :value="item.value" class="stepper-item"
                    :class="{ 'stepper-item--active': step === item.value }"></v-stepper-item>
                </template>
              </v-stepper-header>
            </v-stepper>
            <!-- Formulario -->
            <form @submit.prevent="submitForm">
              <!-- Primer Paso: Datos Personales -->
              <div v-if="step === 1">
                <div class="input-container">
                  <v-icon class="fa-solid fa-user icon"></v-icon>
                  <input type="text" v-model="form.nombre" placeholder="Nombre" class="register-input" required>
                </div>
                <div class="input-container">
                  <v-icon class="fa-solid fa-user icon"></v-icon>
                  <input type="text" v-model="form.apellidoPaterno" placeholder="Apellido Paterno"
                    class="register-input" required>
                </div>
                <div class="input-container">
                  <v-icon class="fa-solid fa-user icon"></v-icon>
                  <input type="text" v-model="form.apellidoMaterno" placeholder="Apellido Materno"
                    class="register-input" required>
                </div>
                <div class="input-container">
                  <v-icon class="fa-solid fa-address-card icon"></v-icon>
                  <input type="text" v-model="form.curp" placeholder="CURP" class="register-input" required>
                </div>
                <div class="input-container">
                  <v-icon class="fa-solid fa-person-half-dress icon"></v-icon>
                  <select v-model="form.sexo" class="register-input">
                    <option value="" disabled>Sexo</option>
                    <option value="Masculino">Masculino</option>
                    <option value="Femenino">Femenino</option>
                    <option value="Otro">Otro</option>
                  </select>
                </div>
              </div>

              <!-- Segundo Paso: Matrícula y Modelo o Descripción o Imagen -->
              <div v-if="step === 2">
                <!-- Botones en la parte superior -->
                <div class="icon-button-group">
                  <button class="icon-button-step2" :class="{ 'selected': selectOptionClick === 1 }"
                    @click.prevent="selectOption(1)">
                    <v-icon class="fa-solid fa-car icon-step-2"></v-icon>
                  </button>
                  <button class="icon-button-step2" :class="{ 'selected': selectOptionClick === 2 }"
                    @click.prevent="selectOption(2)">
                    <v-icon class="fa-solid fa-motorcycle icon-step-2"></v-icon>
                  </button>
                  <button class="icon-button-step2" :class="{ 'selected': selectOptionClick === 3 }"
                    @click.prevent="selectOption(3)">
                    <v-icon class="fa-solid fa-bicycle icon-step-2"></v-icon>
                  </button>
                  <button class="icon-button-step2" :class="{ 'selected': selectOptionClick === 4 }"
                    @click.prevent="selectOption(4)">
                    <v-icon class="fa-solid fa-dolly icon-step-2"></v-icon>
                  </button>
                  <button class="icon-button-step2" :class="{ 'selected': selectOptionClick === 5 }"
                    @click.prevent="selectOption(5)">
                    <v-icon class="fa-solid fa-person-walking icon-step-2"></v-icon>
                  </button>
                  <button class="icon-button-step2" :class="{ 'selected': selectOptionClick === 6 }"
                    @click.prevent="selectOption(6)">
                    <v-icon class="fa-solid fa-plus icon-step-2"></v-icon>
                  </button>
                </div>

                <!-- Mostrar solo descripción -->
                <div v-if="showDescriptionOnly">
                  <div class="input-container">
                    <v-icon class="fa-solid fa-file icon"></v-icon>
                    <input type="text" v-model="form.descripcion" placeholder="Descripción" class="register-input"
                      required>
                  </div>
                </div>

                <!-- Mostrar solo imagen -->
                <div v-else-if="showImageOnly" class="walkable-image">
                  <v-row>
                    <img src="../../assets/walk.png" alt="Walking" width="300px">
                  </v-row>
                </div>

                <!-- Mostrar solo el modelo -->
                <div v-else-if="showModelOnly">
                  <div class="input-container">
                    <v-icon class="fa-solid fa-file icon"></v-icon>
                    <input type="text" v-model="form.modelo" placeholder="Modelo" class="register-input" required>
                  </div>
                </div>

                <!-- Mostrar formulario completo de Matrícula y Modelo si no es descripción ni imagen -->
                <div v-else>
                  <div class="input-container">
                    <v-icon class="fa-solid fa-address-card icon"></v-icon>
                    <input type="text" v-model="form.matricula" placeholder="Matrícula" class="register-input" required>
                  </div>
                  <div class="input-container">
                    <v-icon class="fa-solid fa-file icon"></v-icon>
                    <input type="text" v-model="form.modelo" placeholder="Modelo" class="register-input" required>
                  </div>
                  <!-- Selector de Color y Licencia -->
                  <v-row align="start" no-gutters>
                    <v-col cols="6" class="col-item">
                      <div class="color-container">
                        <div class="color-picker">
                          <input type="color" v-model="form.color" class="color-input" />
                          <div class="color-label">Color</div>
                        </div>
                      </div>
                    </v-col>
                    <v-col cols="6" class="col-item">
                      <div class="input-container">
                        <v-icon class="fa-solid fa-upload icon-especial"></v-icon>
                        <div class="custom-file-input-wrapper">
                          <label for="file-upload" class="file-label">
                            <input type="file" id="file-upload" ref="fileInput" @change="handleFileChange"
                              class="custom-file-input" />
                            <span class="file-placeholder">Licencia</span>
                          </label>
                        </div>
                      </div>
                    </v-col>
                  </v-row>
                </div>
              </div>

              <!-- Tercer Paso: Contacto e Identificación -->
              <div v-if="step === 3" class="scrollable-step">
                <!-- Rostro -->
                <v-row align="start" no-gutters style="margin-bottom: 0px !important;">
                  <v-col cols="6" class="col-item">
                    <div class="input-container">
                      <v-icon class="fa-solid fa-upload icon-especial"></v-icon>
                      <div class="custom-file-input-wrapper">
                        <label for="file-upload" class="file-label">
                          <input type="file" id="file-upload" ref="fileInput" @change="handleRostroChange"
                            class="custom-file-input" />
                          <span class="file-placeholder">Rostro</span>
                        </label>
                      </div>
                    </div>
                  </v-col>
                  <v-col cols="6" class="col-item">
                    <div class="input-container">
                      <v-icon class="fa-solid fa-upload icon-especial"></v-icon>
                      <div class="custom-file-input-wrapper">
                        <label for="file-upload" class="file-label">
                          <input type="file" id="file-upload" ref="fileInput" @change="handleIneChange"
                            class="custom-file-input" />
                          <span class="file-placeholder">INE</span>
                        </label>
                      </div>
                    </div>
                  </v-col>
                </v-row>

                <!-- Teléfono -->
                <div class="input-container">
                  <v-icon class="fa-solid fa-phone icon"></v-icon>
                  <input type="tel" v-model="form.telefono" placeholder="Teléfono" class="register-input" required>
                </div>

                <!-- Correo -->
                <div class="input-container">
                  <v-icon class="fa-solid fa-envelope icon"></v-icon>
                  <input type="text" v-model="form.correo" placeholder="Correo electronico" class="register-input"
                    required>
                </div>

                <!-- Contraseña -->
                <div class="input-container">
                  <v-icon class="fa-solid fa-key icon"></v-icon>
                  <input type="password" v-model="form.contrasena" placeholder="Contraseña" class="register-input"
                    required />
                </div>

                <!-- Confirmar Contraseña -->
                <div class="input-container">
                  <v-icon class="fa-solid fa-key icon"></v-icon>
                  <input type="password" v-model="form.confirmarContrasena" placeholder="Repita la contraseña"
                    class="register-input" required />
                </div>
              </div>

              <!-- Botones de navegación -->
              <div class="text-center">
                <v-row>
                  <v-col>
                    <button class="btn-left" v-if="step === 1" @click="goToInicio">LOGIN</button>
                    <button class="btn-left" @click="prevStep" v-if="step > 1">ATRÁS</button>
                  </v-col>
                  <v-col>
                    <button class="btn-rigth" @click="nextStep" v-if="step < 3">SIGUIENTE</button>
                    <button class="btn-rigth" @click="submitForm" v-if="step === 3">REGISTRARSE</button>
                  </v-col>
                </v-row>

              </div>
            </form>

          </div>
        </v-card>
      </v-col>
      <v-col class="logo">
        <v-col cols="12">
          <div class="logo-content">
            <img src="../../assets/logo.png" alt="Logo" class="logo-image" />
            <h2>Quick Favor</h2>
          </div>
        </v-col>
      </v-col>
    </v-row>
  </v-container>
</template>

<script lang="ts">
import router from '@/router';
import { defineComponent, ref } from 'vue';
import { showErrorToast, showSuccessToast } from '@/kernel/alerts';
import { RegisterCourierEntity } from "@/public/entity/auth.entity";
import {register} from "@/public/services/auth";
import {getErrorMessages, setStatusCourier} from "@/kernel/utils";

export default defineComponent({
  name: "Register",
  setup() {
    const step = ref(1);
    const selectOptionClick = ref(1);
    const form = ref({
      nombre: '',
      apellidoPaterno: '',
      apellidoMaterno: '',
      curp: '',
      sexo: '',
      matricula: '',
      modelo: '',
      color: '#0000FF',
      licenciaFile: null as File | null,
      rostroFile:  null as File | null,
      ineFile:  null as File | null,
      descripcion: '',
      telefono: '',
      correo: '',
      contrasena: '',
      confirmarContrasena: ''
    });

    const items = Array.from({ length: 3 }).map((_, i) => ({
      value: i + 1,
    }));

    const showDescriptionOnly = ref(false);
    const showImageOnly = ref(false);
    const showModelOnly = ref(false);

    const nextStep = () => {
      if (step.value < 3) {
        step.value++;
      }
    };

    const prevStep = () => {
      if (step.value > 1) {
        step.value--;
      }
    };

    // Manejo del cambio de archivo
    const handleFileChange = (event: Event) => {
      const target = event.target as HTMLInputElement;
      const file = target?.files ? target.files[0] : null;
      if (file) {
        form.value.licenciaFile = file;
      } else {
        form.value.licenciaFile = null;
      }
    };

    // Manejo del cambio de archivo
    const handleRostroChange = (event: Event) => {
      const target = event.target as HTMLInputElement;
      const file = target?.files ? target.files[0] : null;
      if (file) {
        form.value.rostroFile = file;
      } else {
        form.value.rostroFile = null;
      }
    };

    const handleIneChange = (event: Event) => {
      const target = event.target as HTMLInputElement;
      const files = target?.files ? Array.from(target.files) : [];

      if (files.length > 2) {
        showErrorToast("Solo se permiten 2 archivos maximo .");
        return;
      }

      const validTypes = ["image/jpeg", "image/png", "application/pdf"];
      const invalidFiles = files.filter(file => !validTypes.includes(file.type));

      if (invalidFiles.length > 0) {
        showErrorToast("Solo se permiten archivos de tipo imagen (png, jpeg) o pdf.");
        return;
      }

      form.value.ineFile = files[0];
    };

    const submitForm = async () => {
      const type = selectOptionClick.value;
      let vehiculeType = '';

      switch (type) {
        case 1:
          vehiculeType = 'Carro';
          break;
        case 2:
          vehiculeType = 'Moto';
          break;
        case 3:
          vehiculeType = 'Bicicleta';
          break;
        case 4:
          vehiculeType = 'Scooter';
          break;
        case 5:
          vehiculeType = 'Caminando';
          break;
        case 6:
          vehiculeType = 'Otro';
          break;
      }

      const credentials = {
        name: form.value.nombre,
        surname: form.value.apellidoPaterno,
        lastname: form.value.apellidoMaterno,
        CURP: form.value.curp,
        sex: form.value.sexo,
        phone: form.value.telefono,
        vehicle_type: vehiculeType,
        model: form.value.modelo,
        license_plate: form.value.matricula,
        face_photo: form.value.rostroFile,
        INE: form.value.ineFile,
        email: form.value.correo,
        password: form.value.contrasena,
      } as unknown as RegisterCourierEntity;

      const result = await register(credentials);
      if (result.error) {
        showErrorToast(getErrorMessages(result.message));
      } else {
        await router.push({name: "login"});
      }

      console.log("CREDENCIALES" ,credentials);
      
    };

    const goToInicio = () => {
      router.push({ name: 'login' });
    };

    const selectOption = (index: number) => {
      selectOptionClick.value = index;
      if ([3, 4].includes(index)) {
        showModelOnly.value = true;
        showDescriptionOnly.value = false;
        showImageOnly.value = false;
      } else if (index === 5) {
        showImageOnly.value = true;
        showDescriptionOnly.value = false;
        showModelOnly.value = false;
      } else if (index === 6) {
        showDescriptionOnly.value = true;
        showImageOnly.value = false;
        showModelOnly.value = false;
      } else {
        showDescriptionOnly.value = false;
        showModelOnly.value = false;
        showImageOnly.value = false;
      }
    };

    return {
      step,
      form,
      items,
      showDescriptionOnly,
      showImageOnly,
      showModelOnly,
      nextStep,
      prevStep,
      submitForm,
      goToInicio,
      selectOption,
      selectOptionClick,
      handleFileChange,
      handleRostroChange,
      handleIneChange
    };
  }
});
</script>

<style scoped>
.register-container {
  background: radial-gradient(circle at 100%, #89A7B1, #89A7B1 50%, #CBDAD5 75%, #556666 100%);
  height: 100vh;
}

/* Centrar el formulario en pantallas móviles */

.register-form {
  padding: 24px;
}

.logo {
  width: 160px;
  margin-bottom: 8px;
}

/* Nuevos estilos */
.logo-content {
  text-align: center;
}

.logo-image {
  max-width: 160px;
  margin-bottom: 8px;
}

.card-custom {
  position: relative;
  margin-left: 72px;
  margin-right: 72px;
  border-radius: 16px;
  background-color: rgba(255, 255, 255, 0.8);
  backdrop-filter: blur(10px);
  overflow: visible;
  z-index: 1;
}

.car-image {
  position: absolute;
  top: -128px;
  left: 50%;
  transform: translateX(-50%);
  z-index: 2;
}

.login-form {
  padding: 24px;
}

.input-container {
  position: relative;
  margin-bottom: 16px;
}

.icon {
  position: absolute;
  left: 12px;
  top: 50%;
  width: 8px;
  height: 8px;
  transform: translateY(-50%);
  color: #566981;
}

.register-input {
  width: 100%;
  padding: 12px 12px 12px 40px;
  /* Espacio para el ícono */
  border: 1px solid #ccc;
  border-radius: 32px;
  outline: none;
  transition: border-color 0.3s;
  height: 40px;
}

.register-input:focus {
  border-color: #3A415A;
}

.login-button {
  background-color: #3A415A;
  color: #ffffff;
  border-radius: 32px;
  width: 100%;
  padding: 12px;
  border: none;
  cursor: pointer;
  transition: background-color 0.3s;
}

.register-button:hover {
  background-color: #89A7B1;
}

.forgot-password,
.sign-up {
  background: none;
  border: none;
  color: #3A415A;
  cursor: pointer;
  text-decoration: underline;
}

.error-message {
  color: red;
  text-align: center;
  margin-top: 1px;
}

.validation-message {
  color: red;
  margin-left: 16px;
  text-align: left;
  margin-top: 1px;
}

.register-button:disabled {
  background-color: #b0b0b0;
  cursor: not-allowed;
}

/* Step 2 */
.icon-button-group {
  display: flex;
  justify-content: center;
  gap: 16px;
  /* Espacio entre los botones */
  margin-bottom: 16px;
  flex-wrap: nowrap;
}

.icon-button-step2 {
  background: none;
  cursor: pointer;
  display: flex;
  justify-content: center;
  align-items: center;
  width: 40px;
  height: 40px;
  border: 2px solid transparent;
  border-radius: 8px;
  transition: background-color 0.3s, border-color 0.3s;
}

.icon-step-2 {
  font-size: 20px;
  color: gray;
  background: none;
}

.icon-step-2:hover {
  color: #566981;
}

.icon-button-step2.selected {
  background-color: #3A415A;
  /* Fondo cuando está seleccionado */
  border-radius: 50%;
}

.icon-button-step2.selected .icon-step-2 {
  color: white;
  /* Color del icono cuando está seleccionado */
}

/* Estilo adicional para los elementos de la columna */
.walkable-image {
  display: flex;
  justify-content: center;
  align-items: center;
  margin-bottom: 16px;
}

.icon-especial {
  position: absolute;
  left: 32px;
  top: 50%;
  width: 8px;
  height: 8px;
  transform: translateY(-50%);
  color: white;
}

/* Contenedor principal */
.custom-file-input-wrapper {
  display: flex;
  justify-content: center;
  align-items: center;
  background-color: #34344E;
  /* Fondo similar al color del color-picker */
  padding: 8px;
  border-radius: 32px;
  margin-left: 8px;
  width: 100%;
}

.custom-file-input {
  display: none;
}

.file-label {
  display: flex;
  align-items: center;
  gap: 8px;
  color: white;
  font-size: 14px;
  cursor: pointer;
}

.file-placeholder {
  font-size: 14px;
  color: white;
}

.file-label:hover {
  background-color: #4a4a73;
}


.color-picker {
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: 8px;
}

.color-input {
  border: none;
  background: none;
  width: 24px;
  height: 24px;
  cursor: pointer;
  border-radius: 50%;
}

.color-label {
  font-size: 14px;
  text-align: center;
  color: white;
}

.color-container {
  display: flex;
  justify-content: center;
  align-items: center;
  border-radius: 32px;
  background-color: #34344E;
  padding: 8px;
}


/* Generales */
.custom-stepper {
  margin-top: -42px;
  background: none;
}

/* Estilos para los botones */
.btn-left {
  background-color: #566981;
  color: #fff;
  border-radius: 32px;
  height: 42px;
  width: 100%;
  border: none;
  cursor: pointer;
  transition: background-color 0.3s;
}

.btn-left:hover {
  background-color: #4c5e6b;
}

.btn-rigth {
  background-color: #3a343a;
  color: #fff;
  border-radius: 32px;
  height: 42px;
  width: 100%;
  border: none;
  cursor: pointer;
  transition: background-color 0.3s;
}

.btn-rigth:hover {
  background-color: #2d292d;
}

.col-item {
  margin-bottom: 16px;
  gap: 16px;
}

@media screen and (max-width: 960px) {
  .register-container {
    padding: 24px;
  }

  .card-custom {
    margin-left: 0;
    margin-right: 0;
  }

  .car-image {
    top: -112px;
  }

  .logo {
    display: none;
  }

}
</style>