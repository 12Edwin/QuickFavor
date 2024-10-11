import {Response200, ResponseApi} from "../../commons/TypeResponse";
import {LoginRequest, LoginResponse} from "../interface/login.interface";
import {Request, Response} from "express";
import {AuthRepository} from "../repository/auth.repository";
import {AuthService} from "../service/auth.service";
import {validateError} from "../../commons/TypeError";
import {Pageable, PaginationResult} from "../../commons/Pageable";
import {UserFirebaseInterface} from "../interface/userFirebase.interface";

const login = async (req: Request, res: Response) => {
    try {
        const payload = req.body as LoginRequest;
        const repository: AuthRepository = new AuthRepository();
        const service: AuthService = new AuthService(repository);
        const result: LoginResponse = await service.login(payload);

        const response: ResponseApi<LoginResponse> = Response200(result);
        return res.status(response.code).json(response);

    } catch (e) {
        const error: ResponseApi<any> = validateError(e as Error);
        return res.status(error.code).json(error);
    }
}

const register = async (req: Request, res: Response) => {
    try {
        const { email, password, name, surname } = req.body;

        const repository: AuthRepository = new AuthRepository();
        const service: AuthService = new AuthService(repository);
        await service.register({email, password, name, surname, role: 'user'});

        const response: ResponseApi<String> = Response200('Check your email');
        return res.status(response.code).json(response);
    }catch (e){
        const error: ResponseApi<any> = validateError(e as Error);
        return res.status(error.code).json(error);
    }
}

const resetPassword = async (req: Request, res: Response) => {
    try {
        const { user, new_pass } = req.body;
        const repository: AuthRepository = new AuthRepository();
        const service: AuthService = new AuthService(repository);
        await service.resetPassword({uid: user.uid, new_pass});

        const response: ResponseApi<String> = Response200('Password changed');
        return res.status(response.code).json(response);
    }catch (e){
        const error: ResponseApi<any> = validateError(e as Error);
        return res.status(error.code).json(error);
    }
}

const recoveryPassword = async (req: Request, res: Response) => {
    try {
        const { email } = req.body;
        const repository: AuthRepository = new AuthRepository();
        const service: AuthService = new AuthService(repository);
        await service.recoveryPassword({email});

        const response: ResponseApi<String> = Response200('Check your email');
        return res.status(response.code).json(response);
    }catch (e){
        const error: ResponseApi<any> = validateError(e as Error);
        return res.status(error.code).json(error);
    }
}

const toggleUserAccount = async (req: Request, res: Response) => {
    try {
        const { user: {uid} } = req.body;
        const repository: AuthRepository = new AuthRepository();
        const service: AuthService = new AuthService(repository);
        await service.toggleUserAccount(uid);

        const response: ResponseApi<String> = Response200('User account toggled');
        return res.status(response.code).json(response);
    } catch (e){
        const error: ResponseApi<any> = validateError(e as Error);
        return res.status(error.code).json(error);
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
        return res.status(response.code).json(response);
    }catch (e){
        const error: ResponseApi<any> = validateError(e as Error);
        return res.status(error.code).json(error);
    }
}

export {
    login,
    register,
    resetPassword,
    recoveryPassword,
    toggleUserAccount,
    readUsers
}