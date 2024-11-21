import {
  createRouter,
  createWebHistory,
  NavigationGuardNext,
  RouteLocationNormalized,
  RouteLocationNormalizedLoaded
} from 'vue-router'
import {h, resolveComponent} from 'vue';
import publicRoutes from "@/router/public-routes";
import courierRoutes from "@/router/courier-routes";
import NotFound from "@/modules/order/views/NotFound.vue";
import Unauthorized from "@/modules/order/views/Unauthorized.vue";
import Component from 'vue-class-component';
import {getRoleNameByToken, getToken} from "@/kernel/utils";

const routes= [
  {
    path:'',
    redirect: '/login',
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
    path: '/login',
    name: 'login',
    component: ()=> import('@/public/views/Login.vue'),
  },
  {
    path: '/:pathMatch(.*)*',
    name: 'not-found',
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

router.beforeEach(async (to: RouteLocationNormalized, from: RouteLocationNormalizedLoaded, next: NavigationGuardNext) => {
  const publicRoutes = ["/login", "/register", "/unautorized"];
  const authRequired = !publicRoutes.includes(to.path);
  const loggedIn = getToken();

  if (authRequired && !loggedIn) {
    return next("/login");
  }
  if (loggedIn) {
    const role = await getRoleNameByToken();

    if (role) {
      if (to.meta && to.meta.role && (to.meta.role as any).toString().toLowerCase() !== role.toString().toLowerCase()) {
        return next("/unautorized");
      }
    } else {
      return next("/login");
    }
    next();
  }
  if (loggedIn && to.path.toString().toLowerCase() === "/login") {
    return next("/map");
  }
  next();
});

export default router
