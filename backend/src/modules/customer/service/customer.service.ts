import {CustomerRepository} from "../repository/customer.repository";
import {
    existsUserByEmailWithDifferentUid,
    existsUserByPhoneWithDifferentUid,
    existsUserByUid
} from "../../../auth/service/boundary";
import {Customer, User} from "../../../auth/interface/User";

export class CustomerService{
    private repository;
    constructor(repository: CustomerRepository) {
        this.repository = repository;
    }

    async getCustomerProfile(uid: string, currentId: string){
        try {
            if (! await existsUserByUid(uid)) throw new Error('User not found');
            if (uid != currentId) throw  new Error('Forbidden');
            return await this.repository.getCustomerProfile(uid);
        }catch (error: any){
            throw new Error((error as Error).message);
        }
    }

    async editCustomerProfile(currentId: string, payload: User & Customer){
        try {
            if (! await existsUserByUid(payload.uid)) throw new Error('User not found');
            if (payload.uid != currentId) throw  new Error('Forbidden');
            if (await existsUserByEmailWithDifferentUid(payload.email, payload.uid)) throw new Error('email already exists')
            if (await existsUserByPhoneWithDifferentUid(payload.phone, payload.uid)) throw new Error('phone already exists')
            return await this.repository.editCustomerProfile(payload);
        }catch (error: any){
            throw new Error((error as Error).message)
        }
    }
}