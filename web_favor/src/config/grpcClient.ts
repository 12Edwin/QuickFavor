// import {ProtoLoader} from "@/config/protoLoader";
// import {DriverLocation, SearchDriversRequest, SearchDriversResponse, UpdateDriverLocation} from "@/config/grpc.types";
//
// export class GrpcClient {
//     private static instance: GrpcClient;
//     private protoLoader: ProtoLoader;
//     private baseUrl: string;
//
//     private constructor() {
//         this.protoLoader = ProtoLoader.getInstance();
//         this.baseUrl = process.env.VUE_APP_API_BASE_URL || 'localhost:50051';
//     }
//
//     public static getInstance(): GrpcClient {
//         if (!GrpcClient.instance) {
//             GrpcClient.instance = new GrpcClient();
//         }
//         return GrpcClient.instance;
//     }
//
//     // Método genérico para llamadas unarias
//     public async call<T, R>(methodName: string, request: T): Promise<R> {
//         const RequestType = this.protoLoader.getType(methodName);
//         const ResponseType = this.protoLoader.getType(methodName);
//
//         // Verificar y codificar el mensaje request
//         const errMsg = RequestType.verify(request);
//         if (errMsg) throw Error(errMsg);
//
//         const message = RequestType.create(request);
//         const buffer = RequestType.encode(message).finish();
//
//         // Realizar la llamada HTTP
//         const response = await fetch(`${this.baseUrl}/delivery.DeliveryService/${methodName}`, {
//             method: 'POST',
//             headers: {
//                 'Content-Type': 'application/grpc-web+proto',
//                 'x-grpc-web': '1',
//             },
//             body: buffer,
//         });
//
//         if (!response.ok) {
//             throw new Error(`gRPC call failed: ${response.statusText}`);
//         }
//
//         // Decodificar la respuesta
//         const responseData = await response.arrayBuffer();
//         const decodedResponse = ResponseType.decode(new Uint8Array(responseData));
//         return ResponseType.toObject(decodedResponse) as R;
//     }
//
//     // Método para streams del servidor usando WebSocket
//     public stream<T>(
//         methodName: string,
//         request: any,
//         onData: (data: T) => void,
//         onError?: (error: Error) => void
//     ): () => void {
//         const RequestType = this.protoLoader.getType(methodName + 'Request');
//         const ResponseType = this.protoLoader.getType('DriverLocation');
//
//         const ws = new WebSocket(
//             `${this.baseUrl.replace('http', 'ws')}/delivery.DeliveryService/${methodName}`
//         );
//
//         ws.binaryType = 'arraybuffer';
//
//         ws.onopen = () => {
//             const message = RequestType.create(request);
//             const buffer = RequestType.encode(message).finish();
//             ws.send(buffer);
//         };
//
//         ws.onmessage = (event) => {
//             const responseData = new Uint8Array(event.data);
//             const decodedResponse = ResponseType.decode(responseData);
//             onData(ResponseType.toObject(decodedResponse) as T);
//         };
//
//         ws.onerror = (error) => {
//             if (onError) onError(new Error('WebSocket error: ' + error));
//         };
//
//         // Retorna función para cerrar el stream
//         return () => ws.close();
//     }
// }
//
// // Servicio de delivery
// export class DeliveryService {
//     private grpcClient: GrpcClient;
//
//     constructor() {
//         this.grpcClient = GrpcClient.getInstance();
//     }
//
//     async searchDrivers(request: SearchDriversRequest): Promise<SearchDriversResponse[]> {
//         return this.grpcClient.call<SearchDriversRequest, SearchDriversResponse[]>(
//             'SearchDrivers',
//             request
//         );
//     }
//
//     async updateDriverLocation(location: DriverLocation): Promise<UpdateDriverLocation> {
//         return this.grpcClient.call<DriverLocation, UpdateDriverLocation>(
//             'updateDriverLocation',
//             location
//         );
//     }
//
//     streamDriverLocations(
//         request: SearchDriversRequest,
//         onLocation: (location: DriverLocation) => void,
//         onError?: (error: Error) => void
//     ): () => void {
//         return this.grpcClient.stream<DriverLocation>(
//             'StreamDriverLocations',
//             request,
//             onLocation,
//             onError
//         );
//     }
// }
//
// // Exportar una instancia del servicio
// export const deliveryService = new DeliveryService();