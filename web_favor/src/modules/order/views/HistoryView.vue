<template>
  <div class="back-container">
    <WaveComponent />
  </div>
  <div class="history-container">
    <div class="card-header d-flex align-center justify-space-between">
      <h2 class="header-title">
        <i class="fas fa-history fa-lg text-white" style="font-size: 36px"></i>
        <span class="ml-4 fas text-white">H i s t o r i a l</span>
      </h2>
      <Switch @onFalse="toggleStatus" @onTrue="toggleStatus" />
    </div>
    <div class="details-container">
      <transition-group>
        <transition name="fade" key="loader">
          <div v-if="isLoading" class="loader-container">
            <v-progress-circular indeterminate color="primary"></v-progress-circular>
          </div>
        </transition>
        <transition name="fade" key="empty">
          <div v-if="history.length === 0 && !isLoading" class="no-orders">
            <img
                src="../../../assets/empty2.png"
                alt="No hay pedidos"
                class="no-orders-image"
            />
            Aún no hay pedidos en esta cuenta
          </div>
        </transition>
        <transition name="fade" key="content">
          <div v-if="history.length > 0">
            <div
                class="h-100"
                v-for="(item, index) in paginatedHistory"
                :key="item.no_order"
            >
              <v-card class="white-card d-flex h-100 w-100">
                <div class="left-strip"></div>
                <div class="d-flex w-100 justify-space-between flex-wrap ga-2 pa-2">
                  <div class="d-flex mx-2 flex-column justify-center mr-auto">
                    <v-card-title class="px-0"
                    >{{ item.products }} productos</v-card-title
                    >
                    <p class="date ma-0 py-1">{{ formatDate(item.created_at) }}</p>
                  </div>
                  <div class="d-flex justify-center mx-2 align-center">
                    <v-chip
                        :color="getChipColor(item.status)"
                        variant="flat"
                        class="chip-style"
                    >
                    <span style="color: white">{{ translateStatus(item.status) }}</span>
                    </v-chip>
                  </div>
                  <div class="my-auto ml-auto">
                    <v-btn class="rounded-pill">
                      <router-link
                          :to="{
                          name: 'historyDetails',
                          params: { id: item.no_order },
                        }"
                          class="icon-link"
                      >
                        <i class="fa-solid fa-eye icon-style"></i>
                      </router-link>
                    </v-btn>
                  </div>
                </div>
              </v-card>
            </div>
          </div>
        </transition>
      </transition-group>
      <v-pagination
          v-if="totalPages > 1"
          v-model="currentPage"
          :length="totalPages"
          :show-arrows="true"
          rounded="circle"
          class="pagination-style"
      ></v-pagination>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import WaveComponent from "@/components/WaveComponent.vue";
import Switch from "@/components/Switch.vue";
import { getOrderHistory } from "../services/history.service";
import { HistoryOrder } from "../entity/history.entity";

export default defineComponent({
  name: "HistoryView",
  components: { Switch, WaveComponent },
  data() {
    return {
      isActive: true,
      isLoading: true,
      history: [] as HistoryOrder[],
      currentPage: 1,
      perPage: 5,
    };
  },
  computed: {
    paginatedHistory(): HistoryOrder[] {
      const start = (this.currentPage - 1) * this.perPage;
      const end = start + this.perPage;
      return this.history.slice(start, end);
    },
    totalPages(): number {
      return Math.ceil(this.history.length / this.perPage);
    },
  },
  methods: {
    toggleStatus() {
      this.isActive = !this.isActive;
    },
    async getHistory() {
      try {
        const response = await getOrderHistory();
        if (response.code === 200) {
          this.history = response.data;
        } else {
          console.error("Error en la respuesta:", response.message);
        }
      } catch (error) {
        console.error("Error al obtener el historial de pedidos:", error);
      } finally {
        this.isLoading = false; // Oculta el loader después de cargar los datos
      }
    },
    getChipColor(estatus: string) {
      switch (estatus) {
        case "Pending":
          return "#fdab30";
        case "In delivery":
          return "#89a7b1";
        case "In shopping":
          return "#89a7b1";
        case "Finished":
          return "#3a415a";
        case "Canceled":
          return "#f70b0b";
        default:
          return "#b0bec5";
      }
    },
    translateStatus(status: string) {
    switch (status) {
      case "Pending":
        return "Pendiente";
      case "In delivery":
        return "En entrega";
      case "In shopping":
        return "En compra";
      case "Finished":
        return "Finalizado";
      case "Canceled":
        return "Cancelado";
      default:
        return status; 
    }
  },
    formatDate(dateString: string) {
      const options: Intl.DateTimeFormatOptions = {
        weekday: "long",
        year: "numeric",
        month: "long",
        day: "numeric",
        hour: "numeric",
        minute: "numeric",
      };
      const date = new Date(dateString);
      return date.toLocaleDateString("es-MX", options);
    },
  },
  mounted() {
    this.getHistory();
  },
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

.history-container {
  position: static;
  padding-bottom: 20px;
  padding-left: 4vw;
  padding-right: 4vw;
  height: 100%;
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
.details-container {
  background-color: rgba(255, 255, 255, 0.4);
  padding: 2rem;
  border-radius: 10px;
}

.no-orders {
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  color: #34344e;
  font-size: 18px;
}

.no-orders-image {
  width: 300px;
  height: auto;
  margin-bottom: 10px;
}

.white-card {
  background-color: white;
  width: 85%;
  margin-bottom: 20px;
  padding: 0;
}

.left-strip {
  width: 16px;
  background-color: #34344e;
  border-top-left-radius: 4px;
  border-bottom-left-radius: 4px;
}

.date {
  font-size: 14px;
  color: #6b7280;
}

.chip-style {
  font-size: 14px;
  font-weight: bold;
  width: 150px; /* Ancho fijo para el chip */
  display: flex;
  justify-content: center;
}

.icon-style {
  font-size: 20px;
  color: #312070;
}

.icon-link {
  text-decoration: none;
}

/* Ajustes solo para dispositivos móviles */
@media (max-width: 768px) {
  .history-container {
    height: 88vh;
    padding: 0px;
    position: relative;
    z-index: 1;
    overflow-y: auto; /* Permite desplazamiento vertical */
  }

  .icon-style {
    font-size: 30px;
    color: #312070;
    padding: 10px 8px 6px 0px;
  }

  .icon-link {
    margin-left: 3px; /* Espacio entre el chip y el icono */
    text-decoration: none;
  }

  .left-strip {
    width: 95px;
    min-height: 95px;
    background-color: #34344e;
    border-top-left-radius: 4px;
    border-bottom-left-radius: 4px;
  }
}

.loader-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100%;
}

.fade-enter-active, .fade-leave-active {
  transition: opacity 0.5s;
}
.fade-enter, .fade-leave-to /* .fade-leave-active in <2.1.8 */ {
  opacity: 0;
}
</style>
