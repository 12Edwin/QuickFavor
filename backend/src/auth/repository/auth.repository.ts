import {LoginRequest, LoginResponse} from "../interface/login.type";
import {admin, auth} from  "../../commons/config-SDK";
import {signInWithEmailAndPassword, getAuth, sendEmailVerification, sendPasswordResetEmail, User} from 'firebase/auth';
import {getAuth as getAuth2} from 'firebase-admin/auth';
import { getAuth as getAdminAuth } from 'firebase-admin/auth';
import pool from "../../commons/connection-db";
import {Reset} from "../interface/Reset";
import {Pageable, PaginationResult} from "../../commons/Pageable";
import {UserFirebaseInterface} from "../interface/userFirebase.interface";
import {RowDataPacket} from "mysql2";
import {encrypt} from "../../commons/crypt-config";
import {Courier, Customer, User as UserType} from "../interface/User";
import {PoolConnection} from "mysql2/promise";
export class AuthRepository {

    async login(payload: LoginRequest): Promise<LoginResponse> {
        try {
            const userCredential = await signInWithEmailAndPassword(auth, payload.email, payload.password);
            const user: User = userCredential.user;

            if (user.emailVerified) {
                const conf_token = await user.getIdTokenResult();
                const token = conf_token.token;
                const encryptedToken = encrypt(token);
                const userDB = await this.findUserByEmail(user.email || '');
                let no_user = ''
                if (userDB.role === 'Courier'){
                    const [courier] = await pool.query('SELECT no_courier FROM Couriers WHERE id_person = ?', [user.uid]);
                    const rows = courier as RowDataPacket[]
                    no_user = rows[0].no_courier
                }else{
                    const [customer] = await pool.query('SELECT no_customer FROM Customers WHERE id_person = ?', [user.uid]);
                    const rows = customer as RowDataPacket[]
                    no_user = rows[0].no_customer
                }
                const userData = {
                    uid: user.uid,
                    email: user.email,
                    name: user.displayName,
                    role: userDB.role,
                    no_user
                };
                return new Promise( (res)=> res({ user: userData, isEmailVerified: true, token: encryptedToken, } as LoginResponse) );
            } else {
                throw new Error('Email not verified');
            }
        }catch (error: any){
            console.log(error)
            if (error.code?.includes('auth/invalid-credential')){
                throw new Error('Invalid credentials');
            }
            if (error.code?.includes('auth/user-not-found')){
                throw new Error('User not found');
            }
            if (error.code?.includes('auth/user-disabled')){
                throw new Error('User disabled');
            }
            throw new Error((error as Error).message)
        }
    }

    async courier_register(payload: UserType & Courier): Promise<string> {
        let connection: PoolConnection | null = null;
        try {
            const { email, password, name, surname, lastname, CURP, vehicle_type, license_plate, face_photo, INE_photo, plate_photo, phone, sex, brand, model, color } = payload;

            const userRecord = await admin.auth().createUser({
                email,
                password,
                displayName: name,
                emailVerified: false
            });

            const auth = getAuth();
            const userCredential = await signInWithEmailAndPassword(auth, email, password);
            await getAdminAuth().setCustomUserClaims(userRecord.uid, { role: 'Courier' });
            await sendEmailVerification(userCredential.user);

            connection = await pool.getConnection();
            await connection.beginTransaction();

            await connection.query(
                'INSERT INTO People (uid, email, name, curp, surname, role, lastname, phone, sex) VALUES (?,?,?,?,?,?,?,?,?)',
                [userRecord.uid, email, name, CURP, surname, 'Courier', lastname, phone, sex]
            );


            await connection.query(
                'INSERT INTO Couriers (id_person, vehicle_type, license_plate, status, face_url, ine_url, plate_url, brand, model, color) VALUES (?,?,?,?,?,?,?,?,?,?)',
                [userRecord.uid, vehicle_type, license_plate, 'Out of service', face_photo, INE_photo, plate_photo, brand, model, color]
            );

            await connection.commit();
            return userRecord.uid;
        } catch (error: any) {
            console.log(error)
            if (connection) {
                await connection.rollback();
            }
            if (error.code.includes('auth/email-already-exists')){
                throw new Error('Email already exists');
            }
            throw new Error((error as Error).message);
        } finally {
            if (connection) {
                connection.release();
            }
        }
    }

    async customer_register(payload: UserType & Customer): Promise<boolean> {
        const connection = await pool.getConnection();
        try {
            const { email, password, name, surname, lastname, phone, sex, CURP, direction, lat, lng } = payload;

            const userRecord = await admin.auth().createUser({
                email,
                password,
                displayName: name,
                emailVerified: false
            });

            const auth = getAuth();
            const userCredential = await signInWithEmailAndPassword(auth, email, password);
            await getAdminAuth().setCustomUserClaims(userRecord.uid, { role: 'Customer' });
            await sendEmailVerification(userCredential.user);


            await connection.beginTransaction();

            await connection.query(
                'INSERT INTO People (uid, email, name, surname, role, lastname, phone, sex, curp) VALUES (?,?,?,?,?,?,?,?,?)',
                [userRecord.uid, email, name, surname, 'Customer', lastname, phone, sex, CURP]
            );

            await connection.query(
                'INSERT INTO Customers (id_person) VALUES (?)',
                [userRecord.uid]
            );

            const [rows_customer] = await connection.query<RowDataPacket[]>(
                'SELECT no_customer FROM Customers WHERE id_person = ?', [userRecord.uid]
            );

            const no_customer = rows_customer[0].no_customer;
            await connection.query<RowDataPacket[]>(
                `INSERT INTO Places (id_customer, location, name, type) VALUES (?, ST_GeomFromText(?), ?, ?)`,
                [no_customer, `POINT(${lng} ${lat})`, direction, 'Home'])

            await connection.commit();
            return true;
        } catch (error: any) {
            console.log(error)
            await connection.rollback();
            if (error.code.includes('auth/email-already-exists')){
                throw new Error('Email already exists');
            }
            throw new Error((error as Error).message)
        } finally {
            if (connection) {
                connection.release();
            }
        }
    }

