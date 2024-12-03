<template>
  <v-dialog v-model="localIsModalVisible" max-width="600px">
    <v-card class="card-custom">
      <v-card-title class="headline">Selecciona el nuevo transporte</v-card-title>
      <v-card-text>
        <!-- Botones en la parte superior -->
        <div>
          <div class="icon-button-group">
          <button 
            class="icon-button-step2"
            :class="{ 'selected': selectOptionClick === 1 }" 
            @click.prevent="selectOption(1)">
            <v-icon class="fa-solid fa-car icon-step-2"></v-icon>
          </button>
          <button 
            class="icon-button-step2"
            :class="{ 'selected': selectOptionClick === 2 }" 
            @click.prevent="selectOption(2)">
            <v-icon class="fa-solid fa-motorcycle icon-step-2"></v-icon>
          </button>
          <button 
            class="icon-button-step2"
            :class="{ 'selected': selectOptionClick === 3 }" 
            @click.prevent="selectOption(3)">
            <v-icon class="fa-solid fa-bicycle icon-step-2"></v-icon>
          </button>
          <button 
            class="icon-button-step2"
            :class="{ 'selected': selectOptionClick === 4 }" 
            @click.prevent="selectOption(4)">
            <v-icon class="fa-solid fa-dolly icon-step-2"></v-icon>
          </button>
          <button 
            class="icon-button-step2"
            :class="{ 'selected': selectOptionClick === 5 }" 
            @click.prevent="selectOption(5)">
            <v-icon class="fa-solid fa-person-walking icon-step-2"></v-icon>
          </button>
          <button 
            class="icon-button-step2"
            :class="{ 'selected': selectOptionClick === 6 }" 
            @click.prevent="selectOption(6)">
            <v-icon class="fa-solid fa-plus icon-step-2"></v-icon>
          </button>
        </div>

        <!-- Mostrar solo descripción -->
        <div v-if="showDescriptionOnly">
          <div class="input-container">
            <v-icon class="fa-solid fa-file icon"></v-icon>
            <input type="text" v-model="form.description" placeholder="Descripción" class="register-input" required>
          </div>
        </div>

        <!-- Mostrar solo imagen -->
        <div v-else-if="showImageOnly" class="walkable-image">
          <v-row>
            <img src="../../../assets/walk.png" alt="Walking" width="300px">
          </v-row>
        </div>

        <!-- Mostrar solo el modelo -->
        <div v-else-if="showModelOnly">
          <div class="input-container">
            <v-icon class="fa-solid fa-file icon"></v-icon>
            <input type="text" v-model="form.model" placeholder="Modelo" class="register-input" required>
          </div>
        </div>

        <!-- Mostrar formulario completo de Matrícula y Modelo si no es descripción ni imagen -->
        <div v-else>
          <div class="input-container">
            <v-icon class="fa-solid fa-address-card icon"></v-icon>
            <input type="text" v-model="form.license_plate" placeholder="Matrícula" class="register-input" required>
          </div>
          <div class="input-container">
            <v-icon class="fa-solid fa-file icon"></v-icon>
            <input type="text" v-model="form.model" placeholder="Modelo" class="register-input" required>
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
                    <input 
                      type="file" 
                      id="file-upload" 
                      ref="fileInput" 
                      @change="handleFileChange" 
                      class="custom-file-input" 
                    />
                    <span class="file-placeholder">Licencia</span>
                  </label>
                </div>
              </div>
            </v-col>
          </v-row>
        </div>
        </div>
      </v-card-text>

      <v-card-actions>
        <v-btn color="secondary" @click="openModal">Guardar</v-btn>
        <v-btn color="primary" @click="closeModal">Cerrar</v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
  <ConfirmationModal :is-visible="showModal" @cancel="closeModal" @confirm="saveTrasport" :is-completed="false" message="¿Estás seguro o segura de actualizar la info. de tú medio de transporte?"/>
</template>

<script>
import {showErrorToast, showSuccessToast} from "@/kernel/alerts";
import {getErrorMessages, convertirImagenABase64} from "@/kernel/utils";
import ConfirmationModal from "@/kernel/confirmation_modal.vue";
import { updateProfile, updateTransport } from '../services/profile';

