import {validationResult} from "express-validator";
import {Response400, Response401, Response403} from "./TypeResponse";
import {NextFunction, Request, Response} from "express";
import {admin} from "./config-SDK";
import pool from "./connection-db";
import {RowDataPacket} from "mysql2";
import {decrypt} from "./crypt-config";

const validateMiddlewares = (req: Request, res: Response, next: NextFunction) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        const result= Response400(errors.array(), 'Bad Request');
        return res.status(result.code).json(result);
    }
    next();
}

const validateJWT = async (req: Request, res: Response, next: NextFunction) => {

    const authHeader = req.headers.authorization;
    const result = Response401('Invalid token');
    if (!authHeader) {
        return res.status(result.code).json(result);
    }

    const token = authHeader.split('Bearer ')[1];

    if (!token){
        return res.status(result.code).json(result);
    }
    try {
        const decryptedToken = decrypt(token);
        req.body.user = await admin.auth().verifyIdToken(decryptedToken);
        const user = await admin.auth().getUser(req.body.user.uid);
        if (user.disabled) {
            const response = Response403(null, 'User disabled');
            return res.status(response.code).json(response);
        }
        next();
    } catch (error) {
        return res.status(result.code).json(result);
    }
}

const checkAdminRole = async (req: Request, res: Response, next: NextFunction) => {
    const {uid} = req.body.user;
    try {
        const role = await getRoleByUid(uid);
        if (role !== 'admin') {
            const response = Response403(null, 'Forbidden');
            return res.status(response.code).json(response);
        }
        next();
    } catch (error) {
        const response = Response403(null, 'Forbidden');
        return res.status(response.code).json(response);
    }
}

const getRoleByUid = async (uid: string = ''): Promise<string> => {
    try {
        const [result] =  await pool.query('SELECT role FROM users WHERE firebase_uid = ? limit 1', [uid])
        const rows = result as RowDataPacket[]
        if (rows.length === 0) throw new Error('User not found');

        return rows[0].role;
    } catch (error: any) {
        throw new Error((error as Error).message)
    }
}

export {
    validateMiddlewares,
    validateJWT,
    checkAdminRole
}