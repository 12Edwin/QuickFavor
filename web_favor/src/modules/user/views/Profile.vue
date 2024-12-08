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

      <!-- Botón Editar Perfil -->
      <div class="edit-profile-btn-container">
        <v-btn 
          class="edit-profile-btn" 
          @click="handleModalUpdateUserInfo(true)"
          rounded
        >
          <v-icon class="fa-solid fa-pencil icon-edit"></v-icon>
        </v-btn>

        <div v-if="profile.plate_url != null">
          <v-btn 
            class="edit-profile-btn" 
            @click="handleModalShowPlate(true)"
            rounded
          >
            <v-icon class="fa-solid fa-id-card icon-edit"></v-icon>
          </v-btn>
        </div>
        <div v-if="profile.ine_url != null">
          <v-btn 
            class="edit-profile-btn" 
            @click="handleModalShowINE(true)"
            rounded
          >
            <v-icon class="fa-regular fa-id-card icon-edit"></v-icon>
          </v-btn>
        </div>
          <!-- Indicador de carga -->
          <v-progress-circular
              v-if="isLoading"
              indeterminate
              color="primary"
              size="70"
              width="7"
              class="loading-spinner"
            ></v-progress-circular>
      </div>

      <!-- Contenido del Perfil -->
      <v-container class="profile-content">
        <v-row>
          <!-- Información Principal -->
          <v-col cols="12" md="8">
            <div class="profile-info">
              <h2 class="profile-name">{{ profile.name }} {{ profile.surname }}</h2>
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

                <!-- Carros y motos -->
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
                    <input type="text" :value="profile.brand" class="register-input" disabled>
                  </div>
                  <div class="input-container">
                    <v-icon class="fa-solid fa-file icon"></v-icon>
                    <input type="text" :value="profile.model" class="register-input" disabled>
                  </div>
                  <div class="input-container">
                  <!-- Icono con color dinámico, cambia de color según profile.color -->
                  <v-icon
                    class="fa-solid fa-circle icon"
                    :style="{ color: profile.color || defaultColor }"
                  ></v-icon>
                  
                  <!-- Input con valor oculto pero con color dinámico -->
                  <input 
                    type="text" 
                    value="Color" 
                    class="register-input" 
                    disabled 
                    aria-label="Color seleccionado" 
                  />
                </div>
                </div>

                <!-- Bicicletas y Scooters -->
                <div v-if="profile.vehicle_type == 'Bicicleta' || profile.vehicle_type == 'Scooter'">
                  <v-row align="center" justify="center">
                    <div v-if="profile.vehicle_type == 'Bicicleta'">
                    <div class="content-image">
                      <v-icon class="fa-solid fa-bicycle icon-step-2"></v-icon>
                    </div>
                    </div>
                    <div v-if="profile.vehicle_type == 'Scooter'">
                      <div class="content-image">
                      <v-icon class="fa-solid fa-dolly icon-step-2"></v-icon>
                    </div>
                    </div>
                  </v-row>
                  <div class="input-container">
                    <v-icon class="fa-solid fa-file icon"></v-icon>
                    <input type="text" :value="profile.model" class="register-input" disabled>
                  </div>
                </div>

                <!-- Para los caminantes -->
                <div v-if="profile.vehicle_type == 'Caminando'">
                  <v-row align="center" justify="center">
                    <div class="content-image">
                      <v-icon class="fa-solid fa-person-walking icon-step-2"></v-icon>
                    </div>
                  </v-row>
                </div>

                <!-- Para los que tienen otro tipo de transporte -->
                <div v-if="profile.vehicle_type == 'Otro'">
                  <v-row align="center" justify="center">
                    <div class="content-image">
                      <v-icon class="fa-solid fa-plus icon-step-2"></v-icon>
                    </div>
                  </v-row>
                  <div class="input-container">
                    <v-icon class="fa-solid fa-file icon"></v-icon>
                    <input type="text" :value="profile.description" class="register-input" disabled>
                  </div>
                </div>

              </v-card-text>
              <v-card-actions class="d-flex justify-center">
                <v-btn
                  @click="handleModalUpdate(true)"
                  rounded
                  color="primary" 
                  style="width: 100px; height: 30px;
                    margin-top: -30px; 
                    background-color: transparent; 
                    color: #1976D2; 
                    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1), 0 0 10px rgba(0, 0, 0, 0.1);"         
                  >
                  Editar
                </v-btn>
              </v-card-actions>
            </v-card>
          </v-col>
        </v-row>
      </v-container>
    </v-card>
    <EditTrasnport :isModalVisible="isModalVisible" @update:isModalVisible="handleModalUpdate" :profile="profile"  />
    <UpdateUserInfo :isModalVisibleUserInfo="isModalVisibleUserInfo" @update:isModalVisibleUserInfo="handleModalUpdateUserInfo" :profile="profile"  />
    <ShowPlate :isModalVisiblePlate="isModalVisiblePlate" :profile="profile" @update:isModalVisiblePlate="handleModalShowPlate" />
    <ShowINE :isModalVisibleINE="isModalVisibleINE" :profile="profile" @update:isModalVisibleINE="handleModalShowINE" />
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, onMounted } from 'vue';
import WaveComponent from "@/components/WaveComponent.vue";
import Switch from "@/components/Switch.vue";
import EditTrasnport from '../components/UpdateTrasnport.vue';
import UpdateUserInfo from '../components/UpdateUserInfo.vue';
import ShowPlate from '../components/ShowPlate.vue';
import ShowINE from '../components/ShowINE.vue';
import { getProfile } from '../services/profile';

