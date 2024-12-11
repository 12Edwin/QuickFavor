import {createApp} from 'vue'
import App from './App.vue'
import router from "@/router";
import './registerServiceWorker'
import Vue3Toastify, {ToastContainerOptions} from "vue3-toastify";
import 'vuetify/styles'
import { createVuetify } from 'vuetify'
import * as components from 'vuetify/components'
import * as directives from 'vuetify/directives'
import './registerServiceWorker'


const vuetify = createVuetify({
        components,
        directives,
})

createApp(App)
    .use(vuetify)
    .use(Vue3Toastify, {
        position: 'top-right',
    }as ToastContainerOptions)
    .use(router)
    .mount('#app')
