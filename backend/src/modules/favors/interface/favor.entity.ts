import {PlaceEntity} from "./place.entity";
import {ProductEntity} from "./product.entity";

export type FavorEntity = {
    no_order?: string;
    created_at?: string;
    status: FavorStatus;
    customer_direction: PlaceEntity;
    collection_points: PlaceEntity[];
    products: ProductEntity[];
    id_customer: string,
    id_courier?: string,
}

export type FavorStatus = 'Pending' | 'In shopping' | 'In delivery' | 'Finished' | 'Canceled';