import pool from "../../../commons/connection-db";
import {RowDataPacket} from "mysql2";
import {Customer, User} from "../../../auth/interface/User";

export class CustomerRepository{
    constructor() {}

    async getCustomerProfile(uid: string): Promise<any>{
        try{
            const [result] =  await pool.query('SELECT p.*, c.* FROM People p LEFT JOIN Customers c ON p.uid = c.id_person WHERE p.uid = ?;', [uid])
            const rows = result as RowDataPacket[]
            if (rows.length === 0) throw new Error('User not found');
            return rows[0]
        }catch (error: any) {
            throw new Error((error as Error).message)
        }
    }

    async editCustomerProfile(currentId: string, phone: string, lat: string, lng: string): Promise<void>{
        const connection = await pool.getConnection();
        try {
            await connection.beginTransaction();
            await connection.query('UPDATE People SET phone = ? WHERE uid = ?',
                [phone, currentId]);

            const [rows_customer] = await connection.query<RowDataPacket[]>(
                'SELECT no_customer FROM Customers WHERE id_person = ?', [currentId]
            );

            await connection.query('UPDATE Places SET location = ST_GeomFromText(?) WHERE id_customer = ?', [`POINT(${lng} ${lat})`, rows_customer[0].no_customer]);

            await connection.commit();
        } catch (error: any){
            console.log(error)
            connection.rollback();
            throw new Error((error as Error).message)
        }finally {
            connection.release()
        }
    }
}