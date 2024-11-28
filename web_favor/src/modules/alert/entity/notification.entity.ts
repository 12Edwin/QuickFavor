export interface NotificationEntity{
    amount: number,
    created_at: string,
    type: string,
    status: string,
    order_id: string,
}

export interface AcceptFavorEntity{
    order_id: string,
    courier_id: string,
    location: LocationEntity,
}

export interface LocationEntity{
    lat: number,
    lng: number,
}