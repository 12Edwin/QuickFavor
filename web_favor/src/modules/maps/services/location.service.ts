import {getErrorMessages, ResponseEntity} from "@/kernel/error-response";
import api from "@/config/http-client-gateway";
import {LocationUpdateEntity} from "@/modules/maps/entity/location.entity";

export const updateLocation = async (request: LocationUpdateEntity): Promise <ResponseEntity> => {
    try {
        const response = await api.doPost("/location/new-location", request);
        return response.data;
    } catch (error: any) {
        if (error.response.data.data !== undefined && error.response.data.data !== null) {
            return getErrorMessages(error.response.data)
        }
        return error.response.data;
    }
}