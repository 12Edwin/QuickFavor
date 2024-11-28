import {AuthRepository} from "../repository/auth.repository";
import {LoginRequest, LoginResponse} from "../interface/login.type";
import {Reset} from "../interface/Reset";
import {Pageable, PaginationResult} from "../../commons/Pageable";
import {UserFirebaseInterface} from "../interface/userFirebase.interface";
import {Courier, Customer, User} from "../interface/User";
import {getDownloadURL, ref, uploadBytes} from "firebase/storage";
import {storage} from "../../commons/config-SDK";

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
        try {
            if (await this.authRepository.existsUserByEmail(payload.email)) throw new Error('email already exists');
            if (await this.authRepository.existsUserByCurp(payload.CURP)) throw new Error('CURP already exists');
            if (await this.authRepository.existsUserByPhone(payload.phone)) throw new Error('phone already exists');

            const uid = await this.authRepository.courier_register(payload);
            // Upload images to Firebase Storage
            const facePhotoUrl = await this.uploadImage(payload.face_photo, `face_${uid}`);
            const INEPhotoUrl = await this.uploadImage(payload.INE_photo, `ine_${uid}`);
            const platePhotoUrl = payload.plate_photo ? await this.uploadImage(payload.plate_photo, `plate_${uid}`) : null;

            // Update payload with image URLs
            payload.face_photo = facePhotoUrl;
            payload.INE_photo = INEPhotoUrl;
            if (platePhotoUrl) payload.plate_photo = platePhotoUrl;

            return await this.authRepository.updateUrlImages(uid, payload)
        } catch (error: any) {
            throw new Error((error as Error).message);
        }
    }

    async uploadImage(base64Image: string, imageName: string): Promise<string> {
        const buffer = Buffer.from(base64Image, 'base64');

        const storageRef = ref(storage, `images/${imageName}`);
        await uploadBytes(storageRef, buffer, {
            contentType: 'image/jpeg'
        });

        return await getDownloadURL(storageRef);
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