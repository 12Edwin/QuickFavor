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

    async editCustomerProfile(payload: User & Customer): Promise<any>{
        const connection = await pool.getConnection();
        try {
            const { uid, lastname, phone, email, name, surname }: User & Customer = payload
            await connection.beginTransaction();
            await connection.query('UPDATE People SET name = $1, surname = $2, lastname = $3, phone = $4, email = $5 WHERE uid = $6',
                [name, surname, lastname, phone, email, uid]);
            await connection.commit();
        } catch (error: any){
            connection.rollback();
            throw new Error((error as Error).message)
        }finally {
            connection.release()
        }
    }
}