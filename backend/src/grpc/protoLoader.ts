// src/types/grpc.ts
import { loadSync } from '@grpc/proto-loader';
import { loadPackageDefinition } from '@grpc/grpc-js';
import path from 'path';

const PROTO_PATH = path.resolve(__dirname, '../proto/delivery.proto');

const packageDefinition = loadSync(PROTO_PATH, {
  keepCase: true,
  longs: String,
  enums: String,
  defaults: true,
  oneofs: true
});

export const protoDescriptor = loadPackageDefinition(packageDefinition);

// Extraer los tipos del descriptor
export const {
  SearchDriversRequest,
  SearchDriversResponse,
  DriverLocation,
  UpdateDriverLocation
} = (protoDescriptor.delivery as any);

// Interfaces TypeScript para type safety
export interface SearchDriversRequest {
  no_order: string;
  delivery_point: {
    address: string;
    lat: number;
    lng: number;
  };
}

export interface SearchDriversResponse {
  no_courier: string;
  courier_name: string;
  lat: number;
  lng: number;
  status: string;
}

export interface DriverLocation {
  no_courier: string;
  lat: number;
  lng: number;
  distance_km: number;
  fcm_token?: string;
}

export interface UpdateDriverLocation {
  success: boolean;
  status: string;
}