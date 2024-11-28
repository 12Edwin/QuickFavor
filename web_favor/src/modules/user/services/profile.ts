import api from '@/config/http-client-gateway'
import { getErrorMessages, ResponseEntity } from "@/kernel/error-response";
import { ProfileEntity } from "@/modules/user/entity/profile.entity";

// Cache expiration time in milliseconds (10 minutes)
const CACHE_EXPIRATION_TIME = 10 * 60 * 1000;

export const getProfile = async (): Promise<ResponseEntity> => {
    const credential = localStorage.getItem("credential");;

    if (!credential) {
        return { error: true, message: 'No credential found in localStorage', code: 401, data: null };
    }

    try {
        const response = await api.doGet("/courier/profile/" + credential);
        if (response?.data?.data) {
            const cacheData = {
                data: response.data,
                timestamp: new Date().getTime(), 
            };
            localStorage.setItem(credential, JSON.stringify(cacheData));  
        }

        return response.data;
    } catch (error: any) {
        const cachedData = localStorage.getItem(credential);
        
        if (cachedData) {
            const { data, timestamp } = JSON.parse(cachedData);
            
            const isCacheValid = new Date().getTime() - timestamp < CACHE_EXPIRATION_TIME;

            if (isCacheValid) {
                return data;
            } else {
                return { error: true, message: 'Cache expired and no internet connection', code: 500, data: null };
            }
        }

        if (error.response && error.response.data.data !== undefined && error.response.data.data !== null) {
            return getErrorMessages(error.response.data);
        }

        return error.response?.data || { error: 'Unknown error' };
    }
};
