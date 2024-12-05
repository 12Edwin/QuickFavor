export interface LoginEntity {
    email: string
    password: string
    token?: string
}
export interface RegisterCourierEntity {
    name: string,
    surname: string,
    lastname: string | null,
    CURP: string,
    sex: string,
    phone: string,
    vehicle_type: string,
    brand: string | null,
    model: string | null,
    license_plate: string | null,
    face_photo: string | null,
    INE_photo: string | null,
    email: string,
    password: string,
}