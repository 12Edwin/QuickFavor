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
                <div v-if="savePhotoOpc">
                  <v-icon class="fa-solid fa-check icon-especial"></v-icon>
                </div>
                <div v-else>
                  <v-icon class="fa-solid fa-camera icon-especial"></v-icon>
                </div>
                <div class="custom-file-input-wrapper">
                  <label for="file-upload" class="file-label">
                    <button @click="startCamera" class="camera-button">Licencia</button>
                  </label>
                </div>
              </div>
             </v-col>

          </v-row>
           <!-- Mostrar el video en vivo cuando la cámara esté activa -->
           <div v-show="isCameraActive" align="center" justify="center">
                <v-row >
                  <v-col cols="12">
                    <div class="camera-container">
                      <video ref="video" autoplay playsinline></video>
                    </div>
                    
                    <!-- Botones para tomar la foto -->
                    <div class="btn-container-photos">
                      <button @click="takePhoto">Tomar Foto</button>
                      <button @click="cancelCamera">Cancelar</button>
                    </div>
                  </v-col>
                </v-row>
              </div>


              <!-- Mostrar la foto tomada -->
              <div v-if="photoTaken"  align="center" justify="center">
                <v-row>
                  <v-col cols="12">
                      <div class="camera-container">
                        <img :src="photo" alt="Foto capturada" width="70%"/>
                      </div>
                  <!-- Botón para reiniciar y tomar otra foto -->
                  <div class="btn-container-photos">
                    <button @click="savePhoto">Guardar</button>
                    <button @click="resetCamera">Tomar otra foto</button>
                  </div>
                  </v-col>
                </v-row>
              </div>
            
        </div>
        </div>
      </v-card-text>

      <v-card-actions>
        <button class="btn-save" @click="openModal">GUARDAR</button>
        <v-btn color="primary" @click="closeModal">Cerrar</v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
  <ConfirmationModal :is-visible="showModal" @cancel="closeModal" @confirm="saveTrasport" :is-completed="false" message="¿Estás seguro o segura de actualizar la info. de tú medio de transporte?"/>
</template>

<script>
import {showErrorToast, showSuccessToast} from "@/kernel/alerts";
import {getErrorMessages, convertirImagenABase64, extraerBase64} from "@/kernel/utils";
import ConfirmationModal from "@/kernel/confirmation_modal.vue";
import { updateTransport } from '../services/profile';

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
      localIsModalVisible: this.isModalVisible, 
      selectOptionClick: 2,
      showDescriptionOnly: false,
      showImageOnly: false,
      showModelOnly: false,
      savePhotoOpc: false,
      showModal: false,
      isCameraActive: false,  // Controla si la cámara está activa
      photo: null,  // Guarda la foto tomada
      photoTaken: false,
      videoElement: null,  // El elemento de video
      stream: null,  // El flujo de la cámara
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
    openModal() {
      this.showModal = true;
    },
    closeModal() {
      this.savePhotoOpc = false;
      this.photo = null;
      this.localIsModalVisible = false; // Cerrar el modal
      this.showModal = false; // Cerrar el modal de confirmación
      if (this.stream ) {
        this.cancelCamera(); // Detener la cámara
      }
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
    async startCamera() {
      try {
        const mediaStream = await navigator.mediaDevices.getUserMedia({ video: true });
        this.stream = mediaStream; // Guardar el flujo de la cámara
        this.isCameraActive = true; // Activar la cámara

        this.$nextTick(() => {
          const videoElement = this.$refs.video;  // Obtener el ref del video
          if (videoElement) {
            videoElement.srcObject = mediaStream;
            videoElement.play(); // Reproducir el video
          }
        });
      } catch (err) {
        console.error("Error al acceder a la cámara:", err);
      }
    },
    resetCamera() {
      this.photoTaken = false;
      this.photo = null;
      this.startCamera(); // Reiniciar la cámara para tomar otra foto
    },
    takePhoto() {
      const canvas = document.createElement('canvas');
      const videoElement = this.$refs.video;
      canvas.width = videoElement.videoWidth;
      canvas.height = videoElement.videoHeight;
      const context = canvas.getContext('2d');
      context.drawImage(videoElement, 0, 0, canvas.width, canvas.height);
      this.photo = canvas.toDataURL('image/png'); // Convertir la imagen a base64
      this.photoTaken = true; // Indicar que la foto fue tomada

      // Detener la cámara después de tomar la foto
      if (this.stream) {
        this.stream.getTracks().forEach(track => track.stop());
        this.isCameraActive = false;
      }
    },
    cancelCamera() {
      if (this.stream) {
        this.stream.getTracks().forEach(track => track.stop());
        this.isCameraActive = false; // Detener la cámara
      }
      this.photoTaken = false; // Reiniciar el estado de la foto
    },
    savePhoto() {
      this.savePhotoOpc = true;
      const substr = extraerBase64(this.photo);
      this.form.plate_url = substr;
      this.cancelCamera();
    },
  },
    beforeDestroy() {
    // Detener la cámara si el componente se destruye
    if (this.stream) {
      this.stream.getTracks().forEach(track => track.stop());
    }
    },
  }
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

/* COMO DIJO QUE MI AMIGA AQUI INICIA TODO */
/* Estilo para el contenedor del video */
.camera-container {
  display: flex;
  justify-content: center;
  align-items: center;
  margin-bottom: 16px;
  position: relative;
  width: 60%; /* Asegura que ocupe el 100% de su contenedor */
  height: 128px; /* Ajusta la altura según sea necesario */
  background-color: #000; /* Fondo negro para el área del video */
}

video {
  width: 100%; /* Asegúrate de que el video ocupe el 100% del contenedor */
  height: 100%; /* Mantener la relación de aspecto */
  object-fit: cover; /* Para cubrir todo el área sin distorsionar */
}

/* Contenedor de los botones "Tomar Foto" y "Cancelar" dentro de la cámara */
.btn-container-photos {
  display: flex;
  align-content: center; /* Centra los botones verticalmente */
  justify-content: center; /* Centra los botones horizontalmente */
  gap: 16px; /* Espacio entre los botones */
  width: 100%;
  margin-top: 16px;
}

/* Estilo para los botones "Tomar Foto" y "Cancelar" */
.btn-container-photos button {
  padding: 10px 20px; /* Añadir más espacio dentro de los botones */
  background-color: #3A415A;
  border: none;
  border-radius: 32px;
  color: white;
  cursor: pointer;
  transition: background-color 0.3s ease;
  font-size: 14px;
  width: 128px; /* Asegura que ambos botones tengan un tamaño similar */
}

/* Efecto hover sobre los botones */
.btn-container-photos button:hover {
  background-color: #566981;
}

/* COMO DIJO MI EX HASTA AQUI */

/* Estilo del botón guardar */
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


</style>
