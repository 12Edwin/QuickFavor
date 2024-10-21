<template>
  <div class="sidebar pe-0 ps-0 text-white p-3">
    <div class="h-sidebar">
      <img src="@/assets/logo.png" height="100">
      <h4 class=" mt-2">Quick Favor</h4>
    </div>
    <nav class="w-100 p-0">
      <div class="n-item w-100 p-0"
        v-for="(item, ind) in menuItems"
        @click="setSelected(item.name, ind)"
        :key="item.name">
        <div
            :class="[
            'sidebar-item d-flex align-items-center w-100 border-0 p-4',
            { 'selected': selected === item.name }
          ]"
        >
          <component :is="item.icon" class="me-2" />
          <span>{{ item.text }}</span>
        </div>
      </div>
    </nav>
  </div>
</template>

<script lang="ts">
import {defineComponent, ref} from "vue";

export default defineComponent ({
  name: 'SideBar',
  data() {
    return {
      selected: '',
      menuItems: [
        {name: 'map', text: 'Mapa'},
        {name: 'order', text:'Favor' },
        {name: 'notifications', text: 'Notificaciones'},
        {name: 'history', text: 'Historial'},
        {name: 'profile', text: 'Perfil'},
      ],
    }
  },
  methods: {
    setSelected(name: string, ind: number) {
      const items = document.getElementsByClassName('n-item') as HTMLCollectionOf<HTMLElement>;
      for (let i = 0; i < items.length; i++) {
        items[i].style.borderRadius = '0';
      }

      for (let i = 0; i < items.length; i++) {
        if (i === ind) {
          items[ind].style.backgroundColor = 'rgb(203, 218, 213)';
          if (ind === 0) {
            items[i + 1].style.borderTopRightRadius = '45px';
            continue;
          }
          if (ind === items.length - 1) {
            items[i - 1].style.borderBottomRightRadius = '45px';
            continue;
          }
          items[i + 1].style.borderTopRightRadius = '45px';
          items[i - 1].style.borderBottomRightRadius = '45px';
        }
        else
          items[i].style.backgroundColor = '#2c3e50';
      }
      this.selected = name;
      this.$route.path.split('/')[1] !== name && this.$router.push({name});
    }
  },
  mounted() {
    this.selected = this.$route.path.split('/')[1];
    const ind = this.menuItems.findIndex(item => item.name === this.selected);
    this.setSelected(this.selected, ind);
  },
})
</script>

<style scoped>

.h-sidebar{
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  margin-bottom: 20px;
  color: rgb(203, 218, 213) !important;
}
.sidebar {
  width: 250px;
  height: 100vh;
  background: #2c3e50;
  position: relative;
  backdrop-filter: blur(5px);
}

nav{
  background: rgb(203, 218, 213);
}

.n-item {
  width: 100%;
  background: #2c3e50;
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
  background-color: #CBDAD5;
  color: #2c3e50;
  transform: translateX(8px);
}

.sidebar-item span{
  color: #CBDAD5;
}

.sidebar-item.selected span{
  color: #2c3e50;
}

.sidebar-item.selected::after {
  content: '';
  position: absolute;
  right: 0;
  top: 50%;
  transform: translateY(-50%);
  width: 5px;
  height: 90%;
  background-color: #2c3e50;
  border-top-left-radius: 4px;
  border-bottom-left-radius: 4px;
}
</style>