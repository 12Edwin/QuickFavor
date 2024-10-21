import Profile from "@/modules/user/views/Profile.vue";
import HistoryView from "@/modules/order/views/HistoryView.vue";
import Notifications from "@/modules/alert/views/Notifications.vue";
import MapView from "@/modules/maps/views/MapView.vue";
import Order from "@/modules/order/views/Order.vue";

export default [
    {
        path: '',
        component: ()=> import(/* webpackChunkName "admin" */"@/layouts/PrivateLayout.vue"),
        meta:{
            requireAuth: true
        },
        children:[
            {
                path: 'profile',
                name: 'profile',
                component: Profile,
                meta:{
                    title: 'Perfil',
                },
            },
            {
                path: 'history',
                name: 'history',
                component: HistoryView,
                meta:{
                    title: 'Historial',
                },
            },
            {
                path: 'notifications',
                name: 'notifications',
                component: Notifications,
                meta:{
                    title: 'Notificaciones',
                },
            },
            {
                path: 'map',
                name: 'map',
                component: MapView,
                meta:{
                    title: 'Mapa',
                },
            },
            {
                path: 'order',
                name: 'order',
                component: Order,
                meta:{
                    title: 'Orden',
                },
            }
        ]
    }
]