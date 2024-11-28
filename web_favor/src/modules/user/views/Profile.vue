<template>
  <div class="back-container">
    <WaveComponent />
  </div>
  <div class="profile-container">
    <!-- Header -->
    <div class="card-header d-flex align-center justify-space-between">
      <h2 class="header-title">
        <i class="fas fa-user fa-lg text-white"></i>
        <span class="ml-4 fas text-white">P E R F I L</span>
      </h2>
      <Switch @onFalse="" @onTrue=""/>
    </div>

    <v-card class="card-custom">
      <!-- Banner y Avatar -->
      <div class="banner-container">
        <div class="banner-image"></div>
        <div class="avatar-container">
          <v-avatar size="170" class="profile-avatar">
            <v-img :src="profile.face_url" alt="Profile"></v-img>
          </v-avatar>
        </div>
      </div>

      <!-- Contenido del Perfil -->
      <v-container class="profile-content">
        <v-row>
          <!-- Información Principal -->
          <v-col cols="12" md="8">
            <div class="profile-info">
              <h2 class="profile-name">{{ profile.name }}</h2>
              <span class="profile-role">Repartidor</span>
              <div class="profile-stats">
                <span><i class="fas fa-phone"></i> {{ profile.phone }}</span>
                <span><i class="fas fa-envelope"></i> {{ profile.email }}</span>
              </div>
              <div class="profile-stats">
                <span><i class="fas fa-id-card"></i> {{ profile.curp }}</span>
              </div>
            </div>
          </v-col>

          <!-- Panel de Edición -->
          <v-col cols="12" md="4">
            <v-card class="edit-card">
              <v-card-title align="center" justify="center">Transporte</v-card-title>
              <v-card-text>
                <!-- Mostrar transporte dinámicamente -->
                <div v-if="profile.vehicle_type == 'Carro' || profile.vehicle_type == 'Moto'">
                  <v-row align="center" justify="center">
                    <div v-if="profile.vehicle_type == 'Carro'">
                    <div class="content-image">
                      <v-icon class="fa-solid fa-car icon-step-2"></v-icon>
                    </div>
                    </div>
                    <div v-if="profile.vehicle_type == 'Moto'">
                      <div class="content-image">
                      <v-icon class="fa-solid fa-motorcycle icon-step-2"></v-icon>
                    </div>
                    </div>
                  </v-row>
                  <div class="input-container">
                    <v-icon class="fa-solid fa-address-card icon"></v-icon>
                    <input type="text" :value="profile.license_plate" class="register-input" disabled>
                  </div>
                  <div class="input-container">
                    <v-icon class="fa-solid fa-file icon"></v-icon>
                    <input type="text" :value="profile.model" class="register-input" disabled>
                  </div>
                  <div class="input-container">
                    <v-icon class="fa-solid fa-circle icon"></v-icon>
                    <input type="text" :value="profile.color" class="register-input" disabled>
                  </div>
                </div>

                <!-- Puedes agregar más opciones de transporte, como moto, bicicleta, etc., de forma similar -->
                <div v-if="profile.vehicle_type == 'WalKable'">
                  <v-row align="center" justify="center">
                    <div class="content-image">
                      <v-icon class="fa-solid fa-motorcycle icon-step-2"></v-icon>
                    </div>
                  </v-row>
                  <div class="input-container">
                    <v-icon class="fa-solid fa-address-card icon"></v-icon>
                    <input type="text" :value="vehicleMoto.plate" class="register-input" disabled>
                  </div>
                  <div class="input-container">
                    <v-icon class="fa-solid fa-file icon"></v-icon>
                    <input type="text" :value="vehicleMoto.model" class="register-input" disabled>
                  </div>
                  <div class="input-container">
                    <v-icon class="fa-solid fa-circle icon"></v-icon>
                    <input type="text" :value="vehicleMoto.color" class="register-input" disabled>
                  </div>
                </div>
              </v-card-text>
              <v-card-actions align="center" justify="center">
                <v-btn @click="isModalVisible = true">Editar</v-btn>
              </v-card-actions>
            </v-card>
          </v-col>
        </v-row>
      </v-container>
    </v-card>
    <EditTrasnport :isModalVisible.sync="isModalVisible" />
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, onMounted } from 'vue';
import WaveComponent from "@/components/WaveComponent.vue";
import Switch from "@/components/Switch.vue";
import EditTrasnport from '../components/UpdateTrasnport.vue';
import { getProfile } from '../services/profile';

export default defineComponent({
  name: "Profile",
  components: { WaveComponent, Switch, EditTrasnport },
  setup() {
    const isModalVisible = ref(false);
    const profile = ref({});

    const handleModalUpdate = (newVisibility: false) => {
      isModalVisible.value = newVisibility;
      console.log("Modal ");
    };

    const getUserInfo = async () => {
      const data = await getProfile();
      if (data) {
        profile.value = data.data || profile.value;  
      }
    };

    onMounted(() => {
      getUserInfo();
    });

    return {
      profile,
      handleModalUpdate,
      isModalVisible
    };
  }
});
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

.profile-container {
  padding-bottom: 20px;
  padding-left: 4vw;
  padding-right: 4vw;
  height: 100%;
}

.card-custom {
  position: relative;
  border-radius: 16px;
  min-height: 88vh;
  background-color: rgba(255, 255, 255, 0.4);
  backdrop-filter: blur(10px);
}

.card-header {
  background-color: #566981;
  padding: 1.5rem;
  border-radius: 16px 16px 16px 16px;
}

.header-title {
  color: #ffffff;
  font-size: 20px;
  font-weight: bold;
  display: flex;
  align-items: center;
  gap: 8px;
}

.banner-container {
  position: relative;
  height: 200px;
}

.banner-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 16px 16px 16px 16px;
  background: radial-gradient(circle at 100%, #89A7B1, #89A7B1 50%, #CBDAD5 75%, #556666 100%);
}

.avatar-container {
  position: absolute;
  bottom: -75px;
  left: 24px;
}

.profile-avatar {
  border: 4px solid white;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  margin-left: 42px;
}

.profile-content {
  padding-top: 80px;
  margin-left: 42px;
}

.profile-info {
  padding: 0 24px;
}

.profile-name {
  font-size: 24px;
  font-weight: bold;
  margin-bottom: 4px;
}

.profile-role {
  color: #566981;
  font-size: 16px;
}

.profile-stats {
  margin-top: 16px;
  display: flex;
  gap: 24px;
  color: #666;
}

.details-card, .edit-card {
  margin-right: 72px;
  background-color: rgba(255, 255, 255, 0.8);
  border-radius: 12px;
}

.details-card {
  margin-top: 24px;
}

.edit-card {
  padding: 16px;
  margin-top: -64px;
}

.icon-step-2 {
  font-size: 32px;
  color: #566981;
}

.content-image {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 100%;
  margin-top: 4px;
  margin-bottom: 16px;
}

.input-container {
  position: relative;
  margin-bottom: 12px;
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
    padding: 12px 12px 12px 40px; /* Espacio para el ícono */
    border: 1px solid #ccc;
    border-radius: 32px;
    outline: none;
    transition: border-color 0.3s;
    height: 40px;
  }

@media screen and (max-width: 768px) {
  .profile-avatar {
    width: 120px;
    height: 120px;
  }

  .profile-name {
    font-size: 20px;
  }

  .profile-role {
    font-size: 14px;
  }

  .profile-stats {
    font-size: 14px;
  }

  .edit-card {
    margin-top: 0px;
  }  
}

</style>