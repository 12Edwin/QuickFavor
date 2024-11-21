import {AuthRepository} from "../repository/auth.repository";
import {LoginRequest, LoginResponse} from "../interface/login.type";
import {Reset} from "../interface/Reset";
import {Pageable, PaginationResult} from "../../commons/Pageable";
import {UserFirebaseInterface} from "../interface/userFirebase.interface";
import {Courier, Customer, User} from "../interface/User";

export class AuthService {
    constructor(private authRepository: AuthRepository) {}

    async login(payload: LoginRequest): Promise<LoginResponse> {
        try{
            return await this.authRepository.login(payload);
        }catch (error: any) {
            throw new Error((error as Error).message)
        }
    }

    async courier_register(payload: User & Courier): Promise<boolean> {
        try{
            if (await this.authRepository.existsUserByEmail(payload.email)) throw new Error('email already exists');
            if (await this.authRepository.existsUserByCurp(payload.CURP)) throw new Error('CURP already exists');
            if (await this.authRepository.existsUserByPhone(payload.phone)) throw new Error('phone already exists');
            return await this.authRepository.courier_register(payload);
        }catch (error: any) {
            throw new Error((error as Error).message)
        }
    }

    async customer_register(payload: User & Customer): Promise<boolean> {
        try {
            if (await this.authRepository.existsUserByEmail(payload.email)) throw new Error('email already exists');
            if (await this.authRepository.existsUserByPhone(payload.phone)) throw new Error('phone already exists');
            if (await this.authRepository.existsUserByCurp(payload.CURP)) throw new Error('curp already exists');
            return await this.authRepository.customer_register(payload);
        }catch (error: any) {
            throw new Error((error as Error).message)
        }
    }

    async resetPassword(payload: Reset): Promise<boolean> {
        return await this.authRepository.resetPassword(payload);
    }

    async recoveryPassword(payload: {email: string}): Promise<boolean> {
        return await this.authRepository.recoveryPassword(payload);
    }

    async toggleUserAccount(payload: string ): Promise<boolean> {
        if (await this.authRepository.existsUserByUid(payload)) {
            throw new Error('User not found');
        }
        return await this.authRepository.toggleUserAccount(payload);
    }

    async readUsers(payload: Pageable<UserFirebaseInterface>, uid: string = ''): Promise <PaginationResult<UserFirebaseInterface>> {
        return await this.authRepository.getPaginatedUsers(payload);
    }
}