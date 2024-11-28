import * as jspb from 'google-protobuf'



export class SearchDriversRequest extends jspb.Message {
  getNoOrder(): string;
  setNoOrder(value: string): SearchDriversRequest;

  getDeliveryPoint(): DeliveryPoint | undefined;
  setDeliveryPoint(value?: DeliveryPoint): SearchDriversRequest;
  hasDeliveryPoint(): boolean;
  clearDeliveryPoint(): SearchDriversRequest;

  getSearchRadiusKm(): number;
  setSearchRadiusKm(value: number): SearchDriversRequest;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): SearchDriversRequest.AsObject;
  static toObject(includeInstance: boolean, msg: SearchDriversRequest): SearchDriversRequest.AsObject;
  static serializeBinaryToWriter(message: SearchDriversRequest, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): SearchDriversRequest;
  static deserializeBinaryFromReader(message: SearchDriversRequest, reader: jspb.BinaryReader): SearchDriversRequest;
}

export namespace SearchDriversRequest {
  export type AsObject = {
    noOrder: string,
    deliveryPoint?: DeliveryPoint.AsObject,
    searchRadiusKm: number,
  }
}

export class SearchDriversResponse extends jspb.Message {
  getNoCourier(): string;
  setNoCourier(value: string): SearchDriversResponse;

  getCourierName(): string;
  setCourierName(value: string): SearchDriversResponse;

  getLat(): number;
  setLat(value: number): SearchDriversResponse;

  getLng(): number;
  setLng(value: number): SearchDriversResponse;

  getStatus(): string;
  setStatus(value: string): SearchDriversResponse;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): SearchDriversResponse.AsObject;
  static toObject(includeInstance: boolean, msg: SearchDriversResponse): SearchDriversResponse.AsObject;
  static serializeBinaryToWriter(message: SearchDriversResponse, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): SearchDriversResponse;
  static deserializeBinaryFromReader(message: SearchDriversResponse, reader: jspb.BinaryReader): SearchDriversResponse;
}

export namespace SearchDriversResponse {
  export type AsObject = {
    noCourier: string,
    courierName: string,
    lat: number,
    lng: number,
    status: string,
  }
}

export class DeliveryPoint extends jspb.Message {
  getAddress(): string;
  setAddress(value: string): DeliveryPoint;

  getLat(): number;
  setLat(value: number): DeliveryPoint;

  getLng(): number;
  setLng(value: number): DeliveryPoint;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): DeliveryPoint.AsObject;
  static toObject(includeInstance: boolean, msg: DeliveryPoint): DeliveryPoint.AsObject;
  static serializeBinaryToWriter(message: DeliveryPoint, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): DeliveryPoint;
  static deserializeBinaryFromReader(message: DeliveryPoint, reader: jspb.BinaryReader): DeliveryPoint;
}

export namespace DeliveryPoint {
  export type AsObject = {
    address: string,
    lat: number,
    lng: number,
  }
}

export class DriverLocation extends jspb.Message {
  getNoCourier(): string;
  setNoCourier(value: string): DriverLocation;

  getLat(): number;
  setLat(value: number): DriverLocation;

  getLng(): number;
  setLng(value: number): DriverLocation;

  getDistanceKm(): number;
  setDistanceKm(value: number): DriverLocation;

  getFcmToken(): string;
  setFcmToken(value: string): DriverLocation;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): DriverLocation.AsObject;
  static toObject(includeInstance: boolean, msg: DriverLocation): DriverLocation.AsObject;
  static serializeBinaryToWriter(message: DriverLocation, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): DriverLocation;
  static deserializeBinaryFromReader(message: DriverLocation, reader: jspb.BinaryReader): DriverLocation;
}

export namespace DriverLocation {
  export type AsObject = {
    noCourier: string,
    lat: number,
    lng: number,
    distanceKm: number,
    fcmToken: string,
  }
}

export class UpdateDriverLocation extends jspb.Message {
  getSuccess(): boolean;
  setSuccess(value: boolean): UpdateDriverLocation;

  getStatus(): string;
  setStatus(value: string): UpdateDriverLocation;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): UpdateDriverLocation.AsObject;
  static toObject(includeInstance: boolean, msg: UpdateDriverLocation): UpdateDriverLocation.AsObject;
  static serializeBinaryToWriter(message: UpdateDriverLocation, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): UpdateDriverLocation;
  static deserializeBinaryFromReader(message: UpdateDriverLocation, reader: jspb.BinaryReader): UpdateDriverLocation;
}

export namespace UpdateDriverLocation {
  export type AsObject = {
    success: boolean,
    status: string,
  }
}

