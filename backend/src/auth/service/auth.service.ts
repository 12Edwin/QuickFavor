import {AuthRepository} from "../repository/auth.repository";
import {LoginRequest, LoginResponse} from "../interface/login.interface";
import {UserInterface} from "../interface/user.interface";
import {ResetInterface} from "../interface/reset.interface";
import {Pageable, PaginationResult} from "../../commons/Pageable";
import {admin} from "../../commons/config-SDK";
import {UserFirebaseInterface} from "../interface/userFirebase.interface";

export class AuthService {
    constructor(private authRepository: AuthRepository) {}

    async login(payload: LoginRequest): Promise<LoginResponse> {
        return await this.authRepository.login(payload);
    }

    async register(payload: UserInterface): Promise<boolean> {
        return await this.authRepository.register(payload);
    }

    async resetPassword(payload: ResetInterface): Promise<boolean> {
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