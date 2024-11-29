<template>
  <div class="back-container">
    <WaveComponent/>
  </div>
  <div class="notifications-container">
    <div class="card-header d-flex align-center justify-space-between">
      <h2 class="header-title">
        <i class="fas fa-bell fa-lg text-white" style="font-size: 36px;"></i>
        <span class="ml-4 fas text-white">N o t i f i c a c i o n e s</span>
      </h2>
      <Switch @onFalse="" @onTrue=""/>
    </div>
    <v-card class="container-details">
      <div v-if="loading" class="loader-container">
        <v-progress-circular indeterminate color="primary"></v-progress-circular>
      </div>
      <div v-if="notifications.length === 0 && !loading" class="d-flex align-center flex-column pa-4 mb-3">
        <img src="@/assets/empty2.png" width="200">
        <v-card-title class="text-center">No hay notificaciones</v-card-title>
      </div>
      <v-card v-else v-for="(notification, ind) in paginatedNotifications"
              :key="ind"
              class="notification-card">
        <div class="flex-grow-1 d-flex h-100">
          <div class="line-indicator"></div>
          <div class="d-flex justify-space-between w-100 flex-wrap ga-1 pa-2">
            <div class="mx-1">
              <v-card-title>{{ notification.amount }} producto(s)</v-card-title>
              <v-card-text>{{ formatDate(notification.created_at) }}</v-card-text>
            </div>
            <div class="mx-2 my-auto ml-auto d-flex align-center justify-center">
              <v-btn class="rounded-pill" @click="showNotificationDetail(notification.order_id)">
                <i class="fa-solid fa-eye icon-style"></i>
              </v-btn>
            </div>
          </div>
        </div>
      </v-card>
      <v-row v-if="!loading && notifications.length > 4" class="pt-2" justify="space-evenly">
        <v-btn :disabled="currentPage === 1" @click="prevPage">Anterior</v-btn>
        <v-btn :disabled="currentPage === totalPages" @click="nextPage">Siguiente</v-btn>
      </v-row>
    </v-card>
  </div>
  <NotificationDetail :is-visible="showDetail" :id_order="current_ord" @onClose="closeDetails"/>
</template>

<script lang="ts">
import { defineComponent } from 'vue';
import WaveComponent from "@/components/WaveComponent.vue";
import Switch from "@/components/Switch.vue";
import { NotificationEntity } from "@/modules/alert/entity/notification.entity";
import { getErrorMessages, getNo_courierByToken } from "@/kernel/utils";
import { getNotifications } from "@/modules/alert/services/notification.service";
import { showErrorToast } from "@/kernel/alerts";
import {format} from "date-fns";
import NotificationDetail from "@/modules/alert/views/NotificationDetail.vue";

export default defineComponent({
  name: "Notifications",
  components: {NotificationDetail, Switch, WaveComponent },
  data() {
    return {
      current_ord: "",
      showDetail: false,
      currentPage: 1,
      notifications: [] as NotificationEntity[],
      loading: false
    };
  },
  computed: {
    totalPages(): number {
      return Math.ceil(this.notifications.length / 4);
    },
    paginatedNotifications(): NotificationEntity[] {
      const start = (this.currentPage - 1) * 4;
      return this.notifications.slice(start, start + 4);
    }
  },
  methods: {
    formatDate(dateString: string): string {
      const date = new Date(dateString);
      return format(date, 'yyyy:MM:dd HH:mm');
    },
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
    async loadNotifications() {
      this.loading = true;
      const id_courier = await getNo_courierByToken();
      if (!id_courier) {
        showErrorToast("No se pudo consultar la información del repartidor");
        return;
      }
      const response = await getNotifications(id_courier);
      if (response.error) {
        showErrorToast(getErrorMessages(response.message));
      } else {
        this.notifications = response.data as NotificationEntity[];
      }
      this.loading = false;
    },

    showNotificationDetail(ord: string) {
      this.current_ord = ord;
      this.showDetail = true;
    },

    closeDetails() {
      this.loadNotifications()
      this.showDetail = false;
    }
  },
  mounted() {
    this.loadNotifications();
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

.notification-card {
  margin-bottom: 16px;
  border-radius: 10px;
  display: flex;
}

.line-indicator {
  width: 16px;
  background-color: #34344E;
}

.loader-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100%;
}
</style>