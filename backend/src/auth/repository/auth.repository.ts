import {LoginRequest, LoginResponse} from "../interface/login.interface";
import {admin, auth} from  "../../commons/config-SDK";
import {signInWithEmailAndPassword, getAuth, sendEmailVerification, sendPasswordResetEmail, User} from 'firebase/auth';
import {getAuth as getAuth2} from 'firebase-admin/auth';
import pool from "../../commons/connection-db";
import {UserInterface} from "../interface/user.interface";
import {ResetInterface} from "../interface/reset.interface";
import {Pageable, PaginationResult} from "../../commons/Pageable";
import {UserFirebaseInterface} from "../interface/userFirebase.interface";
import {RowDataPacket} from "mysql2";
import {encrypt} from "../../commons/crypt-config";
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
                const userData = {
                    uid: user.uid,
                    email: user.email,
                    name: user.displayName,
                    role: userDB.role
                };
                return new Promise( (res)=> res({ user: userData, isEmailVerified: true, token: encryptedToken, } as LoginResponse) );
            } else {
                throw new Error('Email not verified');
            }
        }catch (error: any){
            console.log(error)
            if (error.code.includes('auth/invalid-credential')){
                throw new Error('Invalid credentials');
            }
            if (error.code.includes('auth/user-not-found')){
                throw new Error('User not found');
            }
            if (error.code.includes('auth/user-disabled')){
                throw new Error('User disabled');
            }
            throw new Error((error as Error).message)
        }
    }

    async register(payload: UserInterface): Promise<boolean> {
        try {
            const { email, password, name, surname , role} = payload;

            const userRecord = await admin.auth().createUser({
                email,
                password,
                displayName: name,
                emailVerified: false
            });

            const auth = getAuth();
            const userCredential = await signInWithEmailAndPassword(auth, email, password);
            await sendEmailVerification(userCredential.user);

            await pool.query(
                'INSERT INTO users (firebase_uid, email, name, surname, role) VALUES (?, ?, ?, ?, ?)',
                [userRecord.uid, email, name, surname, role]
            );

            return true;
        } catch (error: any) {
            if (error.code.includes('auth/email-already-exists')){
                throw new Error('Email already exists');
            }
            throw new Error((error as Error).message)
        }
    }

    async resetPassword(payload: ResetInterface): Promise<boolean> {
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

    async existsUserByUid(uid: string = ''): Promise<boolean> {
        try {
            const [result] =  await pool.query('SELECT * FROM users WHERE firebase_uid = ? limit 1', [uid])
            const rows = result as RowDataPacket[]
            return rows.length > 0;
        } catch (error: any) {
            throw new Error((error as Error).message)
        }
    }

    async findUserByEmail(email: string = ''): Promise<RowDataPacket> {
        try {
            const [result] =  await pool.query('SELECT * FROM users WHERE email = ? limit 1', [email])
            const rows = result as RowDataPacket[]
            if (rows.length === 0) throw new Error('User not found');
            return rows[0]
        } catch (error: any) {
            throw new Error((error as Error).message)
        }
    }

}