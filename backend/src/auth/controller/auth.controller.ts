import {Response200, ResponseApi} from "../../commons/TypeResponse";
import {LoginRequest, LoginResponse} from "../interface/login.type";
import {Request, Response} from "express";
import {AuthRepository} from "../repository/auth.repository";
import {AuthService} from "../service/auth.service";
import {validateError} from "../../commons/TypeError";
import {Pageable, PaginationResult} from "../../commons/Pageable";
import {UserFirebaseInterface} from "../interface/userFirebase.interface";
import {Customer, User} from "../interface/User";

const login = async (req: Request, res: Response): Promise<void> => {
    try {
        const payload = req.body as LoginRequest;
        const repository: AuthRepository = new AuthRepository();
        const service: AuthService = new AuthService(repository);
        const result: LoginResponse = await service.login(payload);

        const response: ResponseApi<LoginResponse> = Response200(result);
        res.status(response.code).json(response);

    } catch (e) {
        const error: ResponseApi<any> = validateError(e as Error);
        res.status(error.code).json(error);
    }
}

const courier_register = async (req: Request, res: Response) => {
    try {
        const { email, password, name, surname, lastname, CURP, vehicle_type, license_plate, face_photo, INE_photo, plate_photo, phone, sex } = req.body;

        const repository: AuthRepository = new AuthRepository();
        const service: AuthService = new AuthService(repository);
        const user: User = {email, password, name, surname, lastname,
            role: 'COURIER', sex, phone, CURP, vehicle_type, status: true,
            license_plate, face_photo, INE_photo, plate_photo, state: 'Out of service'
        };
        await service.courier_register(user);

        const response: ResponseApi<String> = Response200('Check your email');
        res.status(response.code).json(response);
    } catch (e) {
        const error: ResponseApi<any> = validateError(e as Error);
        res.status(error.code).json(error);
    }
}

const customer_register = async (req: Request, res: Response) => {
    try {
        const { email, password, name, surname, lastname, direction, phone, sex, CURP } = req.body;

        const repository: AuthRepository = new AuthRepository();
        const service: AuthService = new AuthService(repository);
        const user: User & Customer = {email, password, name, surname, lastname, CURP,
            role: 'CUSTOMER', sex, phone, direction, status: true,} as User & Customer;
        await service.customer_register(user);

        const response: ResponseApi<String> = Response200('Check your email');
        res.status(response.code).json(response);
    } catch (e) {
        const error: ResponseApi<any> = validateError(e as Error);
        res.status(error.code).json(error);
    }
}

const resetPassword = async (req: Request, res: Response) => {
    try {
        const { user, new_pass } = req.body;
        const repository: AuthRepository = new AuthRepository();
        const service: AuthService = new AuthService(repository);
        await service.resetPassword({uid: user.uid, new_pass});

        const response: ResponseApi<String> = Response200('Password changed');
        res.status(response.code).json(response);
    }catch (e){
        const error: ResponseApi<any> = validateError(e as Error);
        res.status(error.code).json(error);
    }
}

const recoveryPassword = async (req: Request, res: Response) => {
    try {
        const { email } = req.body;
        const repository: AuthRepository = new AuthRepository();
        const service: AuthService = new AuthService(repository);
        await service.recoveryPassword({email});

        const response: ResponseApi<String> = Response200('Check your email');
        res.status(response.code).json(response);
    }catch (e){
        const error: ResponseApi<any> = validateError(e as Error);
        res.status(error.code).json(error);
    }
}

const toggleUserAccount = async (req: Request, res: Response) => {
    try {
        const { user: {uid} } = req.body;
        const repository: AuthRepository = new AuthRepository();
        const service: AuthService = new AuthService(repository);
        await service.toggleUserAccount(uid);

        const response: ResponseApi<String> = Response200('User account toggled');
        res.status(response.code).json(response);
    } catch (e){
        const error: ResponseApi<any> = validateError(e as Error);
        res.status(error.code).json(error);
    }
}

const readUsers = async (req: Request, res: Response) => {
    try {
        const { page = 0, size = -1 } = req.query;
        const { user } = req.body;
        const repository: AuthRepository = new AuthRepository();
        const service: AuthService = new AuthService(repository);
        const pageable = new Pageable<UserFirebaseInterface>(+size, +page);
        const result = await service.readUsers(pageable, user.uid);

        const response: ResponseApi<PaginationResult<UserFirebaseInterface>> = Response200(result);
        res.status(response.code).json(response);
    }catch (e){
        const error: ResponseApi<any> = validateError(e as Error);
        res.status(error.code).json(error);
    }
}

export {
    login,
    courier_register,
    customer_register,
    resetPassword,
    recoveryPassword,
    toggleUserAccount,
    readUsers
}