<template>
  <div class="back-container">
    <WaveComponent />
  </div>
  <div class="notifications-container">
    <div class="card-header d-flex align-center justify-space-between">
      <h2 class="header-title">
        <i class="fas fa-bell bell-icon text-white"> <span class="ml-4 bell-icon fas text-white"> N o t i f i c a c i o n e s </span></i>
      </h2>
      <Switch @onFalse="" @onTrue=""/>
    </div>
    <v-card class="container-details">
      <div class="content">
            <v-row>
              <v-col cols="12">
                <v-card class="notification-card" 
                        v-for="notification in paginatedNotifications" 
                        :key="notification.id">
                  <v-row>
                    <v-col cols="1">
                      <div class="line-indicator"></div>
                    </v-col>
                    <v-col cols="7">
                      <v-card-title>{{ notification.title }}</v-card-title>
                      <v-card-text>{{ notification.date }}</v-card-text>
                    </v-col>
                    <v-col cols="4">
                      <div style="display: flex; justify-content: center; align-items: center; height: 100%;">
                        <div class="m-7">
                          <v-card-actions>
                            <v-btn><v-img src="https://cdn.icon-icons.com/icons2/2065/PNG/512/view_show_icon_124811.png" width="25px"></v-img></v-btn>
                          </v-card-actions>
                        </div>
                      </div>
                    </v-col>
                  </v-row>
                </v-card>
              </v-col>
            </v-row>
            <v-row justify="center">
              <v-btn @click="prevPage" :disabled="currentPage === 1">Anterior</v-btn>
              <v-btn @click="nextPage" :disabled="currentPage === totalPages">Siguiente</v-btn>
            </v-row>
          </div>
    </v-card>
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';
import WaveComponent from "@/components/WaveComponent.vue";
import Switch from "@/components/Switch.vue";

export default defineComponent({
  name: "Notifications",
  components: {Switch, WaveComponent },
  data() {
    return {
      currentPage: 1,
      notifications: [
        { id: 1, title: '10 productos nuevos', date: '2021-09-01' },
        { id: 2, title: '11 productos nuevos', date: '2021-09-02' },
        { id: 3, title: '12 productos nuevos', date: '2021-09-03' },
        { id: 4, title: '13 productos nuevos', date: '2021-09-04' },
        { id: 5, title: '14 productos nuevos', date: '2021-09-05' },
        { id: 6, title: '15 productos nuevos', date: '2021-09-06' }
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

.notifications-container{
  padding-bottom: 20px;
  padding-left: 4vw;
  padding-right: 4vw;
  height: 100%;
}

.container-details{
  background-color: rgba(255, 255, 255, 0.4);
  padding: 2rem;
  border-radius: 10px;
}

.notification-card {
  margin-top: 16px;
  margin-left: 16px;
  margin-right: 16px;
  border-radius: 32px;
}
.line-indicator {
  width: 16px;
  height: 100%;
  background-color: #34344E;
}

</style>