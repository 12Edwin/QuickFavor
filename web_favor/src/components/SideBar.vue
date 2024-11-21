<template>
  <div class="d-flex flex-column">
    <div class="head-sidebar">
      <v-button @click="toggleSidebar" class="d-block d-md-none">
        <v-icon icon="fa-solid fa-grip-lines" class="icon-bar" />
      </v-button>
    </div>
    <div class="sidebar pr-0 pl-0 text-white pa-3" :class="{ 'active': isSidebarOpen }">
      <div class="h-sidebar">
        <img src="@/assets/logo.png" class="img-sidebar" height="100" />
        <h4 class="text-center">Quick Favor</h4>
      </div>
      <nav class="w-100 pa-0">
        <div
          class="n-item w-100 pa-0"
          v-for="(item, ind) in menuItems"
          @click="setSelected(item.name, ind)"
          :key="item.name"
        >
          <div
            :class="[
              'sidebar-item d-flex align-items-center w-100 border-0 pa-4',
              { selected: selected === item.name },
            ]"
          >
            <div><v-icon :icon="item.icon" class="icon-sidebar" /></div>
            <span class="text-sidebar">{{ item.text }}</span>
          </div>
        </div>
      </nav>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";

export default defineComponent({
  name: "SideBar",
  data() {
    return {
      selected: "",
      isSidebarOpen: false, 
      menuItems: [
        { name: "map", text: "Mapa", icon: "fa-solid fa-location-dot" },
        {
          name: "notifications",
          text: "Notificaciones",
          icon: "fa-solid fa-bell",
        },
        { name: "order", text: "Favor", icon: "fa-solid fa-box" },
        { name: "history", text: "Historial", icon: "fa-solid fa-history" },
        { name: "profile", text: "Perfil", icon: "fa-solid fa-user" },
      ],
    };
  },
  methods: {
    toggleSidebar() {
      this.isSidebarOpen = !this.isSidebarOpen; 
    },
    setSelected(name: string, ind: number) {
      const items = document.getElementsByClassName(
        "n-item"
      ) as HTMLCollectionOf<HTMLElement>;
      for (let i = 0; i < items.length; i++) {
        items[i].style.borderRadius = "0";
      }

      for (let i = 0; i < items.length; i++) {
        if (i === ind) {
          items[ind].style.backgroundColor = "rgb(203, 218, 213)";
          if (ind === 0) {
            items[i + 1].style.borderTopRightRadius = "45px";
            continue;
          }
          if (ind === items.length - 1) {
            items[i - 1].style.borderBottomRightRadius = "45px";
            continue;
          }
          items[i + 1].style.borderTopRightRadius = "45px";
          items[i - 1].style.borderBottomRightRadius = "45px";
        } else items[i].style.backgroundColor = "#89A7B1";
      }
      this.selected = name;
      this.$route.path.split("/")[1] !== name && this.$router.push({ name });
    },
  },
  mounted() {
    this.selected = this.$route.path.split("/")[1];
    const ind = this.menuItems.findIndex((item) => item.name === this.selected);
    this.setSelected(this.selected, ind);
  },
});
</script>

<style scoped>
.h-sidebar {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  margin-bottom: 20px;
  color: rgb(203, 218, 213) !important;
}
.sidebar {
  width: 250px;
  height: 100%;
  background: #89a7b1;
  backdrop-filter: blur(5px);
  transition: transform 0.3s ease; 
  z-index: 100;
  margin-top: 56px;
}

.sidebar.active {
  margin-top: 67px;
  top: 0;
  left: 0;
  right: 0;
  z-index: 100;
  transform: translateX(0);
}


.head-sidebar {
  width: 250px;
  height: 8dvh;
  position: absolute;
  top: 0;
  left: 0;
  background-color: rgba(137, 167, 177, 0.6);
  z-index: 100;
}

nav {
  background: rgb(203, 218, 213);
}

.n-item {
  width: 100%;
  background: #89a7b1;
}

.sidebar-item {
  background-color: transparent;
  transition: all 0.5s ease;
  border-radius: 8px;
  position: relative;
}

.sidebar-item:hover {
  background-color: rgba(203, 218, 213, 0.3);
  cursor: pointer;
}

.sidebar-item.selected {
  background-color: #cbdad5;
  color: #89a7b1;
  transform: translateX(8px);
}

.sidebar-item span {
  color: #cbdad5;
}

.sidebar-item.selected span {
  color: #89a7b1;
}

.sidebar-item.selected::after {
  content: "";
  position: absolute;
  right: 0;
  top: 50%;
  transform: translateY(-50%);
  width: 5px;
  height: 90%;
  background-color: #89a7b1;
  border-top-left-radius: 4px;
  border-bottom-left-radius: 4px;
}
.icon-sidebar {
  color: #cbdad5;
  margin-left: 2px;
  margin-right: 4px;
}

.sidebar-item.selected .icon-sidebar {
  color: #89a7b1;
}

@media screen and (max-width: 900px) {
  .sidebar {
    transform: translateX(-100%); 
    position: fixed;
  }

  .sidebar.active {
    transform: translateX(0); 
  }

  .head-sidebar{
    display: flex;
    justify-content: flex-start;
    align-items: center;
    background-color: transparent;
    margin-left: 20px;
  }

  @media screen and (min-width: 900px) {
    .sidebar {
      transform: translateX(0);
    }
  }
}
</style>
