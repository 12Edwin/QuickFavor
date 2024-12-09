import {checkRole, validateJWT, validateMiddlewares} from "../../../commons/middleware";
import {check} from "express-validator";
import {editCustomerProfile, getCustomerProfile} from "../controller/customer.controller";
import {Router} from "express";

const CustomerRouter = Router();

CustomerRouter.get('/profile/:uid', [
    validateJWT,
    checkRole(['Customer']),
    check('uid').isString().notEmpty(),
    check('uid').isLength({min: 5, max: 50}),
    validateMiddlewares
], getCustomerProfile);

CustomerRouter.put('/profile', [
    validateJWT,
    checkRole(['Customer']),
    check('lat', 'missing lat').not().isEmpty(),
    check('lat', 'invalid lat').isNumeric(),
    check('lng', 'missing lng').not().isEmpty(),
    check('lng', 'invalid lng').isNumeric(),
    check('phone', 'missing phone').not().isEmpty(),
    check('phone', 'invalid phone').matches(/^\d{10}$/),
    validateMiddlewares
], editCustomerProfile);

export {
    CustomerRouter
}