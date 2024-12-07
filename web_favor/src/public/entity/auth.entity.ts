export interface LoginEntity {
    email: string
    password: string
    token?: string
}
export interface RegisterCourierEntity {
    name: string,
    surname: string,
    lastname: string | undefined,
    CURP: string,
    sex: string,
    phone: string,
    vehicle_type: string,
    brand: string | undefined,
    model: string | undefined,
    color: string | undefined,
    desciption: string | undefined,
    license_plate: string | undefined,
    face_photo: string | undefined,
    INE_photo: string | undefined,
    plate_photo: string | undefined,
    email: string,
    password: string,
}