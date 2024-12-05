<!-- ConfirmationModal.vue -->
<template>
  <transition name="fade">
    <div v-if="isVisible" class="m_overlay" @click="handleOverlayClick">
      <div class="m_modal-wrapper">
        <div class="m_modal" :class="{ 'highlight': isHighlighted }" @click.stop>
          <div class="m_modal-content">
            <div class="m_icon" :class="{ 'completed': isCompleted, 'error': !isCompleted }">
              <span v-if="isCompleted">✓</span>
              <span v-else>?</span>
            </div>
            <h2 style="color: #2383f0" class="mb-3">{{ title }}</h2>
            <p>{{ message }}</p>
            <p style="color: red">{{ extraText }}</p>
            <div class="buttons">
              <button @click="confirm">
                {{ confirmText }}
              </button>
              <button v-if="!isCompleted" style="background: gray" @click="cancel">{{ cancelText }}</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </transition>
</template>

<script lang="ts">
import {defineComponent} from "vue";

export default defineComponent({
  name: "ConfirmationModal",
  props: {
    isVisible: Boolean,
    isCompleted: Boolean,
    title: String,
    message: String,
    confirmText: {
      type: String,
      default: 'Continuar'
    },
    cancelText: {
      type: String,
      default: 'Cancelar'
    },
    extraText:{
      type: String,
      default: ''
    }
  },
  data() {
    return {
      isHighlighted: false
    }
  },
  methods: {
    confirm() {
      this.$emit('confirm')
    },
    cancel() {
      this.$emit('cancel')
    },
    handleOverlayClick() {
      this.isHighlighted = true
      setTimeout(() => {
        this.isHighlighted = false
      }, 1000) // Duración extendida para el efecto de ondas
    }
  }
})
</script>

<style scoped>
.m_overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(122, 118, 118, 0.4);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 10000;
}

.m_modal-wrapper {
  position: relative;
  background:
      radial-gradient(ellipse at top right, rgb(112, 138, 172), rgba(0, 0, 0, 0) 60%),
      radial-gradient(ellipse at bottom left, rgb(52, 52, 78), rgba(0, 0, 0, 0) 60%);
  border-radius: 10px;
}

.m_modal {
  z-index: 1000;
  background-color: rgba(255, 255, 255, 0.4);
  backdrop-filter: blur(5px);
  border-radius: 10px;
  padding: 20px;
  width: 300px;
  text-align: center;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease;
}

@keyframes ripple {
  0% {
    box-shadow: 0 0 0 0px rgb(137, 167, 177),
    0 0 0 0px rgb(137, 167, 177, 0.7),
    0 0 0 0px rgb(137, 167, 177, 0.4);
  }
  100% {
    box-shadow: 0 0 0 20px rgba(255, 105, 180, 0),
    0 0 0 40px rgba(255, 105, 180, 0),
    0 0 0 60px rgba(255, 105, 180, 0);
  }
}

.m_modal.highlight {
  animation: ripple 1s ease-out;
}

.m_icon {
  font-size: 48px;
  margin-bottom: 20px;
}

.completed {
  color: #4CAF50;
}

.error {
  color: #F44336;
}

.buttons {
  display: flex;
  justify-content: center;
  gap: 10px;
  margin-top: 20px;
}

button {
  padding: 10px 20px;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s ease;
  background: #2c3e50;
  color: white;
}

button:hover {
  transform: translateY(-2px);
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
}

.fade-enter-active, .fade-leave-active {
  transition: opacity 0.3s;
}

.fade-enter-from, .fade-leave-to {
  opacity: 0;
}
</style>