<template>
  <div class="public-layout">
    <router-view />
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';

export default defineComponent({
  name: "PublicLayout"
});
</script>

<style scoped>
.public-layout {
  /* Puedes establecer un ancho completo y sin márgenes para no interferir */
  width: 100%;
  height: 100%;
  margin: 0;
  padding: 0;
}
</style>
