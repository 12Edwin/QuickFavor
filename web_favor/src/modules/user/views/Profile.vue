<template>
  <div class="back-container">
    <WaveComponent/>
  </div>
  <div class="notifications-container">
    <div class="card-header d-flex align-center justify-space-between">
      <h2 class="header-title">
        <i class="fas fa-user fa-lg text-white" style="font-size: 36px;"></i>
        <span class="ml-4 fas text-white">P e r f i l</span>
      </h2>
      <Switch @onFalse="" @onTrue=""/>
    </div>
    <v-card class="container-details">
      <div class="backgraund-blue"></div>
      <div class="profile-container" >
        <v-avatar
          image="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcThnnN0Nj42DW5N9u177sXStr7NPl1JZSOODQ&s"
          size="200" class="avatar">
        </v-avatar>
      </div>
    </v-card>
  </div>
</template>

<script lang="ts">
import {defineComponent} from 'vue';
import WaveComponent from "@/components/WaveComponent.vue";
import Switch from "@/components/Switch.vue";

export default defineComponent({
  name: "Profile",
  components: {Switch, WaveComponent},
  data() {
    return {
      currentPage: 1,
      notifications: [
        {id: 1, title: '10 productos nuevos', date: '2021-09-01'},
        {id: 2, title: '11 productos nuevos', date: '2021-09-02'},
        {id: 3, title: '12 productos nuevos', date: '2021-09-03'},
        {id: 4, title: '13 productos nuevos', date: '2021-09-04'},
        {id: 5, title: '14 productos nuevos', date: '2021-09-05'},
        {id: 6, title: '15 productos nuevos', date: '2021-09-06'}
      ] as Array<{ id: number; title: string; date: string; }>
    };
  },
  computed: {
    totalPages(): number {
      return Math.ceil(this.notifications.length / 5);
    },
    paginatedNotifications(): Array<{ id: number; title: string; date: string; }> {
      const start = (this.currentPage - 1) * 5;
      return this.notifications.slice(start, start + 5);
    }
  },
  methods: {
    nextPage() {
      if (this.currentPage < this.totalPages) {
        this.currentPage++;
      }
    },
    prevPage() {
      if (this.currentPage > 1) {
        this.currentPage--;
      }
    },
  }
});
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

.card-custom {
  position: relative;
  margin-left: 16px;
  margin-right: 16px;
  border-top-left-radius: 16px;
  border-top-right-radius: 16px;
  border-bottom-left-radius: 0;
  border-bottom-right-radius: 0;
  height: 88vh;
  background-color: rgba(255, 255, 255, 0.4);
  backdrop-filter: blur(10px);
  overflow: visible;
  z-index: 1;
}

.card-header {
  display: flex;
  align-items: center;
  background-color: #566981;
  padding: 1.5rem;
  border-radius: 10px;
  justify-content: space-between;
  flex-wrap: wrap;
  gap: 1rem;
}

.header-title {
  color: #ffffff;
  font-size: 20px;
  font-weight: bold;
  display: flex;
  align-items: center;
  gap: 8px;
}

.notifications-container {
  padding-bottom: 20px;
  padding-left: 4vw;
  padding-right: 4vw;
  height: 100%;
}

.icon-style {
  font-size: 20px;
  color: #312070;
}

.container-details {
  background-color: rgba(255, 255, 255, 0.4);
  padding: 2rem;
  border-radius: 10px;
}

/* Profile styles */
.background-blue {
  width: 100%; 
  height: 100px; 
  background-color: blue; 
  border-radius: 100px 100px 0 0; 
}

.profile-container {
  flex-direction: column;
  align-items: center;
  justify-content: center;
}


</style>