// import { RpcTransport, RpcOptions, MethodInfo, UnaryCall, ServerStreamingCall, ClientStreamingCall, DuplexStreamingCall } from "@protobuf-ts/runtime-rpc";
// import { GrpcWebFetchTransport } from "@protobuf-ts/grpcweb-transport";
// import {
//     DriverLocation,
//     SearchDriversRequest,
//     SearchDriversResponse,
//     UpdateDriverLocation
// } from "@/config/proto/delivery";
// import {DeliveryServiceClient} from "@/config/proto/delivery.client";
//
// class MyRpcTransport implements RpcTransport {
//     private transport: GrpcWebFetchTransport;
//
//     constructor(serverUrl: string) {
//         if (!serverUrl) {
//             throw new Error("Invalid server URL");
//         }
//
//         // Asegurar que la URL base esté correctamente formateada
//         const normalizedUrl = serverUrl.endsWith('/') ? serverUrl : `${serverUrl}/`;
//
//         this.transport = new GrpcWebFetchTransport({
//             baseUrl: normalizedUrl,
//             format: 'binary',
//             timeout: 30000,
//         });
//     }
//
//     mergeOptions(options?: Partial<RpcOptions>): RpcOptions {
//         const defaultOptions: RpcOptions = {
//             timeout: 30000,
//             jsonOptions: {},
//             binaryOptions: {},
//             headers: {
//                 'Content-Type': 'application/grpc-web+proto'
//             }
//         };
//         return { ...defaultOptions, ...options };
//     }
//
//     unary<I extends object, O extends object>(
//         method: MethodInfo<I, O>,
//         input: I,
//         options: RpcOptions
//     ): UnaryCall<I, O> {
//         return this.transport.unary(method, input, options);
//     }
//
//     serverStreaming<I extends object, O extends object>(
//         method: MethodInfo<I, O>,
//         input: I,
//         options: RpcOptions
//     ): ServerStreamingCall<I, O> {
//         return this.transport.serverStreaming(method, input, options);
//     }
//
//     clientStreaming<I extends object, O extends object>(
//         method: MethodInfo<I, O>,
//         options: RpcOptions
//     ): ClientStreamingCall<I, O> {
//         return this.transport.clientStreaming(method);
//     }
//
//     duplex<I extends object, O extends object>(
//         method: MethodInfo<I, O>,
//         options: RpcOptions
//     ): DuplexStreamingCall<I, O> {
//         return this.transport.duplex(method);
//     }
// }
//
// // Crear una clase wrapper para manejar la lógica específica del servicio
// export class DeliveryService {
//     private client: DeliveryServiceClient;
//
//     constructor(serverUrl: string) {
//         const transport = new MyRpcTransport(serverUrl);
//         this.client = new DeliveryServiceClient(transport);
//     }
//
//     searchDrivers(request: SearchDriversRequest): ServerStreamingCall<SearchDriversRequest, SearchDriversResponse> {
//         const options: RpcOptions = {
//             timeout: 30000,
//             headers: {
//                 'Content-Type': 'application/grpc-web+proto'
//             }
//         };
//         return this.client.searchDrivers(request, options);
//     }
//
//     updateDriverLocation(request: DriverLocation): ServerStreamingCall<DriverLocation, UpdateDriverLocation> {
//         const options: RpcOptions = {
//             timeout: 30000,
//             headers: {
//                 'Content-Type': 'application/grpc-web+proto'
//             }
//         };
//         return this.client.updateDriverLocation(request, options);
//     }
// }
//
// // Crear y exportar una instancia del servicio
// const serverUrl = "http://localhost:50051"; // Ajusta según tu configuración
// export const deliveryService = new DeliveryService(serverUrl);