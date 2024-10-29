<template>
  <div class="register-container">
    <!-- Fondo Circular -->
    <div class="circular-background"></div>

    <!-- Contenedor de Registro -->
    <div class="register-form">
      <img src="@/assets/logo.png" alt="Quick Favor Logo" class="logo" />
      <h1>Registro</h1>
      <!-- Aquí van los campos de formulario -->
      <form>
        <!-- Campos de entrada de ejemplo -->
        <div class="form-group">
          <label for="nombre">Nombre</label>
          <input type="text" id="nombre" placeholder="Nombre" />
        </div>
        <!-- Agrega aquí los demás campos como Apellido Paterno, Materno, CURP, etc. -->
      </form>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';

export default defineComponent({
  name: "Register"
});
</script>

<style scoped>
/* Contenedor principal de la vista */
.register-container {
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  height: 100vh;
  background-color: #d0dadb; /* Color de fondo de la página */
}

/* Fondo circular */
.circular-background {
  position: absolute;
  width: 50%;
  height: 100%;
  border-radius: 50%;
  background-color: #95abb3; /* Color del fondo circular */
  left: 0;
  top: 0;
}

/* Contenedor del formulario de registro */
.register-form {
  position: relative;
  background-color: #ffffff;
  padding: 2rem;
  border-radius: 10px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
  width: 300px;
  text-align: center;
  z-index: 1;
}

/* Estilos del logo */
.logo {
  width: 100px;
  margin-bottom: 1rem;
}

/* Estilos de los campos del formulario */
.form-group {
  margin-bottom: 1rem;
}

.form-group label {
  display: block;
  font-weight: bold;
  margin-bottom: 0.5rem;
}

.form-group input {
  width: 100%;
  padding: 0.5rem;
  border: 1px solid #ccc;
  border-radius: 5px;
}
</style>
