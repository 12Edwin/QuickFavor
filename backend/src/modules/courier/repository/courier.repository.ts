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

    async editCourierProfile(uid: string, profileData: any): Promise<void>{
        const connection = await pool.getConnection();
        try{
            const { email, name, surname, lastname, vehicle_type, license_plate, face_photo, INE_photo, plate_photo, phone } = profileData
            await connection.beginTransaction();
            await connection.query('UPDATE People SET email = ?, phone = ?, name = ?, surname = ?, lastname = ? WHERE uid = ?;', [email, phone, name, surname, lastname, uid]);
            await connection.query('UPDATE Couriers SET vehicle_type = ?, license_plate = ? WHERE id_person = ?;', [vehicle_type,license_plate, uid]);
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
}