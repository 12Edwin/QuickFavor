import {Router} from "express";
import {check} from "express-validator"
import {checkRole, validateJWT, validateMiddlewares} from "../../../commons/middleware";
import {changeCourierStatus, editCourierProfile, getCourierProfile} from "../controller/courier.controller";
const CourierRouter = Router();

CourierRouter.get('/profile/:uid', [
    validateJWT,
    checkRole(['Courier']),
    check('uid').isString().notEmpty(),
    check('uid').isLength({min: 5, max: 50}),
    validateMiddlewares
], getCourierProfile);

CourierRouter.put('/profile', [
    validateJWT,
    checkRole(['Courier']),
    check('email', 'missing email').not().isEmpty(),
    check('email', 'invalid email').isEmail(),
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
    check('vehicle_type', 'missing vehicle type').not().isEmpty(),
    check('vehicle_type', 'invalid vehicle type').isIn(['Carro', 'Moto', 'Bicicleta', 'Scouter', 'Caminando', 'Otro']),
    check('license_plate', 'missing license plate').not().isEmpty(),
    check('license_plate', 'invalid license plate').matches(/^[A-Z0-9-]+$/),
    check('face_photo', 'missing face photo').not().isEmpty(),
    check('face_photo', 'invalid face photo').isBase64(),
    check('INE_photo', 'missing INE photo').not().isEmpty(),
    check('INE_photo', 'invalid INE photo').isBase64(),
    check('plate_photo').optional().isBase64().withMessage('invalid plate photo'),
    check('phone', 'missing phone').not().isEmpty(),
    check('phone', 'invalid phone').matches(/^\d{10}$/),
    validateMiddlewares
], editCourierProfile);

CourierRouter.put('/status/:uid', [
    validateJWT,
    checkRole(['Courier']),
    check('status').isIn(['Available', 'Busy', 'Out of service']),
    check('uid').isString().notEmpty(),
    check('uid').isLength({min: 5, max: 100}),
    validateMiddlewares
], changeCourierStatus);

export {CourierRouter}