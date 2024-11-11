import {checkRole, validateJWT, validateMiddlewares} from "../../../commons/middleware";
import {check} from "express-validator";
import {editCustomerProfile, getCustomerProfile} from "../controller/customer.controller";
import {Router} from "express";

const CustomerRouter = Router();

CustomerRouter.get('/profile/:uid', [
    validateJWT,
    checkRole(['Courier']),
    check('uid').isString().notEmpty(),
    check('uid').isLength({min: 5, max: 50}),
    validateMiddlewares
], getCustomerProfile);

CustomerRouter.put('/profile', [
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
    check('direction', 'missing direction').not().isEmpty(),
    check('direction', 'invalid direction').isLength({min: 5, max: 100}),
    check('phone', 'missing phone').not().isEmpty(),
    check('phone', 'invalid phone').matches(/^\d{10}$/),
    validateMiddlewares
], editCustomerProfile);

export {
    CustomerRouter
}