export default {
  props: {
    isModalVisible: {
      type: Boolean,
      required: true
    },
    profile: {
      type: Object,
      required: true
    } 
  },
  components: {ConfirmationModal },
  data() {
    return {
      localIsModalVisible: this.isModalVisible, // Usamos una variable local para el diálogo
      selectOptionClick: 2,
      showDescriptionOnly: false,
      showImageOnly: false,
      showModelOnly: false,
      showModal: false,
      form: {
        description: '',
        license_plate: '',
        model: '',
        color: '#000000',
        plate_url: null,
        vehicle_type: '',
      }
    };
  },
  computed: {
    computedProfile() {
      if (this.profile) {
        return this.profile;
      }
      return {};
    }
  },
  watch: {
    isModalVisible(newValue) {
      this.localIsModalVisible = newValue;
    },
    localIsModalVisible(newValue) {
      this.$emit('update:isModalVisible', newValue);
    },
    profile: {
      handler(newProfile) {
        if (newProfile) {
          this.form.description = newProfile.description || '';
          this.form.license_plate = newProfile.license_plate || '';
          this.form.model = newProfile.model || '';
          this.form.color = newProfile.color || '';
          this.form.vehicle_type = newProfile.vehicle_type || '';

          switch (newProfile.vehicle_type) {
            case 'Carro':
              this.selectOption(1);
              break;
            case 'Moto':
              this.selectOption(2);
              break;
            case 'Bicicleta':
              this.selectOption(3);
              break;
            case 'Scooter':
              this.selectOption(4);
              break;
            case 'Caminando':
              this.selectOption(5);
              break;
            case 'Otro':
              this.selectOption(6);
              break;
          }
        }
      },
      immediate: true,
    },
  },
  methods: {
    selectOption(option) {
      this.selectOptionClick = option;
      if ([3, 4].includes(option)) {
        this.showModelOnly = true;
        this.showDescriptionOnly = false;
        this.showImageOnly = false;
      } else if (option === 5) {
        this.showImageOnly = true;
        this.showDescriptionOnly = false;
        this.showModelOnly = false;
      } else if (option === 6) {
        this.showDescriptionOnly = true;
        this.showImageOnly = false;
        this.showModelOnly = false;
      } else {
        this.showDescriptionOnly = false;
        this.showModelOnly = false;
        this.showImageOnly = false;
      }
    },
     // Manejo del cambio de archivo
     async handleFileChange (event) {
        const target = event.target;
        const file = target?.files ? target.files[0] : null;

        if (file) {
          try {
            const base64 = await convertirImagenABase64(file); // Convertir imagen a Base64
            this.form.plate_url = base64; // Almacenar el resultado en la referencia reactiva
          } catch (error) {
            console.error("Error al convertir la imagen:", error);
          }
        } else {
          // Si no hay archivo, limpiar la propiedad
          base64Image.value = null;
        }
      },
    openModal() {
      this.showModal = true;
    },
    closeModal() {
      this.localIsModalVisible = false; // Cerrar el modal
      this.showModal = false; // Cerrar el modal de confirmación
    },
    async saveTrasport() {
      if (this.form.description) {
        this.profile.description = this.form.description;
      }
      if (this.form.license_plate) {
        this.profile.license_plate = this.form.license_plate;
      }
      if (this.form.model) {
        this.profile.model = this.form.model;
      }
      if (this.form.color) {
        this.profile.color = this.form.color;
      }
      if (this.form.vehicle_type) {
        this.profile.vehicle_type = this.form.vehicle_type;
      }
      if (this.form.plate_url) {
        this.profile.plate_url = this.form.plate_url;
      }

      try {
        const type = this.selectOptionClick;
        let data = {};
        switch (type) {
          case 1:
            this.profile.vehicle_type = 'Carro';
            data = {
              vehicle_type: 'Carro',
              license_plate: this.form.license_plate,
              model: this.form.model,
              color: this.form.color,
              plate_url: this.form.plate_url,
            };
            break;
          case 2:
            this.profile.vehicle_type = 'Moto';
            data = {
              vehicle_type: 'Moto',
              license_plate: this.form.license_plate,
              model: this.form.model,
              color: this.form.color,
              plate_url: this.form.plate_url,
            };
            break;
          case 3:
            this.profile.vehicle_type = 'Bicicleta';
            data = {
              vehicle_type: 'Bicicleta',
              model: this.form.model,
              color: this.form.color,
            };
            break;
          case 4:
            this.profile.vehicle_type = 'Scooter';
            data = {
              vehicle_type: 'Scooter',
              model: this.form.model,
              color: this.form.color,
            };
            break;
          case 5:
            this.profile.vehicle_type = 'Caminando';
            data = {
              vehicle_type: 'Caminando',
            };
            break;
          case 6:
            this.profile.vehicle_type = 'Otro';
            data = {
              vehicle_type: 'Otro',
              description: this.form.description,
            };
            break;
        }

        const result = await updateTransport(data);
        console.log(result);
        if (result.error) {
          showErrorToast(getErrorMessages(result.message));
          return;       
        }

        this.showModal = false;
        this.localIsModalVisible = false;
        showSuccessToast('Información actualizada correctamente');
        this.$emit('update:isModalVisible', this.localIsModalVisible);  
      } catch (error) {
        showErrorToast(getErrorMessages(error.message))
        console.error(error);
      }
    },

  }
};
</script>

<style scoped>
.icon-button-group {
  display: flex;
  justify-content: center;
  gap: 16px; /* Espacio entre los botones */
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
  background-color: #3A415A; /* Fondo cuando está seleccionado */
  border-radius: 50%;
}

.icon-button-step2.selected .icon-step-2 {
  color: white; /* Color del icono cuando está seleccionado */
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
  background-color: #34344E; /* Fondo similar al color del color-picker */
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

.register-input {
  width: 100%;
  padding: 12px 12px 12px 40px; /* Espacio para el ícono */
  border: 1px solid #ccc;
  border-radius: 32px;
  outline: none;
  transition: border-color 0.3s;
  height: 40px;
}

.register-input:focus {
  border-color: #3A415A;
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

</style>