    async resetPassword(payload: Reset): Promise<boolean> {
        try {
            const { uid, new_pass } = payload;
            await getAuth2().updateUser(uid, {
                password: new_pass,
            });
            return true;
        } catch (error:any) {
            if (error.code.include('auth/weak-password')){
                throw new Error('Weak password');
            }
            if (error.code.include('auth/user-not-found')){
                throw new Error('User not found');
            }

            throw new Error((error as Error).message)
        }
    }

    async recoveryPassword(payload: {email: string}): Promise<boolean> {
        try {
            const { email } = payload;
            await sendPasswordResetEmail(auth, email);
            return true;
        } catch (error: any) {
            let errorMessage = 'internal server error'
            switch (error.code) {
                case 'auth/user-not-found':
                    errorMessage = 'User not found';
                    break;
                case 'auth/too-many-requests':
                    errorMessage = 'Too many requests';
                    break;
            }
            throw new Error(errorMessage)
        }
    }

    async getPaginatedUsers(pageable: Pageable<UserFirebaseInterface>): Promise<PaginationResult<UserFirebaseInterface>> {
        try {
            const {limit, offset} = pageable.getPagination();

            const listUsersResult = await admin.auth().listUsers();
            const totalUsers = listUsersResult.users.length;

            const listUsersPage = limit == 0 ? listUsersResult : await admin.auth().listUsers(limit, offset.toString());
            const users = listUsersPage.users.map( user => {
                return {
                    uid: user.uid,
                    email: user.email,
                    displayName: user.displayName,
                    emailVerified: user.emailVerified,
                    disabled: user.disabled
                } as UserFirebaseInterface
            })

            return pageable.setContent(users, totalUsers);
        } catch (error: any){
            console.log(error)
            throw new Error((error as Error).message)
        }
    }

    async toggleUserAccount(uid: string = ''): Promise<boolean> {
        try {
            const user = await admin.auth().getUser(uid);
            await admin.auth().updateUser(uid, {
                disabled: !user.disabled
            });
            return true;
        } catch (error: any) {
            throw new Error((error as Error).message)
        }
    }

    async findUserByEmail(email: string = ''): Promise<RowDataPacket> {
        try {
            const [result] =  await pool.query('SELECT * FROM People WHERE email = ? limit 1', [email])
            const rows = result as RowDataPacket[]
            if (rows.length === 0) throw new Error('User not found');
            return rows[0]
        } catch (error: any) {
            throw new Error((error as Error).message)
        }
    }

    async existsUserByUid(uid: string = ''): Promise<boolean> {
        try {
            const [result] =  await pool.query('SELECT * FROM People WHERE uid = ? limit 1', [uid])
            const rows = result as RowDataPacket[]
            return rows.length > 0;
        } catch (error: any) {
            throw new Error((error as Error).message)
        }
    }

    async existsCustomerById(id: string = ''): Promise<boolean> {
        try {
            const [result] =  await pool.query('SELECT * FROM Customers WHERE no_customer = ? limit 1', [id])
            const rows = result as RowDataPacket[]
            return rows.length > 0;
        } catch (error: any) {
            throw new Error((error as Error).message)
        }
    }

    async existsUserByEmail(email: string = ''): Promise<boolean> {
        try {
            const [result] =  await pool.query('SELECT * FROM People WHERE email = ? limit 1', [email])
            const rows = result as RowDataPacket[]
            return rows.length > 0;
        } catch (error: any) {
            throw new Error((error as Error).message)
        }
    }

    async existsUserByPhone(phone: string = ''): Promise<boolean> {
        try {
            const [result] =  await pool.query('SELECT * FROM People WHERE phone = ? limit 1', [phone])
            const rows = result as RowDataPacket[]
            return rows.length > 0;
        } catch (error: any) {
            throw new Error((error as Error).message)
        }
    }

    async existsUserByCurp(curp: string = ''): Promise<boolean> {
        try {
            const [result] =  await pool.query('SELECT * FROM People WHERE curp = ? limit 1', [curp])
            const rows = result as RowDataPacket[]
            return rows.length > 0;
        } catch (error: any) {
            throw new Error((error as Error).message)
        }
    }

    async existsUserByEmailWithDifferentUid(email: string = '', uid: string = ''): Promise<boolean> {
        try {
            const [result] =  await pool.query('SELECT * FROM People WHERE email = ? AND uid != ? limit 1', [email, uid])
            const rows = result as RowDataPacket[]
            return rows.length > 0;
        } catch (error: any) {
            throw new Error((error as Error).message)
        }
    }

    async existsUserByPhoneWithDifferentUid(phone: string = '', uid: string = ''): Promise<boolean> {
        try {
            const [result] =  await pool.query('SELECT * FROM People WHERE phone = ? AND uid != ? limit 1', [phone, uid])
            const rows = result as RowDataPacket[]
            return rows.length > 0;
        } catch (error: any) {
            throw new Error((error as Error).message)
        }
    }

    async existsUserByCurpWithDifferentUid(curp: string = '', uid: string = ''): Promise<boolean> {
        try {
            const [result] =  await pool.query('SELECT * FROM People WHERE curp = ? AND uid != ? limit 1', [curp, uid])
            const rows = result as RowDataPacket[]
            return rows.length > 0;
        } catch (error: any) {
            throw new Error((error as Error).message)
        }
    }

}