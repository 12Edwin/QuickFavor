import {CourierRepository} from "../repository/courier.repository";
import {
    existsUserByCurpWithDifferentUid,
    existsUserByEmailWithDifferentUid, existsUserByPhoneWithDifferentUid,
    existsUserByUid
} from "../../../auth/service/boundary";
import {Courier, CourierStatus, User} from "../../../auth/interface/User";
import {getDownloadURL, ref, uploadBytes} from "firebase/storage";
import {storage} from "../../../commons/config-SDK";

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

    async editCourierProfile(uid: string, phone: string): Promise<void>{
        try{
            if(!(await existsUserByUid(uid))) throw new Error("User not found");
            if (await existsUserByPhoneWithDifferentUid(phone, uid)) throw new Error('phone already exists');
            await this.repository.editCourierProfile(uid, phone);
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

    async editVehicleCourier(id_person: string, vehicle_type: string, license_plate: string | null, plate_photo: string | null, brand: string | null, model: string | null, color: string | null, description: string | null): Promise<void>{
        try{
            if(!(await existsUserByUid(id_person))) throw new Error("User not found");

            const platePhotoUrl = plate_photo ? await this.uploadImage(plate_photo, `plate_${id_person}`) : null;

            await this.repository.editVehicleCourier(id_person, vehicle_type, license_plate, platePhotoUrl, brand, model, color, description);
        }catch (error: any) {
            throw new Error((error as Error).message)
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
}