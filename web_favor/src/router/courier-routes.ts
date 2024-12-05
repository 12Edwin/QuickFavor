import Profile from "@/modules/user/views/Profile.vue";
import HistoryView from "@/modules/order/views/HistoryView.vue";
import Notifications from "@/modules/alert/views/Notifications.vue";
import MapView from "@/modules/maps/views/MapView.vue";
import Order from "@/modules/order/views/Order.vue";
import HistoryDetailsView from "@/modules/order/views/HistoryDetailsView.vue";

export default [
  {
    path: "",
    component: () =>
      import(/* webpackChunkName "admin" */ "@/layouts/PrivateLayout.vue"),
    meta: {
      requireAuth: true,
      role: 'Courier'
    },
    children: [
      {
        path: "profile",
        name: "profile",
        component: Profile,
        meta: {
          title: "Perfil",
          role: 'Courier'
        },
      },
      {
        path: "history",
        name: "history",
        component: HistoryView,
        meta: {
          title: "Historial",
          role: 'Courier'
        },
      },
      {
        path: "notifications",
        name: "notifications",
        component: Notifications,
        meta: {
          title: "Notificaciones",
          role: 'Courier'
        },
      },
      {
        path: "map",
        name: "map",
        component: MapView,
        meta: {
          title: "Mapa",
          role: 'Courier'
        },
      },
      {
        path: "order",
        name: "order",
        component: Order,
        meta: {
          title: "Orden",
          role: 'Courier'
        },
      },
      {
        path: "history-details/:id",
        name: "historyDetails",
        component: HistoryDetailsView,
        meta: {
          title: "History Details",
          role: 'Courier'
        },
        props: true,
      },
    ],
  },
];
