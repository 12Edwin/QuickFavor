import {FavorEntity} from "../interface/favor.entity";
import pool from "../../../commons/connection-db";
import {RowDataPacket} from "mysql2";
import {LocationEntity} from "../../../grpc/entity/location.entity";

export class FavorRepository{

    async createFavor(payload: FavorEntity): Promise<string>{
        const connection = await pool.getConnection();
        try {
            connection.beginTransaction();
            await connection.query(`INSERT INTO Orders (status, id_customer) VALUES (?, ?)`, ["Pending", payload.id_customer]);
            const [rows] = await connection.query<RowDataPacket[]>(`SELECT no_order FROM Orders WHERE id_customer = ? ORDER BY created_at DESC LIMIT 1`, [payload.id_customer]);
            const id_order = rows[0].no_order;

            await connection.query(`INSERT INTO Places (id_order, type, name, location) VALUES (?, ?, ?, ST_GeomFromText(?))`, [id_order, "Home", payload.customer_direction.name, `POINT(${payload.customer_direction.lng} ${payload.customer_direction.lat})`]);
            for (const point of payload.collection_points) {
                await connection.query(`INSERT INTO Places (id_order, type, name, location) VALUES (?, ?, ?, ST_GeomFromText(?))`, [id_order, "Collection", point.name, `POINT(${point.lng} ${point.lat})`]);
            }
            for (const product of payload.products) {
                await connection.query(`INSERT INTO Products (name, description, amount, id_order) Values (?, ?, ?, ?)`, [product.name, product.description, product.amount, id_order]);
            }
            connection.commit();
            return id_order;
        }catch (error: any){
            connection.rollback();
            throw new Error((error as Error).message)
        } finally {
            connection.release();
        }
    }

    async getFavorStatus(id: string): Promise<Map<string, any>>{
        try {
            const [result] = await pool.query('SELECT created_at as order_created_at, status FROM Orders WHERE no_order = ?;', [id])
            const rows = result as RowDataPacket[]
            return this.rowToMap(rows[0]);
        }catch (error: any){
            throw new Error((error as Error).message)
        }
    }

    async getDetailsFavor (id: string): Promise<any> {
        try {

            const [result] = await pool.query('SELECT * FROM order_details WHERE no_order = ?;', [id])
            const rows = result as RowDataPacket[]
            const details = {
                deliveryPoints: [] as any,
                products: [] as any,
                ...rows[0]
            }
            const [rowsDelivery] = await pool.query<RowDataPacket[]>(
                'SELECT ST_X(location) as lng, ST_Y(location) as lat, name FROM Places WHERE type = "Collection" AND id_order = ?;',
                [id]
            );
            details.deliveryPoints = rowsDelivery
            const [rowsProduct] = await pool.query<RowDataPacket[]>(
                'SELECT name, description, amount, created_at FROM Products WHERE id_order = ?;',
                [id]
            );
            details.products = rowsProduct
            return details
        } catch (error: any) {
            throw new Error((error as Error).message)
        }
    }

    async updateFavorStatus(id: string, newStatus: string, cost: number | null = null, receipt: string | null = null): Promise<boolean>{
        const connection = await pool.getConnection();
        try {
            connection.beginTransaction();
            await connection.query('UPDATE Orders SET status = ?, cost = ?, receipt_url = ? WHERE no_order = ?;', [newStatus, cost, receipt, id])
            if (newStatus === 'Finished'){
                await connection.query('UPDATE Orders SET finished_at = current_timestamp WHERE no_order = ?;', [id])
            }
            if (newStatus === 'Finished' || newStatus === 'Canceled') {
                await connection.query('UPDATE Couriers SET status = "Available" WHERE no_courier = (SELECT id_courier FROM Orders WHERE no_order = ?);', [id])
            }
            connection.commit();
            return true;
        }catch (error: any){
            connection.rollback();
            throw new Error((error as Error).message)
        }finally {
            connection.release();
        }
    }

    async acceptFavor(no_order: string, uid: string): Promise<boolean>{
        const connection = await pool.getConnection();
        try {
            await connection.beginTransaction();
            await connection.query('UPDATE Couriers SET status = "Busy" WHERE no_courier = ?;', [uid])
            await connection.query('UPDATE Orders SET status = "In shopping", id_courier = ?, created_at = NOW() WHERE no_order = ?;', [uid, no_order])
            await connection.query('UPDATE Notifications SET status = "Read" WHERE order_id = ? AND type = "Order" AND customer_id IS NULL;', [no_order])
            connection.commit();
            return true;
        }catch (error: any){
            await connection.rollback();
            throw new Error((error as Error).message)
        }finally {
            connection.release();
        }
    }

    async cancelFavor(no_order: string): Promise<boolean>{
        const connection = await pool.getConnection();
        try {
            await connection.beginTransaction();
            await connection.query('UPDATE Orders SET status = "Canceled" WHERE no_order = ?;', [no_order])
            await connection.query('UPDATE Couriers SET rejected_orders = rejected_orders + 1, status = "Available" WHERE no_courier = (SELECT id_courier FROM Orders WHERE no_order = ?);', [no_order])
            await connection.query('UPDATE Notifications SET status = "Deleted" WHERE order_id = ? AND type = "Order" AND customer_id IS NULL;', [no_order])
            await connection.commit();
            return true;
        }catch (error: any){
            await connection.rollback();
            throw new Error((error as Error).message)
        }finally {
            connection.release();
        }
    }

    async rejectFavor(no_order: string, courier_id: string): Promise<boolean>{
        try {
            await pool.query('UPDATE Notifications SET status = "Deleted" WHERE order_id = ? AND courier_id = ?;', [no_order, courier_id])
            return true;
        } catch (error: any){
            throw new Error((error as Error).message)
        }
    }