export default defineComponent({
  name: "Profile",
  components: { WaveComponent, Switch, EditTrasnport, UpdateUserInfo, ShowPlate, ShowINE },
  setup() {
    const isModalVisible = ref(false);
    const isModalVisibleUserInfo = ref(false);
    const isModalVisiblePlate = ref(false);
    const isModalVisibleINE = ref(false);
    const defaultColor = "#566981"; // Define a default color
    const isLoading = ref(true);

    const profile = ref({
      name: "",
      surname: "",
      phone: "",
      email: "",
      curp: "",
      face_url: "",
      vehicle_type: "",
      license_plate: "",
      model: "",
      color: "",
      description: "",
      brand: "",
      plate_url: null,
      ine_url: null,
    });

    const handleModalUpdate = (newVisibility: boolean) => {
      isModalVisible.value = newVisibility;
    };

    const handleModalUpdateUserInfo = (newVisibility: boolean) => {
      isModalVisibleUserInfo.value = newVisibility;
    };

    const handleModalShowPlate = (newVisibility: boolean) => {
      isModalVisiblePlate.value = newVisibility;
    };

    const handleModalShowINE = (newVisibility: boolean) => {
      isModalVisibleINE.value = newVisibility;
    };

    const getUserInfo = async () => {
      try {
        const data = await getProfile();
        if (data) {
          profile.value = data.data || profile.value;  
        }
      } catch (error) {
        console.error(error);
      } finally {
        isLoading.value = false;
      }
    };

    onMounted(() => {
      getUserInfo();
    });

    return {
      profile,
      handleModalUpdate,
      handleModalUpdateUserInfo,
      handleModalShowPlate,
      handleModalShowINE,
      isModalVisible,
      isModalVisibleUserInfo,
      isModalVisiblePlate,
      isModalVisibleINE,
      defaultColor,
      isLoading,
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
  margin-top: -64px;
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
  padding: 8px;
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

.icon-edit {
  position: absolute;
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

  .edit-profile-btn-container {
    margin-top: 40px;
    margin-left: 300px; /* Mover el margen al contenedor para no interferir con el botón */
    display: flex;
    gap: 12px; /* Espaciado entre los botones */
  }

.edit-profile-btn {
  color: #fff; 
  border-radius: 20px;
  padding: 8px 24px; 
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); /* Sombra sutil */
  transition: background-color 0.3s; /* Transición de color */
  border: 2px solid #1976D2; /* Mantener borde */
  font-size: 16px;
}

.edit-profile-btn .icon {
  margin-right: 8px; /* Espacio entre el ícono y el texto */
}

.edit-profile-btn:hover {
  background-color: whitesmoke; /* Color de fondo cuando el mouse pasa por encima */
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
  .edit-profile-btn-container {
    margin-left: 50%;
    margin-top: 84px;
    transform: translateX(-50%);
  }

  .edit-profile-btn {
    font-size: 14px;
    padding: 6px 18px; 
  }

  .profile-content {
    margin-top: -56px;
  }
}

@media screen and (min-width: 768px) and (max-width: 1024px) {
  .edit-card {
    margin-top: 16px;
  }  
  .profile-avatar {
    width: 150px;
    height: 150px;
  }

  .profile-name {
    font-size: 28px;
  }

  .profile-role {
    font-size: 18px;
  }

  .profile-stats {
    font-size: 16px;
  }

  .edit-profile-btn-container {
    margin-left: 50%;
    margin-top: 84px;
    transform: translateX(-50%);
  }

  .edit-profile-btn {
    font-size: 16px;
    padding: 8px 24px; 
  }

  .profile-content {
    margin-top: -64px;
  }
}

@media screen and (min-width: 1200px) {
  .details-card, .edit-card {
    margin-left: -224px;
  }
}

</style>