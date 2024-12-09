import { Request, Response } from 'express';
import { NotificationService } from '../../../commons/notificationService';
import { connectionManager } from './connection.manager';
import {
    cancelOrder,
    checkOrderStatus,
    countProducts,
    findNearbyDrivers, getOrderCreatedAt,
    hasDriverNotified,
    updateCourierLocation
} from "../repository/location.repository";
import {Response200, Response400, ResponseApi} from "../../../commons/TypeResponse";
import {validateError} from "../../../commons/TypeError";

const notificationService = new NotificationService();

export const searchForCouriers = async (req: Request, res: Response) => {
  const { no_order, delivery_point, distance_km } = req.body;
  const searchIntervalMs = 5000;
  const connectionId = `order-${no_order}`;
  let lastStatus: any = null;
  let intervalId: NodeJS.Timeout;

  // Setup SSE headers
  res.writeHead(200, {
    'Content-Type': 'text/event-stream',
    'Cache-Control': 'no-cache',
    'Connection': 'keep-alive'
  });

  // Handle client disconnect
  req.on('close', () => {
    if (intervalId) {
      clearInterval(intervalId);
    }
    connectionManager.removeConnection(connectionId);
  });

  const conn = connectionManager.getConnection(connectionId);
  if (conn) {
    lastStatus = conn.lastStatus;
  }

  const sendStatus = async () => {
    try {
      const order = await countProducts(no_order);
      if (!order) {
        if (intervalId) {
          clearInterval(intervalId);
        }
        connectionManager.removeConnection(connectionId);
        const response = Response200({ status: 'Order not found' });
        res.write(`${JSON.stringify(response)}\n\n`);
        setTimeout(() => {
          connectionManager.removeConnection(connectionId);
          res.end();
        }, 100);
        return;
      }

      const createdAt = await getOrderCreatedAt(no_order);
      const searchTimeoutMs = 10 * 60 * 1000; // 10 minutes
      const elapsedTime = Date.now() - new Date(createdAt).getTime();
      const remainingTime = searchTimeoutMs - elapsedTime;

      if (remainingTime <= 0) {
        if (intervalId) {
          clearInterval(intervalId);
        }
        await cancelOrder(no_order);

        lastStatus = {
          status: 'Timeout',
          timeout: 0
        };
        const response = Response200(lastStatus);
        res.write(`${JSON.stringify(response)}\n\n`);

        setTimeout(() => {
          connectionManager.removeConnection(connectionId);
          res.end();
        }, 100);
        return;
      }

      const nearbyDrivers = await findNearbyDrivers(
        delivery_point.lat,
        delivery_point.lng,
        distance_km
      );

      for (const driver of nearbyDrivers) {
        if (!await hasDriverNotified(driver.no_courier, order.no_order)) {
          await notificationService.sendOrderNotification(driver.no_courier, driver.distance_km, order);
        }
      }

      const orderStatus = await checkOrderStatus(order.no_order);

      if (orderStatus.status === 'In shopping') {
        if (intervalId) {
          clearInterval(intervalId);
        }
        lastStatus = {
          status: 'In shopping',
          timeout: remainingTime
        };
        const response = Response200(lastStatus);
        res.write(`${JSON.stringify(response)}\n\n`);

        setTimeout(() => {
          connectionManager.removeConnection(connectionId);
          res.end();
        }, 100);
        return;
      }

      lastStatus = {
        timeout: remainingTime,
        status: 'SEARCHING'
      };
      const response: ResponseApi<any> = Response200(lastStatus);
      res.write(`${JSON.stringify(response)}\n\n`);

    } catch (error) {
      console.error('Error in searchForCouriers:', error);
      if (intervalId) {
        clearInterval(intervalId);
      }

      const e: ResponseApi<any> = validateError(error as Error);
      if (!res.headersSent) {
        res.write(`${JSON.stringify(e)}\n\n`);

        setTimeout(() => {
          connectionManager.removeConnection(connectionId);
          res.end();
        }, 100);
      }
    }
  };

  intervalId = setInterval(sendStatus, searchIntervalMs);

  if (!conn) {
    connectionManager.addConnection(connectionId, res, intervalId, no_order, lastStatus);
  }

  await sendStatus();
};

export const updateDriverLocation = async (req: Request, res: Response): Promise<void> => {
  const driver = req.body;

  try {
    await updateCourierLocation(driver);
    const response: ResponseApi<any> = Response200({ message: 'Location updated successfully' });
    res.status(200).json(response);

  } catch (error) {
    console.error('Error updating driver location:', error);
    const e: ResponseApi<any> = validateError(error as Error);
    res.status(e.code).json(e);
  }
};