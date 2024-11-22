import {Router} from "express";
import {
        login, readUsers, recoveryPassword, courier_register,
        resetPassword, toggleUserAccount, customer_register
} from "../controller/auth.controller";
import {check} from "express-validator"
import {checkRole, validateJWT, validateMiddlewares} from "../../commons/middleware";
const AuthRouter = Router();

AuthRouter.post('/login', [
        check( 'email', 'missing email' ).not().isEmpty(),
        check( 'email', 'invalid email' ).isEmail(),
        check( 'password', 'missing password' ).not().isEmpty(),
        check( 'password', 'password must be at least 6 characters' ).isLength({ min: 6 }),
        validateMiddlewares
        ], login);

AuthRouter.post('/courier-register', [
    check('email', 'missing email').not().isEmpty(),
    check('email', 'invalid email').isEmail(),
    check('password', 'missing password').not().isEmpty(),
    check('password', 'password must be at least 6 characters').isLength({ min: 6 }),
    check('name')
        .isLength({ min: 3 }).withMessage('name must be at least 3 characters')
        .matches(/^[a-zA-ZÀ-ÿ\u00f1\u00d1\u00fc\u00dc\s]+$/).withMessage('name must not contain numbers or special characters'),
    check('surname')
        .isLength({ min: 3 }).withMessage('surname must be at least 3 characters')
        .matches(/^[a-zA-ZÀ-ÿ\u00f1\u00d1\u00fc\u00dc\s]+$/).withMessage('surname must not contain numbers or special characters'),
    check('lastname')
        .optional()
        .isLength({ min: 3 }).withMessage('lastname must be at least 3 characters')
        .matches(/^[a-zA-ZÀ-ÿ\u00f1\u00d1\u00fc\u00dc\s]+$/).withMessage('lastname must not contain numbers or special characters'),
    check('CURP', 'missing CURP').not().isEmpty(),
    check('CURP', 'invalid CURP').matches(/^[A-Z]{4}\d{6}[A-Z]{6}\d{2}$/),
    check('vehicle_type', 'missing vehicle type').not().isEmpty(),
    check('vehicle_type', 'invalid vehicle type').isIn(['Carro', 'Moto', 'Bicicleta', 'Scouter', 'Caminando', 'Otro']),
    check('brand').optional().isLength({ min: 3 }),
    check('model').optional().isLength({ min: 3 }),
    check('color').optional().isLength({ min: 3 }),
    check('license_plate', 'missing license plate').not().isEmpty(),
    check('license_plate', 'invalid license plate').matches(/^[A-Z0-9-]+$/),
    check('face_photo', 'missing face photo').not().isEmpty(),
    check('face_photo', 'invalid face photo').isBase64(),
    check('INE_photo', 'missing INE photo').not().isEmpty(),
    check('INE_photo', 'invalid INE photo').isBase64(),
    check('plate_photo').optional().isBase64().withMessage('invalid plate photo'),
    check('phone', 'missing phone').not().isEmpty(),
    check('phone', 'invalid phone').matches(/^\d{10}$/),
    check('sex', 'missing sex').not().isEmpty(),
    check('sex', 'invalid sex').isIn(['Masculino', 'Femenino']),
    validateMiddlewares
], courier_register);

AuthRouter.post('/customer-register', [
    check('email', 'missing email').not().isEmpty(),
    check('email', 'invalid email').isEmail(),
    check('password', 'missing password').not().isEmpty(),
    check('password', 'password must be at least 6 characters').isLength({ min: 6 }),
    check('name')
        .notEmpty()
        .isLength({ min: 3 }).withMessage('name must be at least 3 characters')
        .matches(/^[a-zA-ZÀ-ÿ\u00f1\u00d1\u00fc\u00dc\s]+$/).withMessage('name must not contain numbers or special characters'),
    check('surname')
        .notEmpty()
        .isLength({ min: 3 }).withMessage('surname must be at least 3 characters')
        .matches(/^[a-zA-ZÀ-ÿ\u00f1\u00d1\u00fc\u00dc\s]+$/).withMessage('surname must not contain numbers or special characters'),
    check('lastname')
        .optional()
        .isLength({ min: 3 }).withMessage('lastname must be at least 3 characters')
        .matches(/^[a-zA-ZÀ-ÿ\u00f1\u00d1\u00fc\u00dc\s]+$/).withMessage('lastname must not contain numbers or special characters'),
    check('CURP', 'missing CURP').not().isEmpty(),
    check('CURP', 'invalid CURP').matches(/^[A-Z]{4}\d{6}[A-Z]{6}\d{2}$/),
    check('phone', 'missing phone').not().isEmpty(),
    check('phone', 'invalid phone').matches(/^\d{10}$/),
    check('sex', 'missing sex').not().isEmpty(),
    check('sex', 'invalid sex').isIn(['Masculino', 'Femenino']),
    check('direction', 'missing direction').not().isEmpty(),
    check('direction', 'invalid direction').isLength({ min: 3, max: 1000 }),
    check('lat', 'missing latitude').not().isEmpty(),
    check('lat', 'invalid latitude').isNumeric(),
    check('lng', 'missing longitude').not().isEmpty(),
    check('lng', 'invalid longitude').isNumeric(),
    validateMiddlewares
], customer_register);

AuthRouter.post('/customer-register', [
        check( 'email', 'missing email' ).not().isEmpty(),
        check( 'email', 'invalid email' ).isEmail(),
        check( 'password', 'missing password' ).not().isEmpty(),
        check( 'password', 'password must be at least 6 characters' ).isLength({ min: 6 }),
        check( 'name', 'missing name' ).not().isEmpty(),
        check( 'surname', 'missing surname' ).not().isEmpty(),
        validateMiddlewares
        ], customer_register);

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

        ])

AuthRouter.delete('/user:uid', [
        validateJWT,
        check('uid', 'missing uid').not().isEmpty(),
        check('uid', 'invalid uid').isString(),
        ], toggleUserAccount)

AuthRouter.get('/users', [
        validateJWT,
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