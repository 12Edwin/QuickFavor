import {User} from 'firebase/auth';

export interface LoginRequest {
    email: string;
    password: string;
}

export interface LoginResponse {
    user: UserDetail | null;
    token?: string;
    isEmailVerified: boolean;
    error?: string;
}

interface UserDetail {
    uid: string;
    email: string;
    name: string;
    surname?: string;
    role: string;
}