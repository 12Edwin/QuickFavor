import router from "@/router";
import axios from "axios";
import {showErrorToast} from "@/kernel/alerts";
const SERVER_URL = process.env.VUE_APP_BASE_URL;

const AxiosClient = axios.create({
    baseURL: SERVER_URL,
    timeout: 10000,
})

export const getServerUrl = () => SERVER_URL;


const setUpInterceptors = (client: any) => {
    client.interceptors.request.use(
        function(config: any){
            const auth_token = localStorage.getItem('token');
            if(auth_token !== undefined && auth_token !== null && auth_token !== ""){
                if(!config.url.includes('auth')){
                    config.headers.Authorization = `Bearer ${auth_token}`;
                }
            }
            return config;
        },
        function(error: any){
            return Promise.reject(error);
        }
    );

    client.interceptors.response.use(
        (response: any) => {
            if(response.status === 200 || response.status === 201){
                return Promise.resolve(response);
            } else {
                return Promise.reject(response);
            }
        },
        (error: any) => {
            if(!error.response){
                return Promise.reject({response: {status: 502, message: 'Error network', data: null}});
            }
            if(error.response.status){
                switch(error.response.status){
                    case 400:
                        // onToast('Campo inválido', `${utils.getErrorMessages(error.response.data.message)}`, 'warning');
                        break;
                    case 401:
                        // onToast('No autorizado', 'No tienes permisos para realizar esta acción', 'warning');
                        break;
                    case 500:
                        // onToast('Error interno', 'Error interno del servidor', 'error');
                        break;
                }
                return Promise.reject(error);
            }
            return Promise.reject(error);
        }
    );
};

setUpInterceptors(AxiosClient)

const axiosClientApi = {
    doGet(url: any){
        return AxiosClient.get(url)
    },
    doPost(url: string, data: any){
        return AxiosClient.post(url, data)
    },
    doPut(url: string, data: any){
        return AxiosClient.put(url, data)
    },
    doDelete(url: string){
        return AxiosClient.delete(url)
    },
}


export default axiosClientApi