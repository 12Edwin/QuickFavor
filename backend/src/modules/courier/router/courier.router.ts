import {Router} from "express";
import {check} from "express-validator"
import {checkRole, validateJWT, validateMiddlewares} from "../../../commons/middleware";
import {
    changeCourierStatus,
    editCourierProfile,
    editVehicleCourier,
    getCourierProfile
} from "../controller/courier.controller";
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
    check('phone', 'missing phone').not().isEmpty(),
    check('phone', 'invalid phone').matches(/^\d{10}$/),
    validateMiddlewares
], editCourierProfile);

CourierRouter.put('/vehicle', [
    validateJWT,
    checkRole(['Courier']),
    check('brand').optional().isLength({ min: 3 }),
    check('model').optional().isLength({ min: 3 }),
    check('color').optional().isLength({ min: 3 }),
    check('description').optional().isLength({ min: 3 }),
    check('vehicle_type', 'missing vehicle type').not().isEmpty(),
    check('vehicle_type', 'invalid vehicle type').isIn(['Carro', 'Moto', 'Bicicleta', 'Scooter', 'Caminando', 'Otro']),
    check('license_plate', 'invalid license plate').optional().matches(/^[A-Z0-9]+-[A-Z0-9]+$/),
    check('plate_photo').optional().isBase64().withMessage('invalid plate photo'),
    ], editVehicleCourier);

CourierRouter.put('/status/:uid', [
    validateJWT,
    checkRole(['Courier']),
    check('status').isIn(['Available', 'Busy', 'Out of service']),
    check('uid').isString().notEmpty(),
    check('uid').isLength({min: 5, max: 100}),
    validateMiddlewares
], changeCourierStatus);

export {CourierRouter}