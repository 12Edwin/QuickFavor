import {CourierRepository} from "../repository/courier.repository";
import {
    existsUserByCurpWithDifferentUid,
    existsUserByEmailWithDifferentUid, existsUserByPhoneWithDifferentUid,
    existsUserByUid
} from "../../../auth/service/boundary";
import {Courier, CourierStatus, User} from "../../../auth/interface/User";

export class CourierService{
    constructor(private repository: CourierRepository) {}

    async getCourierProfile(uid: string, currentUid: string): Promise<any>{
        try{
            if(!(await existsUserByUid(uid))) throw new Error("User not found");
            if(uid !== currentUid) throw new Error("Forbidden");
            return await this.repository.getCourierProfile(uid);
        }catch (error: any) {
            throw new Error((error as Error).message)
        }
    }

    async editCourierProfile(currentId: string, profileData: User & Courier): Promise<void>{
        try{
            if(!(await existsUserByUid(profileData.uid))) throw new Error("User not found");
            if (currentId !== profileData.uid) throw new Error("Forbidden");
            if (await existsUserByEmailWithDifferentUid(profileData.email, profileData.uid)) throw new Error('email already exists');
            if (await existsUserByPhoneWithDifferentUid(profileData.phone, profileData.uid)) throw new Error('phone already exists');
            await this.repository.editCourierProfile(currentId, profileData);
        }catch (error: any) {
            throw new Error((error as Error).message)
        }
    }

    async changeCourierStatus(uid_token: string, uid: string,  status: CourierStatus): Promise<void>{
        try{
            if(!(await existsUserByUid(uid))) throw new Error("User not found");
            if(uid_token != uid) throw new Error("Forbidden");
            await this.repository.changeCourierStatus(uid, status);
        }catch (error: any) {
            throw new Error((error as Error).message)
        }
    }
}