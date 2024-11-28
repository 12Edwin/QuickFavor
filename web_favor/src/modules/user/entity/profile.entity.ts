export interface ProfileEntity {
    uid: string;
    name: string;
    surname: string;
    lastname: string;
    email: string;
    curp: string;
    sex: string;
    role: string;
    phone: string;
    created_at: Date; 
    no_courier: string;
    fcm_token: string | null;
    rejected_orders: number;
    vehicle_type: string;
    status: string;
    license_plate: string;
    last_update: Date; 
    id_person: string;
    face_url: string;
    ine_url: string;
    plate_url: string;
    brand: string;
    model: string;
    color: string; 
  }
  