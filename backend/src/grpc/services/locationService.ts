import { ServerWritableStream } from '@grpc/grpc-js';
import pool from "../../commons/connection-db";
import {RowDataPacket} from "mysql2";
import {NotificationService} from "../../commons/notificationService";
import {DriverLocation, SearchDriversRequest, SearchDriversResponse, UpdateDriverLocation} from "../protoLoader";

export class DeliveryService {
  private notificationService: NotificationService;

  constructor(notificationService: NotificationService) {
    this.notificationService = notificationService;
  }

  async searchDrivers(call: ServerWritableStream<SearchDriversRequest, SearchDriversResponse>): Promise<void> {
    const request = call.request;
    const searchTimeoutMs = 10 * 60 * 1000; // 10 minutes
    const searchIntervalMs = 5000;
    const startTime = Date.now();

    try {
      const [orderRows] = await pool.query<RowDataPacket[]>(
        'SELECT *, (select count(id) from Products where no_order = ?) as products FROM Orders WHERE no_order = ?;',
        [request.no_order, request.no_order]
      );
      const order = orderRows[0] as any;

      if (!order) {
        throw new Error('Order not found');
      }

      while (Date.now() - startTime < searchTimeoutMs) {
        if (call.cancelled) {
          console.log('Client cancelled the request');
          return;
        }
        // Buscar conductores cercanos
        const nearbyDrivers = await this.findNearbyDrivers(
          request.delivery_point.lat,
          request.delivery_point.lng,
          10 // 10 km of radius
        );

        for (const driver of nearbyDrivers) {
          // Verificar si ya notificamos a este conductor
          const [notifiedRows] = await pool.query<RowDataPacket[]>(
            `SELECT id FROM Notifications 
             WHERE courier_id = ? AND order_id = ?`,
            [driver.no_courier, order.no_order]
          );

          if (!notifiedRows.length) {
            // Send notification to driver
            await this.notificationService.sendOrderNotification(driver.no_courier, driver.distance_km, order);

            // Send driver info to client
            call.write({
              no_courier: driver.no_courier,
              courier_name: 'Juan',
              lat: driver.lat,
              lng: driver.lng,
              status: 'SEARCHING'
            });
          }
        }

        await new Promise(resolve => setTimeout(resolve, searchIntervalMs));

        // Verify if the order has been accepted
        const [orderStatus] = await pool.query<RowDataPacket[]>(
          'SELECT o.status, o.id_courier, concat(p.name, " ", p.surname, " ", ifnull(p.lastname, "")) as name FROM Orders o LEFT JOIN Couriers c On c.no_courier = o.id_courier LEFT JOIN People p On p.uid = c.id_person WHERE o.no_order = ?',
          [order.no_order]
        );

        if (orderStatus[0].status === 'In shopping') {
          call.write({
            courier_id: orderStatus[0].id_courier,
            status: 'In shopping',
            courier_name: orderStatus[0].name
          } as any);
          return;
        }
      }

      // Timeout after 10 minutes
      await pool.query<RowDataPacket[]>(
        'UPDATE Orders SET status = ? WHERE no_order = ?',
        ['Canceled', order.no_order]
      );

      call.write({
        status: 'Timeout'
      } as any);
    } catch (error) {
      console.error('Error in searchDrivers:', error);
      throw error;
    }
  }

  private async findNearbyDrivers(lat: number, lng: number, radiusKm: number): Promise<DriverLocation[]> {
    // Search for drivers within the radius
    const [drivers] = await pool.query<RowDataPacket[]>(
      `SELECT *,
        ST_Distance_Sphere(location, ST_PointFromText(?)) / 1000 as distance_km,
        ST_X(location) AS lat, ST_Y(location) AS lng, c.no_courier, c.fcm_token
        FROM Places p LEFT JOIN Couriers c ON p.id_courier = c.no_courier
        WHERE ST_Distance_Sphere(location, ST_PointFromText(?)) <= ? * 1000
        AND c.status = 'Available'
        ORDER BY distance_km ASC LIMIT 20;`,
      [`POINT(${lng} ${lat})`, `POINT(${lng} ${lat})`, radiusKm]
    );

    return drivers as DriverLocation[];
  }

  async updateDriverLocation(call: ServerWritableStream<DriverLocation, UpdateDriverLocation>): Promise<void> {
    const driver = call.request;

    try {
      // Update driver location
      await pool.query<RowDataPacket[]>(
        `UPDATE Places
         SET location = ? WHERE id_courier = ?`,
        [`POINT(${driver.lng} ${driver.lat})`, driver.no_courier]
      );

      await pool.query<RowDataPacket[]>(
        `UPDATE Couriers
         SET status= "Available" WHERE no_courier = ?`,
        [driver.no_courier]
      );
      call.write({ success: true, status: 'Available' });
      // Wait for order request
      await new Promise((resolve) => {
        call.on('cancelled', resolve);
        call.on('error', resolve);
      });
    } finally {
      // Mark driver as out of service
      await pool.query<RowDataPacket[]>(
        'UPDATE Couriers SET status = "Out of service" WHERE no_courier = ?',
        [driver.no_courier]
      );
      call.write({ success: true, status: 'Out of service' });
    }
  }
}