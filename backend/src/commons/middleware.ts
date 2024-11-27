import {validationResult} from "express-validator";
import {Response400, Response401, Response403} from "./TypeResponse";
import {admin} from "./config-SDK";
import pool from "./connection-db";
import {RowDataPacket} from "mysql2";
import {decrypt} from "./crypt-config";
import {NextFunction, Response, Request} from "express";

const validateMiddlewares = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        const result = Response400(errors.array(), 'Bad Request');
        res.status(result.code).json(result);
        return
    } else {
        next();
    }
};

const validateJWT = async (req: Request, res: Response, next: NextFunction): Promise<void> => {

    const authHeader = req.headers.authorization;
    const result = Response401('Invalid token');
    if (!authHeader) {
        res.status(result.code).json(result);
        return;
    }

    const token = authHeader.split('Bearer ')[1] || authHeader;

    if (!token){
        res.status(result.code).json(result);
        return;
    }
    try {
        const decryptedToken = decrypt(token);
        req.body.user = await admin.auth().verifyIdToken(decryptedToken);
        const user = await admin.auth().getUser(req.body.user.uid);
        if (user.disabled) {
            const response = Response403(null, 'User disabled');
            res.status(response.code).json(response);
            return;
        }
        next();
    } catch (error) {
        res.status(result.code).json(result);
    }
}

const checkRole = (roles: string[] = []) => {
    return async (req: Request, res: Response, next: NextFunction): Promise<void> => {
        const {uid} = req.body.user;
        try {
            const role = await getRoleByUid(uid);
            if (!roles.includes(role)) {
                const response = Response403(null, 'Forbidden');
                res.status(response.code).json(response);
                return
            }
            next();
        } catch (error) {
            console.log(error)
            const response = Response403(null, 'Forbidden');
            res.status(response.code).json(response);
            return
        }
    }
}

const checkRoleGRPC = async (roles: string[] = [], encrypted: string) => {

    const token = encrypted.split('Bearer ')[1] || encrypted;
    if (!token)return false;
    try {
        const decryptedToken = decrypt(token);
        const {uid} = await admin.auth().verifyIdToken(decryptedToken);
        const role = await getRoleByUid(uid);
        return roles.includes(role);
    } catch (error) {
        return false
    }
}

const getRoleByUid = async (uid: string = ''): Promise<string> => {
    try {
        const [result] =  await pool.query('SELECT role FROM People WHERE uid = ? limit 1', [uid])
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
    checkRole,
    checkRoleGRPC
}