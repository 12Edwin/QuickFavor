import {Router} from "express";
import {checkRole, validateJWT, validateMiddlewares} from "../../../commons/middleware";
import {check} from "express-validator";
import {searchForCouriers, updateDriverLocation} from "../controller/location.controller";

const LocationRouter = Router();

LocationRouter.post('/search',[
    validateJWT,
    checkRole(['Customer']),
    check('no_order').notEmpty(),
    check('no_order').isString(),
    check('no_order').isLength({min: 1, max: 10}),
    check('delivery_point').isObject(),
    check('delivery_point.lat').notEmpty(),
    check('delivery_point.lat').isNumeric(),
    check('delivery_point.lat').isLength({min: 1, max: 10}),
    check('delivery_point.lng').notEmpty(),
    check('delivery_point.lng').isNumeric(),
    check('delivery_point.lng').isLength({min: 1, max: 10}),
    check('distance_km').notEmpty(),
    check('distance_km').isNumeric(),
    check('distance_km').isLength({min: 1, max: 5}),
    validateMiddlewares
    ],
    searchForCouriers);

LocationRouter.post('/new-location',[
    validateJWT,
    checkRole(['Courier']),
    check('no_courier').notEmpty(),
    check('no_courier').isString(),
    check('no_courier').isLength({min: 1, max: 10}),
    check('lat').notEmpty(),
    check('lat').isNumeric(),
    check('lat').isLength({min: 1, max: 30}),
    check('lng').notEmpty(),
    check('lng').isNumeric(),
    check('lng').isLength({min: 1, max: 30}),
    validateMiddlewares
    ],
    updateDriverLocation);

export {LocationRouter};