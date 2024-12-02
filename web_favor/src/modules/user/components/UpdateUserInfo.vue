<template>
    <v-dialog v-model="localIsModalVisible" max-width="600px">
      <v-card class="card-custom">
        <v-card-title class="headline">Selecciona el nuevo transporte</v-card-title>
        <v-card-text>
          <!-- Botones en la parte superior -->
          <div>
            <div class="input-container">
                <v-icon class="fa-solid fa-phone icon"></v-icon>
                <input type="tel" v-model="form.phone" placeholder="Teléfono" class="register-input" required>
                </div>

                <!-- Correo -->
                <div class="input-container">
                <v-icon class="fa-solid fa-envelope icon"></v-icon>
                <input type="text" v-model="form.email" placeholder="Correo electronico" class="register-input" required>
                </div>
          </div>
        </v-card-text>
  
        <v-card-actions>
            <v-btn color="secondary" @click="openModal">Guardar</v-btn>
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
        email: '',
      },
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
          this.form.email = newProfile.email || '';
        }
      },
      immediate: true,
    },
  },
  methods: {
    openModal() {
      this.showModal = true;
    },
    async saveInfo() {
      this.profile.phone = this.form.phone;
      this.profile.email = this.form.email;
      try {
        const result = await updateProfile(this.profile);
        console.log(result);
        if (result.error) {
          showErrorToast(getErrorMessages(result.message));
          return;       
        }
        showSuccessToast('Información actualizada correctamente');
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
  
  </style>
  