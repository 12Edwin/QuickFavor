// src/types/delivery.ts
export interface DeliveryPoint {
    address: string;
    lat: number;
    lng: number;
}

export interface Driver {
    noCourier: string;
    courierName: string;
    lat: number;
    lng: number;
    status: string;
}

export interface DriverLocation {
    noCourier: string;
    lat: number;
    lng: number;
    distanceKm: number;
    fcmToken: string;
}

export interface SearchForm {
    orderNo: string;
    address: string;
    lat: number;
    lng: number;
    radius: number;
}