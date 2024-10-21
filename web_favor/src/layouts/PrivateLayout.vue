<template>
  <div>

    <div class="d-flex">
      <SideBar/>
      <div class="content">
        <div class="header">
          <span class="text-light text me-3">Juan Rodrígo</span>
          <b-icon icon="box-arrow-right"  font-scale="2" style="fill: white;"></b-icon>
        </div>
        <div class="head-container">
          <WaveComponent />
        </div>
        <div class="content-body">
          <div style="height: 130vh"></div>
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
}
.content-body{
  padding-top: 8px;
  padding-left: 32px;
  padding-right: 32px;
  position: relative;
}

.header{
  z-index: 1;
  position: sticky;
  top: 0;
  left: 0;
  width: 100%;
  height: 70px;
  background-color: rgba(86, 105, 129, 0.6);
  backdrop-filter: blur(5px);
  display: flex;
  justify-content: right;
  align-items: center;
  padding: 16px;
}

.head-container {
  width: 100%;
  overflow: hidden;
  position: absolute;
  top: 0;
  left: 0;
}
</style>