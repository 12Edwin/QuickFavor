import {User} from 'firebase/auth';

export type LoginRequest = {
    email: string;
    password: string;
}

export type LoginResponse = {
    user: UserDetail | null;
    token?: string;
    isEmailVerified: boolean;
    error?: string;
}

type UserDetail  ={
    uid: string;
    email: string;
    name: string;
    surname?: string;
    role: string;
}