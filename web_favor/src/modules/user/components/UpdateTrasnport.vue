<template>
  <v-dialog v-model="localIsModalVisible" max-width="600px">
    <v-card>
      <v-card-title class="headline">Selecciona El nuevo transporte</v-card-title>
      <v-card-text>
        <!-- Botones en la parte superior -->
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
            <input type="text" v-model="form.descripcion" placeholder="Descripción" class="register-input" required>
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
            <input type="text" v-model="form.modelo" placeholder="Modelo" class="register-input" required>
          </div>
        </div>

        <!-- Mostrar formulario completo de Matrícula y Modelo si no es descripción ni imagen -->
        <div v-else>
          <div class="input-container">
            <v-icon class="fa-solid fa-address-card icon"></v-icon>
            <input type="text" v-model="form.matricula" placeholder="Matrícula" class="register-input" required>
          </div>
          <div class="input-container">
            <v-icon class="fa-solid fa-file icon"></v-icon>
            <input type="text" v-model="form.modelo" placeholder="Modelo" class="register-input" required>
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
      </v-card-text>

      <v-card-actions>
        <v-btn color="primary" @click="closeModal">Cerrar</v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
export default {
  props: {
    isModalVisible: {
      type: Boolean,
      required: true
    }
  },
  data() {
    return {
      localIsModalVisible: this.isModalVisible, // Usamos una variable local para el diálogo
      selectOptionClick: null,
      showDescriptionOnly: false,
      showImageOnly: false,
      showModelOnly: false,
      form: {
        descripcion: '',
        matricula: '',
        modelo: '',
        color: '#000000',
        licencia: null
      }
    };
  },
  watch: {
    // Observamos la prop para actualizar el valor local cuando se modifica desde el componente padre
    isModalVisible(newValue) {
      this.localIsModalVisible = newValue;
    },
    // Observamos la variable local y emitimos el cambio hacia el componente padre
    localIsModalVisible(newValue) {
      this.$emit('update:isModalVisible', newValue);
    }
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
    handleFileChange(event) {
      const file = event.target.files[0];
      if (file) {
        this.form.licencia = file;
      }
    },
    closeModal() {
      this.localIsModalVisible = false; // Cerrar el modal
    }
  }
};
</script>

<style scoped>
.icon-button-group {
  display: flex;
  justify-content: space-around;
  margin-bottom: 20px;
}

.icon-button-step2 {
  border: none;
  background: none;
  cursor: pointer;
}

.icon-button-step2.selected {
  background-color: #f0f0f0;
}

.register-input {
  width: 100%;
  padding: 10px;
  margin-top: 10px;
}

.color-input {
  width: 100%;
}

.color-container {
  display: flex;
  justify-content: center;
  align-items: center;
}

.walkable-image img {
  display: block;
  margin: 0 auto;
}

.file-placeholder {
  color: #888;
}
</style>
