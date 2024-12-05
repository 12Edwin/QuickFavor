import {FavorRepository} from "../repository/favor.repository";
import {FavorEntity} from "../interface/favor.entity";
import {existsCourierById, existsCustomerById, toggleUserAccount} from "../../../auth/service/boundary";
import {LocationEntity} from "../../../grpc/entity/location.entity";
import {getDownloadURL, ref, uploadBytes} from "firebase/storage";
import {db, storage} from "../../../commons/config-SDK";

export class FavorService{

    constructor(private favorRepository: FavorRepository){}

    async createFavor(payload: FavorEntity): Promise<string> {
        try {
            if (payload.collection_points.length > 3 || payload.products.length <= 0) throw new Error('Invalid fields');
            if (payload.products.length > 15 || payload.products.length <= 0) throw new Error('Invalid fields');
            if (!await existsCustomerById(payload.id_customer)) throw new Error('Customer not found');
            return this.favorRepository.createFavor(payload);
        }catch (error: any){
            throw new Error((error as Error).message)
        }
    }

    async getFavorStatus(id: string): Promise<Map<string, any>> {
        try{
            if (!await this.favorRepository.existsFavorByNo_order(id)) throw new Error('Favor not found');
            if (!await this.favorRepository.thereIsTimeToFinish(id)){
                await this.favorRepository.updateFavorStatus(id, 'Canceled');
            }
            return this.favorRepository.getFavorStatus(id);
        }catch (error: any){
            throw new Error((error as Error).message)
        }

    }

    async updateFavorStatus_courier(id: string, current_uid: string, newStatus: string, cost: number | null = null, receipt: string | null = null): Promise<boolean> {
        try{
            if (!await this.favorRepository.isCourierOwner(id, current_uid)) throw new Error('Forbidden');
            if (!await this.favorRepository.existsFavorByNo_order(id)) throw new Error('Favor not found');
            if (newStatus === 'Finished' && (cost === null || receipt === null)) throw new Error('Invalid fields');
            if (newStatus === 'Finished' && !await this.favorRepository.thereIsTimeToFinish(id)) throw new Error('Time to finish is over');

            let receiptPhotoUrl = null;
            if (newStatus === 'Finished' && receipt) {
                receiptPhotoUrl = await this.uploadImage(receipt, `receipt_${id}`);
            }
            return this.favorRepository.updateFavorStatus(id, newStatus, cost, receiptPhotoUrl);
        }catch (error: any){
            throw new Error((error as Error).message)
        }
    }

    async getDetailsFavor(no_order: string): Promise<Map<string, any>> {
        try{
            if (!await this.favorRepository.existsFavorByNo_order(no_order)) throw new Error('Favor not found');
            return this.favorRepository.getDetailsFavor(no_order);
        }catch (error: any){
            throw new Error((error as Error).message)
        }
    }

    async acceptFavor(no_order: string, location: LocationEntity, no_courier: string): Promise<boolean> {
        try{
            if (!await this.favorRepository.existsFavorByNo_order(no_order)) throw new Error('Favor not found');
            if (!await this.favorRepository.isCourierAvailable(no_courier)) throw new Error('Courier not available');
            if (!await this.favorRepository.isCourierNearLocation(no_courier, location)) throw new Error('Courier not near location');
            if (!await this.favorRepository.hasNotBeenAccepted(no_order)) throw new Error('Favor already accepted');
            if (!await this.favorRepository.thereIsTimeToAccept(no_order)) throw new Error('Time to accept is over');

            await this.favorRepository.acceptFavor(no_order, no_courier);
            await this.createChatDocument(no_order);
            return true;
        }catch (error: any){
            throw new Error((error as Error).message)
        }
    }

    async createChatDocument (id: string): Promise<void> {
      try {
        const chatRef = db.collection('chats').doc(id);
        await chatRef.set({
          available: true,
          messages: []
        });
        console.log(`Document with ID ${id} created successfully.`);
      } catch (error) {
        console.error('Error creating document:', error);
        throw new Error('Error creating document');
      }
    };

    async uploadImage(base64Image: string, imageName: string): Promise<string> {
        const buffer = Buffer.from(base64Image, 'base64');

        const storageRef = ref(storage, `images/${imageName}`);
        await uploadBytes(storageRef, buffer, {
            contentType: 'image/jpeg'
        });

        return await getDownloadURL(storageRef);
    }

    async cancelFavor(no_order: string, current_uid: string): Promise<boolean> {
        try{
            if (!await this.favorRepository.existsFavorByNo_order(no_order)) throw new Error('Favor not found');
            if (!await this.favorRepository.isCourierOwner(no_order, current_uid)) throw new Error('Forbidden');
            const status = await this.favorRepository.findCourierStatus(no_order);
            if (status.get('rejected_orders') >= 2) {
                await toggleUserAccount(status.get('id_person'));
            }
            return this.favorRepository.cancelFavor(no_order);
        }catch (error: any){
            throw new Error((error as Error).message)
        }
    }

    async rejectFavor(no_order: string, courier_id: string): Promise<boolean> {
        try{
            if (!await this.favorRepository.existsFavorByNo_order(no_order)) throw new Error('Favor not found');
            return this.favorRepository.rejectFavor(no_order, courier_id);
        }catch (error: any){
            throw new Error((error as Error).message)
        }
    }

    async readNotifications(no_courier: string): Promise<any> {
        try{
            if (!await existsCourierById(no_courier)) throw new Error('Courier not found');
            return this.favorRepository.readNotifications(no_courier);
        }catch (error: any) {
            throw new Error((error as Error).message)
        }
    }

    async readCourierHistory(no_courier: string): Promise<any> {
        try{
            if (!await existsCourierById(no_courier)) throw new Error('Courier not found');
            return this.favorRepository.readCourierHistory(no_courier);
        }catch (error: any) {
            throw new Error((error as Error).message)
        }
    }

    async readCustomerHistory(no_customer: string): Promise<any> {
        try{
            if (!await existsCustomerById(no_customer)) throw new Error('Customer not found');
            return this.favorRepository.readCustomerHistory(no_customer);
        }catch (error: any) {
            throw new Error((error as Error).message)
        }
    }

}