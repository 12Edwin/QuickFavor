<template>
    <v-dialog v-model="localIsModalVisible" max-width="600px" scrollable>
      <v-card class="card-custom elevation-12">
        <v-card-title class="headline">Foto de la licencia</v-card-title>
        <v-card-text class="text-center">
          <!-- Imagen de la licencia con un estilo más atractivo -->
          <v-img 
            :src="profile.plate_url" 
            alt="Licencia" 
            max-width="250" 
            max-height="180" 
            class="mx-auto mb-6 image-card" 
            contain
          ></v-img>
          <p class="text-body-1">Aquí está la imagen de tu licencia.</p>
        </v-card-text>
  
        <v-card-actions class="d-flex justify-end">
          <v-btn color="primary" @click="closeModal"> 
            Cerrar
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </template>
  
  <script>
  export default {
    props: {
      isModalVisiblePlate: {
        type: Boolean,
        required: true,
      },
      profile: {
        type: Object,
        required: true,
      },
    },
    data() {
      return {
        localIsModalVisible: this.isModalVisiblePlate,
      };
    },
    watch: {
      isModalVisiblePlate(newValue) {
        this.localIsModalVisible = newValue;
      },
      localIsModalVisible(newValue) {
        this.$emit('update:isModalVisiblePlate', newValue);
      },
    },
    methods: {
      closeModal() {
        this.localIsModalVisible = false; 
      },
    },
  };
  </script>
  
  <style scoped>
  /* Estilo principal de la tarjeta del modal */
  .card-custom {
    position: relative;
    margin-left: 48px;
    margin-right: 48px;
    border-radius: 24px;
    background-color: rgba(255, 255, 255, 0.8); 
    backdrop-filter: blur(15px); /* Filtro de desenfoque */
    box-shadow: 0 8px 16px rgba(0, 0, 0, 0.15);
    overflow: visible;
    z-index: 1;
    transition: all 0.3s ease;
  }
  
  /* Título de la tarjeta */
  .title-custom {
    font-weight: bold;
    font-size: 1.4rem;
    color: #3A415A;
    background: linear-gradient(135deg, #6A7A9C, #3A415A);
    -webkit-background-clip: text;
    color: transparent;
    padding: 16px 0;
    border-radius: 8px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  }
  
  /* Estilo para la imagen de la licencia */
  .v-img {
    border-radius: 16px;
    box-shadow: 0 6px 12px rgba(0, 0, 0, 0.1);
    transition: transform 0.3s ease;
  }
  
  .v-img:hover {
    transform: scale(1.05); /* Efecto de zoom */
  }
  
  /* Estilo para el texto debajo de la imagen */
  .text-body-1 {
    font-size: 16px;
    color: #566981;
    font-weight: 400;
    margin-bottom: 20px;
    font-style: italic;
  }
  
  /* Estilo para el botón de Cerrar */
  .btn-close {
    background-color: #4A5C73;
    color: white;
    padding: 8px 16px;
    font-weight: 500;
    transition: all 0.3s ease;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  }
  
  .btn-close:hover {
    background-color: #3A415A;
    box-shadow: 0 6px 10px rgba(0, 0, 0, 0.15);
  }
  
  .btn-close:active {
    background-color: #2C3445;
  }
  
  </style>
  