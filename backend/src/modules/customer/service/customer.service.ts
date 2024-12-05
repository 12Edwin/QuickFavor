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

    async editCustomerProfile(currentId: string, phone: string, lat: string, lng: string){
        try {
            if (! await existsUserByUid(currentId)) throw new Error('User not found');
            if (await existsUserByPhoneWithDifferentUid(phone, currentId)) throw new Error('phone already exists')
            return await this.repository.editCustomerProfile(currentId, phone, lat, lng);
        }catch (error: any){
            throw new Error((error as Error).message)
        }
    }
}