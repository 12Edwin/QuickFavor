import {DriverLocation} from "../../../grpc/protoLoader";
import pool from "../../../commons/connection-db";
import {RowDataPacket} from "mysql2";


export const findNearbyDrivers = async(lat: number, lng: number, radiusKm: number): Promise<DriverLocation[]> => {
    const [drivers] = await pool.query<RowDataPacket[]>(
      `SELECT 
          ROUND(ST_Distance_Sphere(location, ST_PointFromText(?)) / 1000, 2) as distance_km,
          ST_Y(location) AS lat,  --  ST_Y para latitud
          ST_X(location) AS lng,  --  ST_X para longitud
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
        'SELECT *, (select count(id) from Products where id_order = ?) as products FROM Orders WHERE no_order = ?;',
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
           SET status = "Available", last_update = current_timestamp WHERE no_courier = ? AND status = "Out of service"`,
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