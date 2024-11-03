<template>
  <div>
    <div class="d-flex flex-column flex-md-row">
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
  components: { SideBar }
});
</script>

<style scoped>
.content {
  flex-grow: 1;
  overflow: auto;
  height: 100vh;
  position: relative;
  -ms-overflow-style: none;
  scrollbar-width: none;
}

body::-webkit-scrollbar, .content::-webkit-scrollbar {
  display: none;
}

.content-body {
  padding-top: 8px;
  padding-left: 32px;
  padding-right: 32px;
}

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
}

@media (max-width: 900px) {
  .content {
    height: 100vh;
    padding-left: 0;
    padding-right: 0;
  }
  .sidebar {
    display: none;
  }

  .sidebar.active {
    display: block;
  }
}
</style>
