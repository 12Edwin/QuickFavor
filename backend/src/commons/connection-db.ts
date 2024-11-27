import mysql from 'mysql2/promise';
import dotenv from 'dotenv'

dotenv.config();

const pool = mysql.createPool({
    host: process.env.DB_HOST,
    user: 'root',
    password: process.env.DB_ROOT_PASSWORD,
    database: process.env.DB_NAME,
    port: 3306,
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});

export default pool;