<template>
  <div class="card">
    <div class="card-header">
      <span style="color: white;">Perfil</span>
      <div class="switch-container">
        <span style="color: white;">{{ isActive ? 'Activo' : 'Inactivo' }}</span>
        <label class="switch">
          <input type="checkbox" v-model="isActive" />
          <span class="slider round"></span>
        </label>
      </div>
    </div>
    <div class="card-body">
      <div class="row">
        <div class="col avatar-card">
          <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcThnnN0Nj42DW5N9u177sXStr7NPl1JZSOODQ&s" alt="Avatar" />
          <p class="user-name">Juan Rodrigo</p>
          <p class="user-phone">777-324-4375</p>
        </div>
        <div class="col info-card">
          <h3>Repartidor</h3>
          <p>CURP:OOAZ900824MTSRLL08</p>
          <p>SEXO: Masculino</p>
          <p>CORREO: correo@gmail.com</p>
        </div>
      </div>
    </div>
  </div>
</template>


<script lang="ts">
import { defineComponent } from 'vue'

export default defineComponent({
  name: "Profile",
  data() {
    return {
      isActive: false,
    };
  },
})
</script>


<style scoped>
.card {
  border: 1px solid #ddd;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
}

.card-header {
  background-color: #566981;
  color: white;
  padding: 10px;
  font-size: 18px;
  font-weight: bold;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.switch-container {
  display: flex;
  align-items: center;
  gap: 10px;
}

.switch {
  position: relative;
  display: inline-block;
  width: 34px;
  height: 20px;
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
  background-color: #ccc;
  transition: 0.4s;
  border-radius: 34px;
}

.avatar {
  display: flex;
  align-items: center;
  margin-right: 10px;
  padding-left: 2rem;
}

.avatar img {
  width: 220px;
  height: 220px;
  border-radius: 50%;
  border: 2px solid #ffffff;
}

.slider:before {
  position: absolute;
  content: "";
  height: 14px;
  width: 14px;
  left: 3px;
  bottom: 3px;
  background-color: white;
  transition: 0.4s;
  border-radius: 50%;
}

input:checked+.slider {
  background-color: #7193a6;
}

input:checked+.slider:before {
  transform: translateX(14px);
}

.row {
  display: flex;
  gap: 30px;
  align-items: center;
}

.col {
  flex: 1;
}

.avatar-card {
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
}

.avatar-card img {
  width: 120px;
  height: 120px;
  border-radius: 50%;
  border: 3px solid #566981;
}

.user-name {
  font-size: 18px;
  font-weight: bold;
  margin-top: 10px;
  color: #333;
}

.user-phone {
  color: #777;
  font-size: 14px;
}

.info-card {
  background-color: #ffffff;
  padding: 10px; 
  margin-right: 2cm;
  border-radius: 12px;
  box-shadow: 0px 2px 4px rgba(0, 0, 0, 0.1);
  max-width: 500px; 
  width: 100%;
}

.info-card h3 {
  font-size: 20px;
  color: #333;
  margin-bottom: 15px;
  text-align: center;
}

.info-card p {
  font-size: 14px;
  color: #555;
  margin: 5px 0;
}

.info-card p strong {
  color: #333;
}
</style>