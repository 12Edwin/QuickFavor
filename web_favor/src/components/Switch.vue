<template>
  <div class="switch-container">
    <div class="toggle">
              <input type="checkbox" id="btn" v-model="isEnabled" @change="toggleSwitch" />
              <label for="btn">
                <span class="track"></span>
                <span class="thumb">
                  <span class="icon_off"><v-icon icon="fa-solid fa-power-off"/> </span>
                </span>
                <span class="label-text" :class="{'on': isEnabled, 'off': !isEnabled}">
                  {{ isEnabled ? 'Activo' : 'Inactivo' }}
                </span>
              </label>
            </div>
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
.toggle {
  position: relative;
  display: inline-block;
  width: 300px;
  height: 40px;
  box-shadow: #666;
}

.toggle input[type="checkbox"] {
  display: none;
}

.toggle label {
  position: relative;
  display: block;
  background-color: #ccc; /* color por defecto (rojo) */
  border-radius: 20px;
  width: 100%;
  height: 100%;
  transition: background-color 0.6s;
  cursor: pointer;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
}

/* La palanca (thumb) del toggle */
.toggle .thumb {
  position: absolute;
  top: -3px;
  left: -10px;
  width: 45px;
  height: 45px;
  background-color: #fff;
  border-radius: 50%;
  transition: left 0.6s;
  z-index: 1;
  border: 2px solid #999; 
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3); 
}

.toggle input:checked + label .thumb {
  left: 260px; 
  background-color: #fff;
}

.toggle .label-text {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 2;
  text-align: center;
  line-height: 40px;
  font-size: 14px;
  font-weight: bold;
  color: #fff;
}

.toggle .label-text.on {
  color: #fff;
}

.toggle .label-text.off {
  color: #fff;
}

.toggle input:checked + label {
  background-color: #89A7B1;
}

.toggle input:checked + label .track {
  background-color: #89A7B1; 
  box-shadow: 0 4px 8px rgba(0, 128, 0, 0.3); 
}

.toggle input:checked + label .label-text {
  color: #fff;
}

.toggle input:checked + label .thumb {
  background-color: #fff;
}

.toggle input:not(:checked) + label {
  background-color: #e74c3c; /* Rojo cuando está desactivado */
}

.toggle .thumb .icon_off {
  position: absolute;
  top: 49%;
  left: 49%;
  transform: translate(-50%, -50%);
  font-size: 14px;
  color: #666; 
  transition: color 0.6s;
  box-shadow: #666;
}

.toggle input:checked + label .thumb .icon_off {
  color:  #0672ff; 
}

.toggle .track {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: transparent;
  border-radius: 20px;
  z-index: 0;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
}

@media screen and (max-width: 768px) {
  .toggle {
    width: 180px;
  }
  .toggle input:checked + label .thumb {
    left: 150px; 
    background-color: #fff;
  }
  
}

</style>