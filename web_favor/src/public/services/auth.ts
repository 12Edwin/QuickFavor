import api from '@/config/http-client-gateway'
import {getErrorMessages, ResponseEntity} from "@/kernel/error-response";
import {LoginEntity} from "@/public/entity/auth.entity";

export const login = async (credentials: LoginEntity): Promise <ResponseEntity> => {
    try {
        const response = await api.doPost("/auth/login", credentials);
        localStorage.setItem("token", response.data.data.token);
        return response.data;
    } catch (error: any) {
        if (error.response.data.data !== undefined && error.response.data.data !== null) {
            return getErrorMessages(error.response.data)
        }
        return error.response.data;
    }
}