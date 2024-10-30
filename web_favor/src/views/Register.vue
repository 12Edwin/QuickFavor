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
              <v-icon color="primary">mdi-account</v-icon>
            </div>
            <input type="text" v-model="form.nombre" placeholder="Nombre" />
          </div>
          <div class="form-group">
            <div class="input-icon">
              <v-icon color="primary">mdi-account</v-icon>
            </div>
            <input type="text" v-model="form.apellidoPaterno" placeholder="Apellido paterno" />
          </div>
          <div class="form-group">
            <div class="input-icon">
              <v-icon color="primary">mdi-account</v-icon>
            </div>
            <input type="text" v-model="form.apellidoMaterno" placeholder="Apellido materno" />
          </div>
          <div class="form-group">
            <div class="input-icon">
              <v-icon color="primary">mdi-card-account-details</v-icon>
            </div>
            <input type="text" v-model="form.curp" placeholder="CURP" />
          </div>
          <div class="form-group">
            <div class="input-icon">
              <v-icon color="primary">mdi-gender-male-female</v-icon>
            </div>
            <select v-model="form.sexo">
              <option value="" disabled>Sexo</option>
              <option value="M">Masculino</option>
              <option value="F">Femenino</option>
              <option value="O">Otro</option>
            </select>
          </div>
        </div>

        <!-- Segundo Paso: Matrícula y Modelo -->
        <div v-if="step === 2">
          <div class="form-group">
            <div class="input-icon">
              <v-icon color="primary">mdi-car</v-icon>
            </div>
            <input type="text" v-model="form.matricula" placeholder="Matrícula" />
          </div>
          <div class="form-group">
            <div class="input-icon">
              <v-icon color="primary">mdi-format-list-bulleted-type</v-icon>
            </div>
            <input type="text" v-model="form.modelo" placeholder="Modelo" />
          </div>
        </div>

        <!-- Tercer Paso: Contacto e Identificación -->
        <div v-if="step === 3">
          <div class="form-group">
            <div class="input-icon">
              <v-icon color="primary">mdi-face-recognition</v-icon>
            </div>
            <input type="text" v-model="form.rostro" placeholder="Rostro" />
          </div>
          <div class="form-group">
            <div class="input-icon">
              <v-icon color="primary">mdi-card-account-details</v-icon>
            </div>
            <input type="text" v-model="form.ine" placeholder="INE" />
          </div>
          <div class="form-group">
            <div class="input-icon">
              <v-icon color="primary">mdi-phone</v-icon>
            </div>
            <input type="tel" v-model="form.telefono" placeholder="Teléfono" />
          </div>
          <div class="form-group">
            <div class="input-icon">
              <v-icon color="primary">mdi-email</v-icon>
            </div>
            <input type="email" v-model="form.correo" placeholder="Correo" />
          </div>
          <div class="form-group">
            <div class="input-icon">
              <v-icon color="primary">mdi-lock"></v-icon>
            </div>
            <input type="password" v-model="form.contrasena" placeholder="Contraseña" />
            <v-icon color="primary" class="show-password">mdi-eye</v-icon>
          </div>
          <div class="form-group">
            <div class="input-icon">
              <v-icon color="primary">mdi-lock"></v-icon>
            </div>
            <input type="password" v-model="form.confirmarContrasena" placeholder="Repita la contraseña" />
            <v-icon color="primary" class="show-password">mdi-eye</v-icon>
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
          <v-btn @click="prevStep" color="secondary" v-if="step > 1">Atrás</v-btn>
          <v-btn @click="nextStep" color="primary" v-if="step < 3">Siguiente</v-btn>
          <v-btn @click="submitForm" color="success" v-if="step === 3">Enviar</v-btn>
        </div>
      </form>
    </div>

    <!-- Logo grande en el lado derecho -->
    <div class="right-logo">
      <img src="@/assets/logo.png" alt="Quick Favor Logo Grande" />
      <p>Quick Favor</p>
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
      rostro: '',
      ine: '',
      telefono: '',
      correo: '',
      contrasena: '',
      confirmarContrasena: ''
    });

    const items = Array.from({ length: 3 }).map((_, i) => ({
      value: i + 1,
    }));

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

    return { step, form, items, nextStep, prevStep, submitForm };
  }
});
</script>

<style scoped>
.register-container {
  position: relative;
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 100vh;
  background-color: #d0dadb;
  overflow: hidden;
  padding: 0 5%;
}

@media (max-width: 768px) {
  .register-container {
    flex-direction: column;
    justify-content: center;
    padding: 20px;
  }
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

@media (max-width: 768px) {
  .half-circle-background {
    display: none;
  }
}

.register-form {
  position: relative;
  background-color: #ffffff;
  padding: 2rem;
  border-radius: 10px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
  width: 100%;
  max-width: 400px;
  text-align: center;
  z-index: 1;
  margin-left: 10%;
}

@media (max-width: 768px) {
  .register-form {
    margin: 0;
  }
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

.input-icon {
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #89A7B1;
  border-radius: 50%;
  color: #fff;
  margin-right: 8px;
}

.form-group input,
.form-group select {
  flex: 1;
  border: none;
  outline: none;
  font-size: 1rem;
  padding: 0.5rem;
  background: transparent;
}

.button-group {
  display: flex;
  justify-content: center;
  gap: 10px;
  margin-top: 1rem;
}

.custom-stepper .v-stepper-header {
  border: none;
  justify-content: center;
  margin-top: 1rem;
  background: none;
  box-shadow: none;
  padding: 0;
}

.custom-stepper .stepper-item {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  margin: 0 5px;
}
</style>
