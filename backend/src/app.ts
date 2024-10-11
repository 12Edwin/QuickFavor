import * as dotenv from 'dotenv';
import express, { Application, Request, Response } from 'express';
import cors from 'cors';
import AuthRouter from "./auth/router/auth.router";
import pool from "./commons/connection-db";

const app: Application = express();
const port: Number = 3000;
dotenv.config();

app.use(cors({
    credentials: true,
    origin: '*'
}));

app.use(express.json({limit:'50mb'}));

app.listen(port, () => {
    console.log(`App listening at port ${port}`);
});

pool.getConnection().then(connection => {
    console.log('Database connected')
    connection.release();
}).catch(error => {
    console.log(error)
})

app.get('/', (req: Request, res: Response) => {
    res.send('Welcome to our services..');
});

app.use('/auth', AuthRouter)
