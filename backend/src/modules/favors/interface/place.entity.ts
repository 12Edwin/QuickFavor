import {LocationEntity} from "../../../grpc/entity/location.entity";

export type PlaceEntity = {
    id?: number;
    name: string;
    type: PlaceType;
    created_at: string;
    id_order?: string;
    id_customer?: string;
    id_courier?: string;
} & LocationEntity

export type PlaceType = 'Home' | 'Collection' | 'Courier';