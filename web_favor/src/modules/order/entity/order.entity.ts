export interface OrderPreviewEntity {
    no_order: string;
    order_created_at: string;
    status: string;
    receipt_url?: string;
    cost?: number;
    no_customer: string;
    customer_name: string;
    customer_surname: string;
    customer_lastname: string;
    customer_email: string;
    customer_phone: string;
    no_courier?: string;
    license_plate?: string;
    vehicle_type?: string;
    model?: string;
    color?: string;
    plate_url?: string;
    face_url?: string;
    rejected_orders?: number;
    courier_status?: string;
    courier_name?: string;
    courier_surname?: string;
    courier_lastname?: string;
    courier_email?: string;
    courier_phone?: string;
    place_name: string;
    place_lat: number;
    place_lng: number;
    deliveryPoints: Delivery[];
    products: Prod[];
}

export interface Delivery {
    name: string;
    lat: number;
    lng: number;
    isClosed?: boolean;
}

export interface Prod {
    name: string;
    description: string;
    amount: number;
}

export interface OrderStatus {
    status: string;
    order_created_at: string;
}

export interface SSEOrderMessage{
    code: number;
    error: boolean;
    message: string;
    data: OrderStatus;
}

export interface UpdateStateOrderEntity {
    no_order: string;
    newStatus: string;
    cost?: number;
    receipt?: string;
}