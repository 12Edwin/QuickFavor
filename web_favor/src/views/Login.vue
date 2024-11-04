<template>
  <v-container fluid class="login-container">
    <v-row class="fill-height" align="center" justify="center">
      <v-col cols="12" md="6">
        <div class="logo-content">
          <img src="../assets/logo.png" alt="Logo" class="logo-image" />
          <h2>Quick Favor</h2>
        </div>
      </v-col>
      <v-col cols="12 pa-8" md="6">
        <v-card class="pa-4 card-custom">
          <img src="../assets/car.png" width="200px" alt="auto" class="car-image" />
          <div class="login-form">
            <div class="text-center mb-7">
              <h2>Login</h2>
            </div>
            <form @submit.prevent="handleLogin">
              <div class="input-container">
                <i class="mdi mdi-email icon"></i>
                <input
                  type="email"
                  v-model="email"
                  @input="validateEmail"
                  placeholder="Email"
                  class="login-input"
                  required
                />
              </div>
              <div v-if="emailValidationMessage" class="validation-message">{{ emailValidationMessage }}</div>
              
              <div class="input-container">
                <i class="mdi mdi-lock icon"></i>
                <input
                  type="password"
                  v-model="password"
                  @input="validatePassword"
                  placeholder="Password"
                  class="login-input"
                  required
                />
              </div>
              <div v-if="passwordValidationMessage" class="validation-message">{{ passwordValidationMessage }}</div>
              
              <div v-if="errorMessage" class="error-message">{{ errorMessage }}</div>
              <button type="submit" class="login-button" :disabled="activeBtnLogin()">Login</button>
              <v-row class="mt-2">
                <v-col cols="12" class="text-center">
                  <button type="button" class="forgot-password">Recuperar contraseña</button>
                </v-col>
                <v-col cols="12" class="text-center">
                  <button type="button" class="sign-up">Registrate</button>
                </v-col>
              </v-row>
            </form>
          </div>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script lang="ts">
import router from '@/router';
import { defineComponent, ref } from 'vue';

export default defineComponent({
  name: "Login",
  setup() {
    const email = ref('');
    const password = ref('');
    const errorMessage = ref('');
    const emailValidationMessage = ref('');
    const passwordValidationMessage = ref('');

    const validateEmail = () => {
      const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/; // Regex para validar email
      emailValidationMessage.value = regex.test(email.value) ? '' : 'Email no válido';
    };

    const validatePassword = () => {
      const regex = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/; // Mínimo 8 caracteres, al menos una letra y un número
      passwordValidationMessage.value = regex.test(password.value) ? '' : 'La contraseña debe tener al menos 8 caracteres, incluyendo una letra y un número';
    };

    const handleLogin = async () => {
      if (!email.value || !password.value) {
        errorMessage.value = 'Por favor, complete todos los campos.';
        return;
      }

      router.push('/map');
      // Para quien le toque, aquí, deberá implementar la lógica de login y eliminar el router push

    };

  const activeBtnLogin = () => {
    return (
    !email.value || 
    !password.value || 
    !(emailValidationMessage.value == "") || 
    !(passwordValidationMessage.value == "")
  ); 
  }

    return {
      email,
      password,
      errorMessage,
      emailValidationMessage,
      passwordValidationMessage,
      validateEmail,
      validatePassword,
      handleLogin,
      activeBtnLogin,
    };
  },
});
</script>

<style scoped>
.login-container {
  background: radial-gradient(circle at 100%, #89A7B1, #89A7B1 50%, #CBDAD5 75%, #556666 100%);
  height: 100vh;
}

.logo-content {
  text-align: center;
}

.logo-image {
  max-width: 160px;
  margin-bottom: 8px;
}

.card-custom {
  position: relative; 
  margin-left: 128px;
  margin-right: 128px;
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
  transform: translateY(-50%);
  color: #3A415A;
}

.login-input {
  width: 100%;
  padding: 12px 12px 12px 40px; /* Espacio para el ícono */
  border: 1px solid #ccc;
  border-radius: 32px;
  outline: none;
  transition: border-color 0.3s;
}

.login-input:focus {
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

.login-button:hover {
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

.login-button:disabled {
  background-color: #b0b0b0; 
  cursor: not-allowed; 
}


@media screen and (max-width: 960px) {
  .car-image {
    top: -80px;
    width: 150px;
  }
  .logo-image {
    width: 100px;
  }
  .card-custom {
    margin-left: 0px;
    margin-right: 0px;
  }
}
@media screen and (min-width: 961px) and (max-width: 1280px) {
  .card-custom {
    margin-left: 72px;
    margin-right: 72px;
  }
}

</style>
