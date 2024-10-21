import { RouteConfig} from 'vue-router'
import Vue, {CreateElement} from "vue";
import VueRouter from 'vue-router'
import publicRoutes from "@/router/public-routes";
import courierRoutes from "@/router/courier-routes";
import NotFound from "@/modules/order/views/NotFound.vue";
import Unauthorized from "@/modules/order/views/Unauthorized.vue";

Vue.use(VueRouter)

const routes: Array<RouteConfig> = [
  {
    path:'',
    redirect: '/login'
  },
  {
    path: '/',
    component: {
      render (c: CreateElement){
        return c("router-view")
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

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

export default router