    async findCourierStatus(no_order: string): Promise<Map<string, any>>{
        try {
            const [result] = await pool.query('SELECT * FROM Couriers WHERE no_courier = (SELECT id_courier FROM Orders WHERE no_order = ?);', [no_order])
            const rows = result as RowDataPacket[]
            return this.rowToMap(rows[0]);
        }catch (error: any){
            throw new Error((error as Error).message)
        }
    }

    async readNotifications(no_courier: string): Promise<any>{
        try {
            const [rowsNotifications] = await pool.query('SELECT n.*, (SELECT count(id) from Products where id_order = n.order_id) as amount FROM Notifications n WHERE n.courier_id = ? AND n.status = "Pending" AND n.type = "Order";', [no_courier])
            return  rowsNotifications as RowDataPacket[];

        }catch (error: any){
            throw new Error((error as Error).message)
        }
    }

    async readCourierHistory(no_courier: string): Promise<any>{
        try {
            const [rowsHistory] = await pool.query('SELECT O.no_order, O.status, O.created_at, (SELECT COUNT(id) FROM Products P WHERE P.id_order = O.no_order) as products FROM Orders O WHERE id_courier = ? AND status IN ("Canceled", "Finished") ORDER BY created_at ASC;', [no_courier])
            return  rowsHistory as RowDataPacket[];
        }catch (error: any){
            throw new Error((error as Error).message)
        }
    }

    async readCustomerHistory(no_customer: string): Promise<any>{
        try {
            const [rowsHistory] = await pool.query('SELECT O.no_order, O.status, O.created_at, (SELECT COUNT(id) FROM Products P WHERE P.id_order = O.no_order) as products FROM Orders O WHERE id_customer = ? AND status IN ("Canceled", "Finished") ORDER BY created_at ASC;', [no_customer])
            return  rowsHistory as RowDataPacket[];
        }catch (error: any){
            throw new Error((error as Error).message)
        }
    }

    async existsFavorByNo_order(no_order: string): Promise<boolean>{
        try {
            const [result] = await pool.query('SELECT no_order FROM Orders WHERE no_order = ?;', [no_order])
            const rows = result as RowDataPacket[]
            return rows.length > 0;
        }catch (error: any){
            throw new Error((error as Error).message)
        }
    }

    async isCourierOwner(no_order: string, uid: string): Promise<boolean>{
        try {
            const [result] = await pool.query('SELECT o.no_order FROM Orders o RIGHT JOIN Couriers c On c.no_courier = o.id_courier RIGHT JOIN People p On p.uid = c.id_person WHERE no_order = ? AND uid = ?;', [no_order, uid])
            const rows = result as RowDataPacket[]
            return rows.length > 0;
        }catch (error: any){
            throw new Error((error as Error).message)
        }
    }

    async thereIsTimeToAccept(no_order: string): Promise<boolean> {
        try {
            const [result] = await pool.query(
                'SELECT * FROM Orders WHERE no_order = ? AND status= "Pending" AND created_at > NOW() - INTERVAL 10 MINUTE;',
                [no_order]
            );
            const rows = result as RowDataPacket[];
            return rows.length > 0;
        } catch (error: any) {
            throw new Error((error as Error).message);
        }
    }

    async hasNotBeenAccepted(no_order: string): Promise<boolean> {
        try {
            const [result] = await pool.query('SELECT * FROM Orders WHERE no_order = ? AND status = "Pending";', [no_order]);
            const rows = result as RowDataPacket[];
            return rows.length > 0;
        } catch (error: any) {
            throw new Error((error as Error).message);
            }
    }

    async thereIsTimeToFinish(no_order: string): Promise<boolean> {
        try {
            const [result] = await pool.query(
                'SELECT * FROM Orders WHERE no_order = ? AND created_at > NOW() - INTERVAL 2 HOUR;',
                [no_order]
            );
            const rows = result as RowDataPacket[];
            return rows.length > 0;
        } catch (error: any) {
            throw new Error((error as Error).message);
        }
    }

    async isCourierAvailable(uid: string): Promise<boolean> {
        try {
            const [result] = await pool.query('SELECT * FROM Couriers WHERE no_courier = ? AND status like "Available";', [uid]);
            const rows = result as RowDataPacket[];
            return rows.length > 0;
        } catch (error: any) {
            throw new Error((error as Error).message);
        }
    }

    async isCourierNearLocation(uid: string, location: LocationEntity): Promise<boolean> {
        try {
            const [result] = await pool.query(
                `SELECT *,
                    ST_Distance_Sphere(location, ST_PointFromText(?)) / 1000 as distance_km
                    FROM Places
                    WHERE ST_Distance_Sphere(location, ST_PointFromText(?)) <= ? * 1000
                    ORDER BY distance_km`,
                [`POINT(${location.lng} ${location.lat})`, `POINT(${location.lng} ${location.lat})`, 5]
            );
            const rows = result as RowDataPacket[];
            return rows.length > 0;
        } catch (error: any) {
            throw new Error((error as Error).message);
        }
    }

    rowToMap(row: RowDataPacket): Map<string, any> {
    const map = new Map<string, any>();
    for (const key in row) {
        if (row.hasOwnProperty(key)) {
            map.set(key, row[key]);
        }
    }
    return map;
}

    rowsToMap(rows: RowDataPacket[]): Map<string, any>[] {
    return rows.map(row => {
        const map = new Map<string, any>();
        for (const key in row) {
            if (row.hasOwnProperty(key)) {
                map.set(key, row[key]);
            }
        }
        return map;
    });
}
}

