import Login from "@/views/Login.vue";
import Register from "@/views/Register.vue";
import RecoveryPassword from "@/views/RecoveryPassword.vue";
import SendCode from "@/views/SendCode.vue";
import VerifyCode from "@/views/VerifyCode.vue";

export default [
    {
        path: '',
        component: ()=> import(/* webpackChunkName "public" */"@/layouts/PublicLayout.vue"),
        meta:{
            requireAuth: false
        },
        children:[
            {
                path: 'login',
                name: 'login',
                component: Login,
                meta:{
                    title: 'Iniciar sesión'
                },
            },
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