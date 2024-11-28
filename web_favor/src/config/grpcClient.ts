import {DeliveryServiceClient} from "@/config/proto/delivery_grpc_web_pb";
import {
    DeliveryPoint, DriverLocation,
    SearchDriversRequest,
    SearchDriversResponse,
    UpdateDriverLocation
} from "@/config/proto/delivery_pb";
import type { DriverLocation as DriverLocationType } from './grpc.types';

class DeliveryService {
    private client: DeliveryServiceClient;

    constructor() {
        this.client = new DeliveryServiceClient('http://localhost:3001', null, {
            'Content-Type': 'application/grpc-web+proto',
            'X-Grpc-Web': '1'
        });
    }

    searchDrivers(
        orderNo: string,
        address: string,
        lat: number,
        lng: number,
        radius: number
    ): Promise<SearchDriversResponse> {
        return new Promise((resolve, reject) => {
            const request = new SearchDriversRequest();
            const point = new DeliveryPoint();

            point.setAddress(address);
            point.setLat(lat);
            point.setLng(lng);

            request.setNoOrder(orderNo);
            request.setDeliveryPoint(point);
            request.setSearchRadiusKm(radius);

            const stream = this.client.searchDrivers(request, {});

            stream.on('data', (response: SearchDriversResponse) => {
                resolve(response);
            });

            stream.on('error', (err: Error) => {
                reject(err);
            });
        });
    }

    updateDriverLocation(driverInfo: DriverLocationType): Promise<UpdateDriverLocation> {
        return new Promise((resolve, reject) => {
            const location = new DriverLocation();
            location.setNoCourier(driverInfo.noCourier);
            location.setLat(driverInfo.lat);
            location.setLng(driverInfo.lng);
            location.setDistanceKm(driverInfo.distanceKm);
            location.setFcmToken(driverInfo.fcmToken);

            const stream = this.client.updateDriverLocation(location, {});

            stream.on('data', (response: UpdateDriverLocation) => {
                resolve(response);
            });

            stream.on('error', (err: Error) => {
                reject(err);
            });
        });
    }
}

export const deliveryService = new DeliveryService();