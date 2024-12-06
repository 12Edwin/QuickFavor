import api from '@/config/http-client-gateway'
import {getErrorMessages, ResponseEntity} from "@/kernel/error-response";
import {LoginEntity, RegisterCourierEntity} from "@/public/entity/auth.entity";

export const login = async (credentials: LoginEntity): Promise <ResponseEntity> => {
    try {
        const fcmToken = await localStorage.getItem('firebase-token');
        if(fcmToken) credentials.token = fcmToken;
        const response = await api.doPost("/auth/login", credentials);
        localStorage.setItem("token", response.data.data.token);
        localStorage.setItem("no_user", response.data.data.user.no_user);
        localStorage.setItem("credential", response.data.data.user.uid);
        return response.data;
    } catch (error: any) {
        if (error.response.data.data !== undefined && error.response.data.data !== null && Array.isArray(error.response.data.data)) {
            return getErrorMessages(error.response.data)
        }
        return error.response.data;
    }
}


export const register = async (credentials: RegisterCourierEntity): Promise <ResponseEntity> => {
    try {
        const response = await api.doPost("/auth/courier-register", credentials);
        return response.data;
    } catch (error: any) {
        if (error.response.data.data !== undefined && error.response.data.data !== null && Array.isArray(error.response.data.data)) {
            return getErrorMessages(error.response.data)
        }
        return error.response.data;
    }
}