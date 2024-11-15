<template>
  <div>
    <div class="d-flex flex-column flex-md-row ">
      <SideBar :class="{ 'active': isSidebarOpen }"/>
      <div class="content">
        <div class="header-layout">
          <span class="text-light text mr-3 font-weight-bold mr-3">Juan Rodrígo</span>
          <span class="text-light text mr-3 font-weight-bold pa-2 px-5 cursor-pointer rounded-pill bg-blue-grey-lighten-4"> <i class="fas fa-sign-out-alt"></i> </span>
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
  overflow-y: auto;
  overflow-x: hidden;
  height: 100vh;
  position: relative;
  -ms-overflow-style: none;
  scrollbar-width: none;
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
  position: relative;
  flex-grow: 1;
}

/* Encabezado sticky en la parte superior */
.header-layout {
  z-index: 99;
  position: sticky;
  top: 0;
  left: 0;
  width: 100%;
  padding-top: calc(4dvh - 20px);
  padding-bottom: calc(4dvh - 20px);
  background-color: rgba(137, 167, 177, 0.6);
  backdrop-filter: blur(5px);
  display: flex;
  justify-content: flex-end;
  align-items: center;
  padding-right: 16px;
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
