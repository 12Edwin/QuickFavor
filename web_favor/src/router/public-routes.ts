import Register from "@/public/views/Register.vue";
import RecoveryPassword from "@/public/views/RecoveryPassword.vue";
import SendCode from "@/public/views/SendCode.vue";
import VerifyCode from "@/public/views/VerifyCode.vue";

export default [
    {
        path: '',
        component: ()=> import(/* webpackChunkName "public" */"@/layouts/PublicLayout.vue"),
        meta:{
            requireAuth: false
        },
        children:[
            {
                path: 'register',
                name: 'register',
                component: Register,
                meta:{
                    title: 'Registrarse'
                },
            },
            {
                path: 'recovery-password',
                name: 'recovery-password',
                component: RecoveryPassword,
                meta:{
                    title: 'Recuperar contraseña'
                },
            },
            {
                path: 'send-code',
                name: 'send-code',
                component: SendCode,
                meta:{
                    title: 'Enviar código'
                }
            },
            {
                path: 'verify-code',
                name: 'verify-code',
                component: VerifyCode,
                meta:{
                    title: 'Verificar código'
                }
            }
        ]
    },

]