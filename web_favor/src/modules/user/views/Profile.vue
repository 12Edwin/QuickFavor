<template>
  <div class="back-container">
    <WaveComponent />
  </div>
  <div class="bg-amber-lighten-5" style="height: 88vh; opacity: 40%">
    <h1>Perfil</h1>
  </div>
</template>

<script lang="ts">
import {defineComponent} from 'vue'
import WaveComponent from "@/components/WaveComponent.vue";

export default defineComponent({
  name: "Profile" ,
  components: {WaveComponent}
})
</script>

<style scoped>
.back-container {
  width: 100%;
  overflow: hidden;
  position: absolute;
  bottom: 0;
  left: 0;
  z-index: -1;
}
</style>