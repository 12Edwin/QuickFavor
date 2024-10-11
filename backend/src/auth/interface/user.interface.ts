export interface UserInterface {
    id?: number;
    name: string;
    surname: string;
    email: string;
    password: string;
    status?: boolean;
    role: string;
    created_at?: Date;
}