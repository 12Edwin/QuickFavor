import pool from "./connection-db";
import { RowDataPacket } from "mysql2";
import { messaging } from "./config-SDK";
import {messaging as mess} from "firebase-admin";
import Message = mess.Message;

export class NotificationService {
  async sendOrderNotification(driverId: string, distance: number, order: any) {
    try {
      const [rows] = await pool.query<RowDataPacket[]>(
        'SELECT fcm_token FROM Couriers WHERE no_courier = ?',
        [driverId]
      );

      const fcmToken = rows[0]?.fcm_token;
      if (!fcmToken) {
        return;
      }

      const message = {
        notification: {
          title: 'Nuevo pedido disponible',
          body: `Pedido con ${order.products} productos para recolección a ${distance} km de tí`
        },
        android: {
          priority: 'high',
          notification: {
            visibility: 'public',
            sound: 'default'
          }
        },
        data: {
          orderId: order.no_order,
          type: 'NEW_ORDER',
          products: order.products + "",
          foreground: 'true'
        },
        token: fcmToken
      } as Message;

      const response = await messaging.send(message);
      await pool.query(
        `INSERT INTO Notifications (courier_id, order_id, type, status) VALUES (?, ?, ?, ?);`,
        [driverId, order.no_order, 'Order', 'Pending']
      );

      return response;
    } catch (error) {
      console.error('Error sending notification:', error);
    }
  }
}