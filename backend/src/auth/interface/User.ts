export type User = {
    uid?: string;
    name: string;
    surname: string;
    lastname?: string;
    CURP: string;
    email: string;
    password: string;
    phone: string;
    status?: boolean;
    role: Role;
    sex: Sex;
    created_at?: Date;
} & (Courier | Customer);

export type Courier = {
    no_courier?: number;
    vehicle_type: VehicleType;
    state: CourierStatus;
    license_plate: string;
    face_photo: string;
    INE_photo: string;
    plate_photo?: string;
}

export type Customer = {
    no_customer?: number;
}

export type Role = 'COURIER' | 'CUSTOMER';
export type VehicleType = 'Carro' | 'Moto' | 'Bicicleta' |  'Scouter' | 'Caminando' | 'Otro'
export type CourierStatus = 'Available' | 'Busy' | 'Out of service'
export type Sex = 'Masculino' | 'Femenino'