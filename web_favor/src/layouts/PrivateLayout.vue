<template>
  <div>
    <div class="d-flex flex-column flex-md-row ">
      <SideBar :class="{ 'active': isSidebarOpen }"/>
      <div class="content">
        <div class="header">
          <span class="text-light text me-3">Juan Rodrígo</span>
        </div>
        <div class="content-body">
          <router-view></router-view>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';
import SideBar from "@/components/SideBar.vue";

export default defineComponent({
  name: "PrivateLayout",
  components: { SideBar },
  data() {
    return {
      isSidebarOpen: false
    };
  }
});
</script>

<style scoped>

.content {
  flex-grow: 1;
  overflow: hidden;
  height: 100vh;
  position: relative;
  -ms-overflow-style: none;
  scrollbar-width: none;
  height: 100vh;
  display: flex;
  flex-direction: column;
}


/* Oculta el scrollbar en Chrome, Safari y Opera */
body::-webkit-scrollbar, .content::-webkit-scrollbar {
  display: none;
}

/* Cuerpo del contenido con padding */
.content-body {
  padding-top: 16px;
}

/* Encabezado sticky en la parte superior */
.header {
  z-index: 1;
  position: sticky;
  top: 0;
  left: 0;
  width: 100%;
  height: 8vh;
  background-color: rgba(137, 167, 177, 0.6);
  backdrop-filter: blur(5px);
  display: flex;
  justify-content: flex-end;
  align-items: center;
  padding-right: 16px; /* Espacio extra a la derecha */
}

/* Estilos específicos para pantallas pequeñas */
@media (max-width: 900px) {
  .content {
    height: 100vh;
    padding-left: 0;
    padding-right: 0;
  }

  /* Oculta el sidebar en pantallas pequeñas */
  .sidebar {
    display: none;
  }

  /* Muestra el sidebar cuando está activo en pantallas pequeñas */
  .sidebar.active {
    display: block;
  }
}
</style>
