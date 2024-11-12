<template>
  <div class="switch-container">
    <label class="switch">
      <input type="checkbox" @change="toggleSwitch">
      <span class="slider">
        <i style="color: #3b5b87" class="fas fa-power-off"></i>
      </span>
      <span class="switch-label">{{ isEnabled ? 'Activo' : 'Inactivo' }}</span>
    </label>
  </div>
</template>

<script lang="ts">
import {defineComponent} from 'vue'

export default defineComponent({
  name: "Switch",

  data() {
    return {
      isEnabled: false
    }
  },

  methods: {
    toggleSwitch(event: Event) {
      this.isEnabled = (event.target as HTMLInputElement).checked;
      if (this.isEnabled) {
        this.$emit('onTrue');
      }else {
        this.$emit('onFalse');
      }
    }
  }
})
</script>



<style scoped>

.switch-container {
  display: flex;
  align-items: center;
}

.switch {
  position: relative;
  display: inline-block;
  width: 140px;
  height: 32px;
  margin-right: 10px;
}

.switch input {
  opacity: 0;
  width: 0;
  height: 0;
}

.slider {
  position: absolute;
  cursor: pointer;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: #CB5E5E;
  transition: background-color 0.4s;
  border-radius: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.slider i {
  color: white;
  font-size: 12px;
  position: absolute;
  left: 4px;
  bottom: 4px;
  background-color: white;
  border-radius: 50%;
  height: 24px;
  width: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: transform 0.4s;
}

input:checked + .slider {
  background-color: #4caf50;
}

input:checked + .slider i {
  transform: translateX(108px);
}

.switch-label {
  font-weight: bold;
  position: absolute;
  top: 50%;
  right: 50%;
  transform: translate(50%, -50%);
  font-size: 1rem;
  color: #e7e9e9;
}
</style>