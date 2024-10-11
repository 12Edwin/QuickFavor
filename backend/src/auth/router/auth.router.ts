import {Router} from "express";
import {
        login,
        readUsers,
        recoveryPassword,
        register,
        resetPassword,
        toggleUserAccount
} from "../controller/auth.controller";
import {check} from "express-validator"
import {checkAdminRole, validateJWT, validateMiddlewares} from "../../commons/middleware";
const AuthRouter = Router();

AuthRouter.post('/login', [
        check( 'email', 'missing email' ).not().isEmpty(),
        check( 'email', 'invalid email' ).isEmail(),
        check( 'password', 'missing password' ).not().isEmpty(),
        check( 'password', 'password must be at least 6 characters' ).isLength({ min: 6 }),
        validateMiddlewares
        ], login);

AuthRouter.post('/register', [
        check( 'email', 'missing email' ).not().isEmpty(),
        check( 'email', 'invalid email' ).isEmail(),
        check( 'password', 'missing password' ).not().isEmpty(),
        check( 'password', 'password must be at least 6 characters' ).isLength({ min: 6 }),
        check( 'name', 'missing name' ).not().isEmpty(),
        check( 'surname', 'missing surname' ).not().isEmpty(),
        validateMiddlewares
        ], register);

AuthRouter.post('/reset-password', [
        validateJWT,
        check('new_pass', 'missing new password').not().isEmpty(),
        check('new_pass', 'new password must be at least 6 characters').isLength({ min: 6 }),
        validateMiddlewares
        ], resetPassword);

AuthRouter.post('/recover-account', [
        check('email', 'missing email').not().isEmpty(),
        check('email', 'invalid email').isEmail(),
        validateMiddlewares
        ], recoveryPassword);

AuthRouter.post('/recover-password', [
        check
        ])

AuthRouter.delete('/user:uid', [
        validateJWT,
        checkAdminRole,
        check('uid', 'missing uid').not().isEmpty(),
        check('uid', 'invalid uid').isString(),
        ], toggleUserAccount)

AuthRouter.get('/users', [
        validateJWT,
        checkAdminRole,
        check('page', 'missing page').not().isEmpty(),
        check('page', 'page must be a number').isNumeric(),
        check('page', 'minimum page is 1').isInt({ min: 1 }),
        check('page', 'maximum page is 100').isInt({ max: 100 }),
        check('size', 'missing size').not().isEmpty(),
        check('size', 'size must be a number').isNumeric(),
        check('size', 'minimum size is 0').isInt({ min: 0 }),
        check('size', 'maximum size is 100').isInt({ max: 100 }),
        validateMiddlewares
        ], readUsers);

export default AuthRouter;