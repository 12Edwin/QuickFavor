import * as dotenv from 'dotenv';
import express, {Application, Request, Response} from 'express';
import cors from 'cors';
import AuthRouter from "./auth/router/auth.router";
import pool from "./commons/connection-db";
import * as grpc from '@grpc/grpc-js';
import {authInterceptor} from "./grpc/interceptor";
import { protoDescriptor } from './grpc/protoLoader';
import {CourierRouter} from "./modules/courier/router/courier.router";
import {CustomerRouter} from "./modules/customer/router/customer.router";
import {FavorRouter} from "./modules/favors/router/favor.router";
import {DeliveryService} from "./grpc/services/locationService";
import {NotificationService} from "./commons/notificationService";

const app: Application = express();
const port: Number = 3000;
const grpcPort = process.env.GRPC_PORT || 50051;

dotenv.config();
app.use(express.json({limit:'50mb'}));
app.use(cors({
    credentials: true,
    origin: '*'
}));


app.listen(port, () => { console.log(`App listening at port ${port}`);});

pool.getConnection().then(connection => {
    console.log('Database connected')
    connection.release();
}).catch(error => {
    console.log(error)
})

app.get('/', (req: Request, res: Response) => {
    res.send('Welcome to our services..');
});

const grpcServer = new grpc.Server();

const deliveryService = new DeliveryService(new NotificationService());

grpcServer.addService((protoDescriptor.delivery as any).DeliveryService.service, {
  searchDrivers: deliveryService.searchDrivers.bind(deliveryService),
  updateDriverLocation: deliveryService.updateDriverLocation.bind(deliveryService)
});

grpcServer.bindAsync(
  `0.0.0.0:${grpcPort}`,
  grpc.ServerCredentials.createInsecure(),
  (err, port) => {
    if (err) {
      console.error('Error al iniciar servidor gRPC:', err);
      return;
    }

    grpcServer.start();
    console.log(`gRPC server listening at port ${port}`);
  }
);

app.use('/auth', AuthRouter)
app.use('/courier', CourierRouter)
app.use('/customer', CustomerRouter)
app.use('/favor', FavorRouter)
