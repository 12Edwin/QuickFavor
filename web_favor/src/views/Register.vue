<template>
  <div class="register-container">
    <!-- Fondo Circular -->
    <div class="half-circle-background"></div>

    <!-- Contenedor de Registro -->
    <div class="register-form">
      <img src="@/assets/logo.png" alt="Quick Favor Logo" class="logo" />
      <h1>Registro</h1>

      <!-- Formulario -->
      <form>
        <!-- Primer Paso: Datos Personales -->
        <div v-if="step === 1">
          <div class="form-group">
            <div class="input-icon">
              <img src="https://cdn-icons-png.flaticon.com/128/709/709699.png" alt="User Icon" class="flaticon-icon" />
            </div>
            <input type="text" v-model="form.nombre" placeholder="Nombre" />
          </div>
          <div class="form-group">
            <div class="input-icon">
              <img src="https://cdn-icons-png.flaticon.com/128/709/709699.png" alt="User Icon" class="flaticon-icon" />
            </div>
            <input type="text" v-model="form.apellidoPaterno" placeholder="Apellido paterno" />
          </div>
          <div class="form-group">
            <div class="input-icon">
              <img src="https://cdn-icons-png.flaticon.com/128/709/709699.png" alt="User Icon" class="flaticon-icon" />
            </div>
            <input type="text" v-model="form.apellidoMaterno" placeholder="Apellido materno" />
          </div>
          <div class="form-group">
            <div class="input-icon">
              <img src="https://cdn-icons-png.flaticon.com/128/709/709699.png" alt="User Icon" class="flaticon-icon" />
            </div>
            <input type="text" v-model="form.curp" placeholder="CURP" />
          </div>
          <div class="form-group">
            <div class="input-icon">
              <img src="https://cdn-icons-png.flaticon.com/128/2017/2017653.png" alt="Gender Icon" class="flaticon-icon" />
            </div>
            <select v-model="form.sexo">
              <option value="" disabled>Sexo</option>
              <option value="M">Masculino</option>
              <option value="F">Femenino</option>
              <option value="O">Otro</option>
            </select>
          </div>
        </div>

        <!-- Segundo Paso: Matrícula y Modelo o Descripción o Imagen -->
<div v-if="step === 2">
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

  <!-- Mostrar formulario completo de Matrícula y Modelo si no es descripción ni imagen -->
  <div v-else>
    <div class="form-group">
      <div class="input-icon">
        <img src="https://cdn-icons-png.flaticon.com/128/1743/1743637.png" alt="Matrícula Icono" class="flaticon-icon" />
      </div>
      <input type="text" v-model="form.matricula" placeholder="Matrícula" />
    </div>
    <div class="form-group">
      <div class="input-icon">
        <img src="https://cdn-icons-png.flaticon.com/128/5812/5812183.png" alt="Modelo Icono" class="flaticon-icon" />
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
        <v-file-input v-model="form.licenciaFile" color="deep-purple-accent-4" label="Licencia" placeholder="Selecciona un archivo" prepend-icon="mdi-paperclip" variant="outlined" counter />
      </div>
    </div>
  </div>
