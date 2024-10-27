<template>
  <div>
    <div class="d-flex">
      <SideBar/>
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
import {defineComponent} from 'vue'
import SideBar from "@/components/SideBar.vue";
import WaveComponent from "@/components/WaveComponent.vue";

export default defineComponent({
  name: "PrivateLayout",
  components: {WaveComponent, SideBar}
})
</script>

<style scoped>
.content{
  width: 100%;
  overflow: auto;
  height: 100vh;
  position: relative;
  -ms-overflow-style: none;  /* IE and Edge */
  scrollbar-width: none;  /* Firefox */
}

body::-webkit-scrollbar, .content::-webkit-scrollbar {
  display: none;  /* Chrome, Safari, and Opera */
}

.content-body{
  padding-top: 8px;
  padding-left: 32px;
  padding-right: 32px;
}

.header{
  z-index: 1;
  position: sticky;
  top: 0;
  left: 0;
  width: 100%;
  height: 8vh;
  background-color: rgba(137, 167, 177, 0.6);
  backdrop-filter: blur(5px);
  display: flex;
  justify-content: right;
  align-items: center;
  padding: 16px;
}
</style>