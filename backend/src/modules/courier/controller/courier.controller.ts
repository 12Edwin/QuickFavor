import { Request, Response } from 'express';
import { CourierRepository } from '../repository/courier.repository';
import { CourierService } from '../service/courier.service';
import {Courier} from "../../../auth/interface/User";
import {Response200, ResponseApi} from "../../../commons/TypeResponse";
import {validateError} from "../../../commons/TypeError";

const getCourierProfile = async (req: Request, res: Response): Promise<void> => {
    try {
        const { user } = req.body;
        const currentUid = user.uid;
        const repository: CourierRepository = new CourierRepository();
        const service: CourierService = new CourierService(repository);
        const { uid } = req.params;
        const profile: Courier = await service.getCourierProfile(uid, currentUid);

        const response: ResponseApi<Courier> = Response200(profile);
        res.status(response.code).json(response);
    } catch (e) {
        const error: ResponseApi<any> = validateError(e as Error);
        res.status(error.code).json(error);
    }
};

const editCourierProfile = async (req: Request, res: Response): Promise<void> => {
    try {
        const { user, ...profileData } = req.body;
        const repository: CourierRepository = new CourierRepository();
        const service: CourierService = new CourierService(repository);
        await service.editCourierProfile(user.uid, profileData);

        const response: ResponseApi<string> = Response200('Profile updated successfully');
        res.status(response.code).json(response);
    } catch (e) {
        const error: ResponseApi<any> = validateError(e as Error);
        res.status(error.code).json(error);
    }
};

const changeCourierStatus = async (req: Request, res: Response): Promise<void> => {
    try {
        const { user, status } = req.body;
        const { uid } = req.params;
        const repository: CourierRepository = new CourierRepository();
        const service: CourierService = new CourierService(repository);
        await service.changeCourierStatus(user.uid, uid, status);

        const response: ResponseApi<string> = Response200('Status updated successfully');
        res.status(response.code).json(response);
    } catch (e) {
        const error: ResponseApi<any> = validateError(e as Error);
        res.status(error.code).json(error);
    }
};

export {
    getCourierProfile,
    editCourierProfile,
    changeCourierStatus
};