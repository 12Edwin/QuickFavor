export interface SearchDriversRequest {
    no_order: string;
    delivery_point: {
        address: string;
        lat: number;
        lng: number;
    };
}

export interface SearchDriversResponse {
    no_courier: string;
    courier_name: string;
    lat: number;
    lng: number;
    status: string;
}

export interface DriverLocation {
    no_courier: string;
    lat: number;
    lng: number;
    distance_km: number;
    fcm_token?: string;
}

export interface UpdateDriverLocation {
    success: boolean;
    status: string;
}