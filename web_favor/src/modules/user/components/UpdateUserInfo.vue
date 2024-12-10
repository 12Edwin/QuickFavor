<template>
    <v-dialog v-model="localIsModalVisible" max-width="600px">
      <v-card class="card-custom">
        <v-card-title class="headline">Selecciona el nuevo transporte</v-card-title>
        <v-card-text>
          <div>
          <div class="input-container">
            <v-icon class="fa-solid fa-phone icon"></v-icon>
            <input 
              type="tel" 
              v-model="form.phone" 
              placeholder="Teléfono" 
              class="register-input" 
              required 
              :class="{ 'is-invalid': phoneError }" 
              @input="validatePhone"
            />
          </div>
          <div v-if="phoneError" class="validation-message">El teléfono debe tener solo números y 10 dígitos</div>
        </div>
        </v-card-text>
  
        <v-card-actions>
          <button class="btn-save" @click="openModal" :disabled="phoneError">GUARDAR</button>
          <v-btn color="primary" @click="closeModal">Cerrar</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
    <ConfirmationModal :is-visible="showModal" @cancel="closeModal" @confirm="saveInfo" :is-completed="false" message="¿Estás seguro o segura de actualizar tú información?"/>
  </template>
  
  <script>
import { updateProfile } from '../services/profile';
import {showErrorToast, showSuccessToast} from "@/kernel/alerts";
import {getErrorMessages} from "@/kernel/utils";
import ConfirmationModal from "@/kernel/confirmation_modal.vue";

export default {
  props: {
    isModalVisibleUserInfo: {
      type: Boolean,
      required: true,
    },
    profile: {
      type: Object,
      required: true,
    },
  },
  components: {ConfirmationModal },
  data() {
    return {
      localIsModalVisible: this.isModalVisibleUserInfo,
      showModal: false,
      form: {
        phone: '',
      },
      phoneError: false,
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
    isModalVisibleUserInfo(newValue) {
      this.localIsModalVisible = newValue;
    },
    localIsModalVisible(newValue) {
      this.$emit('update:isModalVisibleUserInfo', newValue);
    },
    profile: {
      handler(newProfile) {
        if (newProfile) {
          this.form.phone = newProfile.phone || '';
        }
      },
      immediate: true,
    },
  },
  methods: {
    validatePhone() {
      const regex = /^[0-9]{10}$/;
      this.phoneError = !regex.test(this.form.phone);
    },
    openModal() {
      this.showModal = true;
    },
    async saveInfo() {
      this.profile.phone = this.form.phone;
      try {
        const result = await updateProfile(this.form);
        console.log(result);
        if (result.error) {
          showErrorToast(getErrorMessages(result.message));
          return;       
        }
        this.showModal = false;
        this.localIsModalVisible = false;
        if (result.code === 200) {
          showSuccessToast('Información actualizada correctamente');
        }

        if (result.code == 201) {
          showSuccessToast('Información actualizada en cache');  
        }

        if (result.code === 400) {
          showErrorToast('Error al actualizar la información');
        }
        this.$emit('update:isModalVisibleUserInfo', this.localIsModalVisible);  
      } catch (error) {
        showErrorToast(getErrorMessages(error.message))
        console.error(error);
      }
    },
    closeModal() {
      this.showModal = false;
      this.localIsModalVisible = false; 
    },
  },
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

.btn-save {
  background-color: #34344E; 
  color: white;
  border: none; 
  padding: 12px;
  font-size: 14px;
  text-transform: uppercase;
  border-radius: 8px;
  cursor: pointer; 
  transition: all 0.3s ease; 
}

/* Efecto hover */
.btn-save:hover {
  background-color: #4a4a73; 
  transform: translateY(-2px);
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); 
}

.btn-save:active {
  background-color: #2c2c3d;
  transform: translateY(1px); 
}

.btn-save:disabled {
  background-color: #b0b0b0; 
  cursor: not-allowed; 
}
  </style>
  