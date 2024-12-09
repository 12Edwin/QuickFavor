import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseService {
  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp();

    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Permisos de notificación concedidos');
    }
  }

  static Future<String?> getFirebaseToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  static void configurePushNotifications() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Notificación recibida en primer plano: ${message.notification?.title}');
    });

    // Manejar cuando se hace tap en una notificación
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notificación abierta: ${message.notification?.title}');
      // Navegar a una pantalla específica si es necesario
    });
  }
}