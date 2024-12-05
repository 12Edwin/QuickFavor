import pool from "../../../commons/connection-db";
import {RowDataPacket} from "mysql2";

export class CourierRepository{
    async getCourierProfile(uid: string): Promise<any>{
        try{
            const [result] =  await pool.query('SELECT p.*, c.* FROM People p LEFT JOIN Couriers c ON p.uid = c.id_person WHERE p.uid = ?;', [uid])
            const rows = result as RowDataPacket[]
            if (rows.length === 0) throw new Error('User not found');
            return rows[0]
        }catch (error: any) {
            throw new Error((error as Error).message)
        }
    }

    async editCourierProfile(uid: string, phone: string): Promise<void>{
        const connection = await pool.getConnection();
        try{
            await connection.beginTransaction();
            await connection.query('UPDATE People SET phone = ? WHERE uid = ?;', [phone, uid]);
            await connection.commit();
        }catch (error: any) {
            await connection.rollback();
            throw new Error((error as Error).message)
        }finally {
            connection.release();
        }
    }

    async changeCourierStatus(uid: string, status: string): Promise<void>{
        try{
            await pool.query('UPDATE Couriers SET status = ? WHERE id_person = ?;', [status, uid]);
        }catch (error: any) {
            throw new Error((error as Error).message)
        }
    }

    async editVehicleCourier(id_person: string, vehicle_type: string, license_plate: string | null, plate_photo: string | null, brand: string | null, model: string | null, color: string | null, description: string | null): Promise<void>{
        try{
            await pool.query('UPDATE Couriers SET brand = ?, model = ?, color = ?, vehicle_type = ?, license_plate = ?, plate_url = ?, description = ? WHERE id_person = ?;', [brand, model, color, vehicle_type, license_plate, plate_photo, description, id_person]);
        }catch (error: any) {
            throw new Error((error as Error).message)
        }
    }
}