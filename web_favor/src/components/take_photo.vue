<template>
  <div>
    <div :class="['icon-button', { 'has-image': imagePreview }]" @click="openPopup">
      <div class="icon-circle-large">
        <i class="fas fa-file-invoice icon"></i>
        <span v-if="imagePreview" class="badge-check">✔</span>
      </div>
      <span class="button-text">{{ label }}</span>
    </div>
    <div v-if="showPopup" class="popup-overlay">
      <div class="popup-content">
        <button @click="closePopup" class="close-btn">×</button>
        <div class="d-flex justify-space-between pa-2">
          <video ref="video" class="video" autoplay></video>
          <canvas ref="canvas" style="display: none;"></canvas>
          <img v-if="imagePreview" :src="imagePreview" alt="Image Preview" class="image-preview" />
        </div>
        <button @click="takePhoto" class="capture-button">Capturar</button>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, onMounted, onBeforeUnmount } from "vue";

export default defineComponent({
  name: "TakePhoto",
  data() {
    return {
      showPopup: false,
      imagePreview: null as string | null,
      videoStream: null as MediaStream | null,
    };
  },
  props: {
    label: {
      type: String,
      default: "Tomar foto",
    },
  },
  methods: {
    async startCamera() {
      try {
        this.videoStream = await navigator.mediaDevices.getUserMedia({ video: true });
        (this.$refs.video as HTMLVideoElement).srcObject = this.videoStream;
      } catch (error) {
        console.error("Error accessing camera: ", error);
      }
    },
    takePhoto() {
      const video = this.$refs.video as HTMLVideoElement;
      const canvas = this.$refs.canvas as HTMLCanvasElement;
      canvas.width = video.videoWidth;
      canvas.height = video.videoHeight;
      const context = canvas.getContext("2d");
      if (context) {
        context.drawImage(video, 0, 0, canvas.width, canvas.height);
        this.imagePreview = canvas.toDataURL("image/png");
        this.$emit('photo-taken', this.imagePreview);
      }
    },
    stopCamera() {
      if (this.videoStream) {
        this.videoStream.getTracks().forEach(track => track.stop());
      }
    },
    openPopup() {
      this.showPopup = true;
      this.$nextTick(() => {
        this.startCamera();
      });
    },
    closePopup() {
      this.showPopup = false;
      this.stopCamera();
    }
  },
  beforeUnmount() {
    this.stopCamera();
  },
});
</script>

<style scoped>
.capture-button {
  padding: 10px 20px;
  background-color: #566981;
  color: #ffffff;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  transition: background-color 0.3s;
}

.capture-button:hover {
  background-color: #3a415a;
}

.popup-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.popup-content {
  background: white;
  padding: 20px;
  border-radius: 8px;
  position: relative;
  width: 90%;
  max-width: 90vw;
  max-height: 80%;
  overflow: auto;
}

.close-btn {
  position: absolute;
  top: 10px;
  right: 10px;
  background: none;
  border: none;
  font-size: 24px;
  cursor: pointer;
}

.video {
  width: 100%;
  max-width: 45%;
  border: 2px solid #d2e1e6;
  border-radius: 8px;
  box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
}

.image-preview {
  margin-top: 10px;
  max-width: 45%;
  height: auto;
  border: 2px solid #d2e1e6;
  border-radius: 8px;
  box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
}

.icon-button {
  display: flex;
  flex-direction: column;
  align-items: center;
  cursor: pointer;
  transition: transform 0.3s;
}

.icon-button:hover {
  transform: scale(1.1);
}

.icon-circle-large {
  width: 56px;
  height: 56px;
  background-color: #566981;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
  border: 2px solid #d2e1e6;
  position: relative;
}

.icon-circle-large .icon {
  color: #ffffff;
  font-size: 1.5rem; /* Ajusta el tamaño del icono */
}

.button-text {
  margin-top: 8px;
  font-size: 1rem;
  color: #4A4A4A;
}

.has-image .icon-circle-large {
  border: 2px solid #4CAF50; /* Cambia el color del borde si hay una imagen */
}

.badge-check {
  position: absolute;
  top: -5px;
  right: -5px;
  background-color: #4CAF50;
  color: white;
  border-radius: 50%;
  padding: 2px 5px;
  font-size: 0.8rem;
}
</style>