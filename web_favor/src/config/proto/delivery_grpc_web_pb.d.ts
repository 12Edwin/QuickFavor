import * as grpcWeb from 'grpc-web';

import * as delivery_pb from './delivery_pb'; // proto import: "delivery.proto"


export class DeliveryServiceClient {
  constructor (hostname: string,
               credentials?: null | { [index: string]: string; },
               options?: null | { [index: string]: any; });

  searchDrivers(
    request: delivery_pb.SearchDriversRequest,
    metadata?: grpcWeb.Metadata
  ): grpcWeb.ClientReadableStream<delivery_pb.SearchDriversResponse>;

  updateDriverLocation(
    request: delivery_pb.DriverLocation,
    metadata?: grpcWeb.Metadata
  ): grpcWeb.ClientReadableStream<delivery_pb.UpdateDriverLocation>;

}

export class DeliveryServicePromiseClient {
  constructor (hostname: string,
               credentials?: null | { [index: string]: string; },
               options?: null | { [index: string]: any; });

  searchDrivers(
    request: delivery_pb.SearchDriversRequest,
    metadata?: grpcWeb.Metadata
  ): grpcWeb.ClientReadableStream<delivery_pb.SearchDriversResponse>;

  updateDriverLocation(
    request: delivery_pb.DriverLocation,
    metadata?: grpcWeb.Metadata
  ): grpcWeb.ClientReadableStream<delivery_pb.UpdateDriverLocation>;

}

