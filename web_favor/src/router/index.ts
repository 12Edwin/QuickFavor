import {createRouter, createWebHistory} from 'vue-router'
import {h, resolveComponent} from 'vue';
import publicRoutes from "@/router/public-routes";
import courierRoutes from "@/router/courier-routes";
import NotFound from "@/modules/order/views/NotFound.vue";
import Unauthorized from "@/modules/order/views/Unauthorized.vue";

const routes= [
  {
    path:'',
    redirect: '/login'
  },
  {
    path: '/',
    component: {
      render () {
        return h(resolveComponent("router-view"))
      }
    },
    children:[
      ...publicRoutes.map(route => {
        route.meta.requireAuth = false
        return {...route}
      }),
      ...courierRoutes.map(route => {
        route.meta.requireAuth = true
        return {...route}
      })
    ]
  },
  {
    path: '/*',
    name: '404',
    component: NotFound
  },
  {
    name: "unautorized",
    path: "/unautorized",
    component: Unauthorized
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
