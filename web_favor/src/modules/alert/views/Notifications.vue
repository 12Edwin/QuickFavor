<template>
  <div class="back-container">
    <WaveComponent />
  </div>
  <div class="container">
    <v-row justify="center">
      <v-col class="md-8">
        <v-card class="card-custom">
          <div class="card-header d-flex align-center justify-space-between">
            <h2 class="header-title">
              <v-icon icon="fa-solid fa-bell" style="color: white;"></v-icon> Notificaciones de favores
            </h2>
            <div class="switch-container">
              <label class="switch">
                <input type="checkbox">
                <span class="slider"></span>
              </label>
            </div>
          </div>
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
      </v-col>
    </v-row>
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';
import WaveComponent from "@/components/WaveComponent.vue";

export default defineComponent({
  name: "Notifications",
  components: { WaveComponent },
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
    }
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
  justify-content: space-between;
  padding: 0 16px;
  background-color: #566981;
  border-top-left-radius: 16px;
  border-top-right-radius: 16px;
  height: 64px;
}
.header-title {
  color: white;
  font-size: 1.25rem;
}
.switch-container {
  display: flex;
  align-items: center;
}

.switch {
  position: relative;
  display: inline-block;
  width: 48px;
  height: 24px;
}

.switch input {
  opacity: 0;
  width: 0;
  height: 0;
}

.slider {
  position: absolute;
  cursor: pointer;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: #CB5E5E;
  transition: 0.4s;
  border-radius: 24px; /* Bordes redondeados */
}

.slider:before {
  position: absolute;
  content: "";
  height: 18px;
  width: 18px;
  left: 4px;
  bottom: 3px;
  background-color: white;
  transition: 0.4s;
  border-radius: 50%;
}

input:checked + .slider {
  background-color: #4caf50;
}

input:checked + .slider:before {
  transform: translateX(24px);
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