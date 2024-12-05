import {Router, Request, Response, NextFunction} from "express";
import {checkRole, validateJWT, validateMiddlewares} from "../../../commons/middleware";
import {
    acceptFavor, cancelFavor,
    createFavor, getDetailsFavor,
    monitorConnections, readCourierHistory, readCustomerHistory, readNotifications, rejectFavor,
    setupStatusSSE,
    updateCourierStatus
} from "../controller/favor.controller";
import {check} from "express-validator";

const FavorRouter = Router();

FavorRouter.post('/',[
    validateJWT,
    checkRole(['Customer']),
    check('id_customer').isString().notEmpty(),
    check('id_customer').isLength({min: 5, max: 100}),
    check('customer_direction.lat').isNumeric(),
    check('customer_direction.lng').isNumeric(),
    check('customer_direction.name').isString().notEmpty(),
    check('customer_direction.name').isLength({min: 5, max: 100}),
    check('collection_points').isArray(),
    check('collection_points.*.lat').isNumeric(),
    check('collection_points.*.lng').isNumeric(),
    check('collection_points.*.name').isString().notEmpty(),
    check('collection_points.*.name').isLength({min: 5, max: 100}),
    check('products').isArray(),
    check('products.*.name').isString().notEmpty(),
    check('products.*.name').isLength({min: 5, max: 100}),
    check('products.*.description').isString().notEmpty(),
    check('products.*.description').isLength({min: 5, max: 100}),
    check('products.*.amount').isNumeric(),
    validateMiddlewares
    ],
    createFavor
);


FavorRouter.get('/status/:id',[
    validateJWT,
    checkRole(['Courier', 'Customer']),
    check('id').isString().notEmpty(),
    check('id').isLength({min: 3, max: 100}),
    validateMiddlewares
    ],
    setupStatusSSE
);

FavorRouter.get('/details/:no_order',[
    validateJWT,
    checkRole(['Courier', 'Customer']),
    check('no_order').isString().notEmpty(),
    check('no_order').isLength({min: 3, max: 100}),
    validateMiddlewares
    ],
    getDetailsFavor
);

FavorRouter.put('/status/:id',[
    validateJWT,
    checkRole(['Courier']),
    check('id').isString().notEmpty(),
    check('newStatus').isIn(['Pending', 'In shopping', 'In delivery', 'Finished', 'Canceled']),
    check('cost').optional().isNumeric(),
    check('cost').optional().isLength({min: 1, max: 10}),
    check('receipt').optional().isBase64(),
    validateMiddlewares
    ],
    updateCourierStatus
);

FavorRouter.put('/accept/:no_order',[
    validateJWT,
    checkRole(['Courier']),
    check('no_order').isString().notEmpty(),
    check('no_order').isLength({min: 3, max: 100}),
    check('location').isObject(),
    check('location.lat').isNumeric(),
    check('location.lng').isNumeric(),
    check('courier_id').isString().notEmpty(),
    check('courier_id').isLength({min: 3, max: 100}),
    validateMiddlewares
    ],
    acceptFavor
);

FavorRouter.put('/reject/:id_order',[
    validateJWT,
    checkRole(['Courier']),
    check('id_order').isString().notEmpty(),
    check('id_order').isLength({min: 3, max: 100}),
    check('courier_id').isString().notEmpty(),
    check('courier_id').isLength({min: 3, max: 100}),
    validateMiddlewares
    ],
    rejectFavor
);

FavorRouter.put('/cancel/:no_order',[
    validateJWT,
    checkRole(['Courier']),
    check('no_order').isString().notEmpty(),
    check('no_order').isLength({min: 3, max: 100}),
    validateMiddlewares
    ],
    cancelFavor
);

FavorRouter.get('/notification/:no_courier', [
    validateJWT,
    checkRole(['Courier']),
    check('no_courier').isString().notEmpty(),
    check('no_courier').isLength({min: 3, max: 100}),
    validateMiddlewares
], readNotifications);

FavorRouter.get('/history-courier/:no_courier', [
    validateJWT,
    checkRole(['Courier']),
    check('no_courier').isString().notEmpty(),
    check('no_courier').isLength({min: 3, max: 100}),
    validateMiddlewares
], readCourierHistory);

FavorRouter.get('/history-customer/:no_customer', [
    validateJWT,
    checkRole(['Customer']),
    check('no_customer').isString().notEmpty(),
    check('no_customer').isLength({min: 3, max: 100}),
    validateMiddlewares
], readCustomerHistory);

FavorRouter.get('/connection', monitorConnections);

export {
    FavorRouter
}