</div>

        <!-- Tercer Paso: Contacto e Identificación -->
        <div v-if="step === 3" class="scrollable-step">
          <div class="form-group-row">
            <!-- Rostro -->
            <div class="form-group small-file-input">
              <div class="input-icon">
                <img src="https://cdn-icons-png.flaticon.com/128/154/154368.png" alt="Face Icon" class="flaticon-icon" />
              </div>
              <v-file-input
                v-model="form.rostroFile"
                :show-size="1000"
                color="deep-purple-accent-4"
                label="Rostro"
                placeholder="Selecciona un archivo"
                prepend-icon="mdi-paperclip"
                variant="outlined"
                counter
                class="small-input"
              >
                <template v-slot:selection="{ fileNames }">
                  <template v-for="(fileName, index) in fileNames" :key="fileName">
                    <v-chip v-if="index < 2" class="me-2" color="deep-purple-accent-4" size="small" label>
                      {{ fileName }}
                    </v-chip>
                    <span v-else-if="index === 2" class="text-overline text-grey-darken-3 mx-2">
                      +{{ form.rostroFile?.length - 2 }} Archivo(s)
                    </span>
                  </template>
                </template>
              </v-file-input>
            </div>

            <!-- INE -->
            <div class="form-group small-file-input">
              <div class="input-icon">
                <img src="https://cdn-icons-png.flaticon.com/128/154/154368.png" alt="INE Icon" class="flaticon-icon" />
              </div>
              <v-file-input
                v-model="form.ineFile"
                :show-size="1000"
                color="deep-purple-accent-4"
                label="INE"
                placeholder="Selecciona un archivo"
                prepend-icon="mdi-paperclip"
                variant="outlined"
                counter
                class="small-input"
              >
                <template v-slot:selection="{ fileNames }">
                  <template v-for="(fileName, index) in fileNames" :key="fileName">
                    <v-chip v-if="index < 2" class="me-2" color="deep-purple-accent-4" size="small" label>
                      {{ fileName }}
                    </v-chip>
                    <span v-else-if="index === 2" class="text-overline text-grey-darken-3 mx-2">
                      +{{ form.ineFile?.length - 2 }} Archivo(s)
                    </span>
                  </template>
                </template>
              </v-file-input>
            </div>
          </div>

          <!-- Teléfono -->
          <div class="form-group">
            <div class="input-icon">
              <img src="https://cdn-icons-png.flaticon.com/128/8050/8050833.png" alt="Phone Icon" class="flaticon-icon" />
            </div>
            <input type="tel" v-model="form.telefono" placeholder="Teléfono" />
          </div>

          <!-- Correo -->
          <div class="form-group">
            <div class="input-icon">
              <img src="https://cdn-icons-png.flaticon.com/128/3494/3494693.png" alt="Email Icon" class="flaticon-icon" />
            </div>
            <input type="email" v-model="form.correo" placeholder="Correo" />
          </div>

          <!-- Contraseña -->
          <div class="form-group">
            <div class="input-icon">
              <img src="https://cdn-icons-png.flaticon.com/128/8660/8660343.png" alt="Password Icon" class="flaticon-icon" />
            </div>
            <input type="password" v-model="form.contrasena" placeholder="Contraseña" />
            <img src="https://cdn-icons-png.flaticon.com/128/159/159604.png" alt="Show Password Icon" class="show-password flaticon-icon" />
          </div>

          <!-- Confirmar Contraseña -->
          <div class="form-group">
            <div class="input-icon">
              <img src="https://cdn-icons-png.flaticon.com/128/8660/8660343.png" alt="Password Icon" class="flaticon-icon" />
            </div>
            <input type="password" v-model="form.confirmarContrasena" placeholder="Repita la contraseña" />
            <img src="https://cdn-icons-png.flaticon.com/128/159/159604.png" alt="Show Password Icon" class="show-password flaticon-icon" />
          </div>
        </div>

        <!-- Stepper de Vuetify debajo del formulario -->
        <v-stepper v-model="step" class="custom-stepper" flat>
          <v-stepper-header>
            <template v-for="(item, i) in items" :key="i">
              <v-stepper-item
                :value="item.value"
                class="stepper-item"
                :class="{'stepper-item--active': step === item.value}"
              ></v-stepper-item>
            </template>
          </v-stepper-header>
        </v-stepper>

        <!-- Botones de navegación -->
        <div class="button-group">
          <v-btn @click="nextStep" class="next-button" v-if="step < 3">Siguiente</v-btn>
          <v-btn @click="submitForm" class="next-button" v-if="step === 3">Siguiente</v-btn>
        </div>

        <!-- Texto de inicio en el primer paso y de atrás en el segundo y tercer paso -->
        <div class="back-link">
          <a v-if="step === 1" @click="goToInicio">Inicio</a>
          <a v-if="step > 1" @click="prevStep">Atrás</a>
        </div>
      </form>
    </div>

    <!-- Contenedor del Logo en el Lado Derecho -->
    <div class="right-logo-container">
      <img src="@/assets/logo.png" alt="Quick Favor Logo" class="right-logo" />
      <p class="right-logo-text">Quick Favor</p>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref } from 'vue';

export default defineComponent({
  name: "Register",
  setup() {
    const step = ref(1);

    const form = ref({
      nombre: '',
      apellidoPaterno: '',
      apellidoMaterno: '',
      curp: '',
      sexo: '',
      matricula: '',
      modelo: '',
      color: '',
      licenciaFile: [] as File[],
      rostroFile: [] as File[],
      ineFile: [] as File[],
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

    const submitForm = () => {
      console.log("Formulario enviado", form.value);
    };

    const goToInicio = () => {
      console.log("Redirigiendo a la pantalla de inicio...");
    };

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

    return { step, form, items, showDescriptionOnly, showImageOnly, nextStep, prevStep, submitForm, goToInicio, selectOption };
  }
});
</script>

<style scoped>
.register-container {
  display: flex;
  align-items: center;
  justify-content: flex-start; /* Alinea a la izquierda dentro del círculo */
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
  margin-left: -50vw; /* Usar unidades relativas para ajustar el margen */
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
  width: 300px; /* Incrementa este valor para hacer el logo más grande */
  height: auto; /* Mantiene la proporción */
  margin-bottom: 0.5rem;
}

.right-logo-container p {
  font-size: 2.0rem;
  color: #505c86;
  font-weight: bold;
}

.right-logo {
  width: 100px; /* Ajusta el tamaño si es necesario */
}

.right-logo-text {
  font-size: 1.5rem;
  color: #505c86; /* Color del texto */
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
    margin-left: 0; /* Centrar en pantallas pequeñas */
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

.additional-options-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 1rem;
}
</style>
