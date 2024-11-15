import {Request, Response} from "express";
import {validateError} from "../../../commons/TypeError";
import {Response200, ResponseApi} from "../../../commons/TypeResponse";
import {CustomerRepository} from "../repository/customer.repository";
import {CustomerService} from "../service/customer.service";
import {Customer, User} from "../../../auth/interface/User";

const getCustomerProfile = async (req: Request, res: Response) =>{
    try {
        const { user } = req.body;
        const currentUid = user.uid;
        const repository: CustomerRepository = new CustomerRepository();
        const service: CustomerService = new CustomerService(repository);
        const { uid } = req.params;
        const profile: Customer & User = await service.getCustomerProfile(uid, currentUid);

        const response: ResponseApi<Customer & User> = Response200(profile);
        res.status(response.code).json(response);
    }catch (error: any){
        const e: ResponseApi<any> = validateError(error as Error)
        res.status(e.code).json(e)
    }
}

const editCustomerProfile = async (req: Request, res: Response) =>{
    try {
        const { user } = req.body;
        const currentUid = user.uid;
        const repository: CustomerRepository = new CustomerRepository();
        const service: CustomerService = new CustomerService(repository);
        const payload: User & Customer = req.body;
        const response: ResponseApi<any> = Response200(await service.editCustomerProfile(currentUid, payload));
        res.status(response.code).json(response);
    }catch (error: any){
        const e: ResponseApi<any> = validateError(error as Error)
        res.status(e.code).json(e)
    }
}

export {
    getCustomerProfile,
    editCustomerProfile
}