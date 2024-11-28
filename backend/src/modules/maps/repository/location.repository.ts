import {DriverLocation} from "../../../grpc/protoLoader";
import pool from "../../../commons/connection-db";
import {RowDataPacket} from "mysql2";
import {NotificationService} from "../../../commons/notificationService";
import {Request, Response} from "express";


const notificationService = new NotificationService();

export async function searchDrivers(req: Request, res: Response): Promise<void> {
  const request = req.body;
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
      res.status(404).json({ error: 'Order not found' });
      return;
    }

    while (Date.now() - startTime < searchTimeoutMs) {
      // Buscar conductores cercanos
      const nearbyDrivers = await findNearbyDrivers(
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
          await notificationService.sendOrderNotification(driver.no_courier, driver.distance_km, order);

          // Send driver info to client
          res.write(JSON.stringify({
            no_courier: driver.no_courier,
            courier_name: 'Juan',
            lat: driver.lat,
            lng: driver.lng,
            status: 'SEARCHING'
          }) + '\n');
        }
      }

      await new Promise(resolve => setTimeout(resolve, searchIntervalMs));

      // Verify if the order has been accepted
      const [orderStatus] = await pool.query<RowDataPacket[]>(
        'SELECT o.status, o.id_courier, concat(p.name, " ", p.surname, " ", ifnull(p.lastname, "")) as name FROM Orders o LEFT JOIN Couriers c On c.no_courier = o.id_courier LEFT JOIN People p On p.uid = c.id_person WHERE o.no_order = ?',
        [order.no_order]
      );

      if (orderStatus[0].status === 'In shopping') {
        res.write(JSON.stringify({
          courier_id: orderStatus[0].id_courier,
          status: 'In shopping',
          courier_name: orderStatus[0].name
        }) + '\n');
        res.end();
        return;
      }
    }

    // Timeout after 10 minutes
    await pool.query<RowDataPacket[]>(
      'UPDATE Orders SET status = ? WHERE no_order = ?',
      ['Canceled', order.no_order]
    );

    res.write(JSON.stringify({
      status: 'Timeout'
    }) + '\n');
    res.end();
    console.log('No drivers found');
  } catch (error) {
    console.error('Error in searchDrivers:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
}


export const findNearbyDrivers = async(lat: number, lng: number, radiusKm: number): Promise<DriverLocation[]> => {
    const [drivers] = await pool.query<RowDataPacket[]>(
      `SELECT 
          ST_Distance_Sphere(location, ST_PointFromText(?)) / 1000 as distance_km,
          ST_Y(location) AS lat,  -- Cambiado: ST_Y para latitud
          ST_X(location) AS lng,  -- Cambiado: ST_X para longitud
          c.no_courier, 
          c.fcm_token
        FROM Places p 
        LEFT JOIN Couriers c ON p.id_courier = c.no_courier
        WHERE ST_Distance_Sphere(location, ST_PointFromText(?)) <= ? * 1000
          AND c.status = 'Available'
        ORDER BY distance_km ASC 
        LIMIT 20`,
      [`POINT(${lng} ${lat})`, `POINT(${lng} ${lat})`, radiusKm]
    );

    return drivers as DriverLocation[];
  }

  export const hasDriverNotified = async(driverId: string, orderId: string): Promise<boolean> => {
    try {
        const [rows] = await pool.query<RowDataPacket[]>(
          `SELECT id FROM Notifications 
           WHERE courier_id = ? AND order_id = ?`,
          [driverId, orderId]
        );

        return rows.length > 0;
    }catch (error: any) {
        console.error('Error in hasDriverNotified:', error);
        throw (error as Error).message;
    }
  }

  export const checkOrderStatus = async(orderId: string): Promise<any> => {
    try {
        const [orderStatus] = await pool.query<RowDataPacket[]>(
            'SELECT o.status, o.id_courier, concat(p.name, " ", p.surname, " ", ifnull(p.lastname, "")) as name FROM Orders o LEFT JOIN Couriers c On c.no_courier = o.id_courier LEFT JOIN People p On p.uid = c.id_person WHERE o.no_order = ?',
            [orderId]
          );

        return orderStatus[0];
    }catch (error: any) {
        console.error('Error in checkOrderStatus:', error);
        throw (error as Error).message;
    }
  }

  export const cancelOrder = async(orderId: string): Promise<boolean> => {
    try {
        await pool.query<RowDataPacket[]>(
          'UPDATE Orders SET status = ? WHERE no_order = ?',
          ['Canceled', orderId]
        );

        return true
    }catch (error: any) {
        console.error('Error in cancelOrder:', error);
        throw (error as Error).message;
    }
  }

  export const countProducts = async(orderId: string): Promise<any> => {
    try {
        const [orderRows] = await pool.query<RowDataPacket[]>(
        'SELECT *, (select count(id) from Products where no_order = ?) as products FROM Orders WHERE no_order = ?;',
        [orderId, orderId]
      );
        return orderRows[0];
    }catch (error: any) {
        console.error('Error in countProducts:', error);
        throw (error as Error).message;
    }
  }

  export const updateCourierLocation = async (driver: any): Promise<boolean> => {
    const connection = await pool.getConnection();
    try {
        if (!await existsCourier(driver.no_courier)) throw new Error('Courier not found');
        await connection.beginTransaction()

        if (!await existsLocationDriver(driver.no_courier)) {
            await connection.query<RowDataPacket[]>(
                `INSERT INTO Places (id_courier, location, name, type) VALUES (?, ST_GeomFromText(?), ?, ?)`,
                [driver.no_courier, `POINT(${driver.lng} ${driver.lat})`, 'Courier location', 'Courier'])
        }

        await connection.query<RowDataPacket[]>(
          `UPDATE Places
           SET location = ST_GeomFromText(?) WHERE id_courier = ?`,
          [`POINT(${driver.lng} ${driver.lat})`, driver.no_courier]
        );

        await connection.query<RowDataPacket[]>(
          `UPDATE Couriers
           SET status = "Available", last_update = current_timestamp WHERE no_courier = ?`,
          [driver.no_courier]
        );
        await connection.commit()

        return true;
    } catch (error: any) {
        await connection.rollback()
        console.error('Error in updateDriverLocation:', error);
        throw (error as Error).message;
    } finally {
        connection.release();
    }
  }

  const existsCourier = async (no_courier: string): Promise<boolean> => {
    try {
        const [rows] = await pool.query<RowDataPacket[]>(
          'SELECT no_courier FROM Couriers WHERE no_courier = ?',
          [no_courier]
        );

        return rows.length > 0;
    }catch (error: any) {
        console.error('Error in existsCourier:', error);
        throw (error as Error).message;
    }
  }

  export const existsLocationDriver = async (no_courier: string): Promise<boolean> => {
    try {
        const [rows] = await pool.query<RowDataPacket[]>(
          'SELECT id FROM Places WHERE id_courier = ?',
          [no_courier]
        );

        return rows.length > 0;
    }catch (error: any) {
        console.error('Error in existsLocationDriver:', error);
        throw (error as Error).message;
    }
  }

  export const offDriverService = async (driver: any): Promise<boolean> => {
    try {
        await pool.query<RowDataPacket[]>(
          'UPDATE Couriers SET status = "Out of service" WHERE no_courier = ?',
          [driver.no_courier]
        );
        return true;
    }catch (error: any) {
        console.error('Error in offDriverService:', error);
        throw (error as Error).message;
    }
  }