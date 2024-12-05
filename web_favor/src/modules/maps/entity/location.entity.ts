export interface LocationUpdateEntity {
    no_courier: string,
    lat: number,
    lng: number,
}

export interface LocationSearchEntity {
    "delivery_point": DeliveryPoint,
    "no_order": string,
    "distance_km": number
}

export interface DeliveryPoint {
    "address": string,
    "lat": number,
    "lng": number
}