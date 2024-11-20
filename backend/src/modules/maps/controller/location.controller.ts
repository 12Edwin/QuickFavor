import { Request, Response } from 'express';
import { NotificationService } from '../../../commons/notificationService';
import { connectionManager } from './connection.manager';
import {
  cancelOrder,
  checkOrderStatus,
  countProducts,
  findNearbyDrivers,
  hasDriverNotified,
  updateCourierLocation
} from "../repository/location.repository";
import {Response200, Response400, ResponseApi} from "../../../commons/TypeResponse";
import {validateError} from "../../../commons/TypeError";

const notificationService = new NotificationService();

export const searchForCouriers = async (req: Request, res: Response) => {
  const { no_order, delivery_point, distance_km } = req.body;
  let searchTimeoutMs = 10 * 60 * 1000; // 10 minutes
  const searchIntervalMs = 5000;
  const startTime = Date.now();
  const connectionId = `order-${no_order}`;
  let lastStatus: any = null;

  res.writeHead(200, {
    'Content-Type': 'text/event-stream',
    'Cache-Control': 'no-cache',
    'Connection': 'keep-alive'
  });

  const conn = connectionManager.getConnection(connectionId);
  if (conn) {
    searchTimeoutMs = conn.lastStatus.timeout || 0
    lastStatus = conn.lastStatus
  }

  const sendStatus = async () => {
    try {

      const order = await countProducts(no_order);
      if (!order) {
        connectionManager.removeConnection(connectionId);
        res.end();
        throw new Error('Order not found');
      }

      const nearbyDrivers = await findNearbyDrivers(
        delivery_point.lat,
        delivery_point.lng,
        distance_km
      );

      for (const driver of nearbyDrivers) {
        console.log(driver)
        if (! await hasDriverNotified(driver.no_courier, order.no_order)) {
          await notificationService.sendOrderNotification(driver.no_courier, driver.distance_km, order);
        }
      }

      const orderStatus = await checkOrderStatus(order.no_order);
      if (orderStatus.status === 'In shopping') {
        lastStatus = {
          courier_id: orderStatus.id_courier,
          status: 'In shopping',
          courier_name: orderStatus.name,
          timeout: searchTimeoutMs - (Date.now() - startTime)
        };
        const response = Response200(lastStatus);
        res.write(`data: ${JSON.stringify(response)}\n\n`);
        connectionManager.removeConnection(connectionId);
        res.end();
        return;
      }

      if (Date.now() - startTime >= searchTimeoutMs) {
        await cancelOrder(no_order);

        connectionManager.removeConnection(connectionId);
        res.end();
        throw new Error('Time to accept is over');
      }else {
        lastStatus = {
            timeout: searchTimeoutMs - (Date.now() - startTime),
            status: 'SEARCHING'
          };
        const response: ResponseApi<any> = Response200(lastStatus);
        res.write(`data: ${JSON.stringify(response)}\n\n`);
      }
    } catch (error) {
      console.error('Error in searchForCouriers:', error);
      const e: ResponseApi<any> = validateError(error as Error);
      res.write(`data: ${JSON.stringify(e)}\n\n`);
      connectionManager.removeConnection(connectionId);
      res.end();
    }
  };

  const intervalId = setInterval(sendStatus, searchIntervalMs);
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