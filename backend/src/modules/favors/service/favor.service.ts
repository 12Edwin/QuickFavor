import {FavorRepository} from "../repository/favor.repository";
import {FavorEntity} from "../interface/favor.entity";
import {existsCustomerById, toggleUserAccount} from "../../../auth/service/boundary";
import {LocationEntity} from "../../../grpc/entity/location.entity";

export class FavorService{

    constructor(private favorRepository: FavorRepository){}

    async createFavor(payload: FavorEntity): Promise<boolean> {
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
            return this.favorRepository.updateFavorStatus(id, newStatus, cost, receipt);
        }catch (error: any){
            throw new Error((error as Error).message)
        }
    }

    async acceptFavor(no_order: string, location: LocationEntity, no_courier: string): Promise<boolean> {
        try{
            if (!await this.favorRepository.existsFavorByNo_order(no_order)) throw new Error('Favor not found');
            if (!await this.favorRepository.isCourierAvailable(no_courier)) throw new Error('Courier not available');
            if (!await this.favorRepository.isCourierNearLocation(no_courier, location)) throw new Error('Courier not near location');
            if (!await this.favorRepository.thereIsTimeToAccept(no_order)) throw new Error('Time to accept is over');
            return this.favorRepository.acceptFavor(no_order, no_courier);
        }catch (error: any){
            throw new Error((error as Error).message)
        }
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

}