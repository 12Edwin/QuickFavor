import Flutter
import UIKit
import GoogleMaps
import FirebaseCore
import FirebaseMessaging
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Configura Google Maps API Key
        GMSServices.provideAPIKey("AIzaSyAj46z7bL0N1cRGIslQI0xf5q8Jn6hnpDI")

        // Configura Firebase
        FirebaseApp.configure()

        // Solicita permisos de notificaciones push
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { granted, error in
                    print("Permisos otorgados: \(granted)")
                })
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()

        // Registrar los plugins de Flutter
        GeneratedPluginRegistrant.register(with: self)

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // Manejo del token de APNs para Firebase
    override func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Messaging.messaging().apnsToken = deviceToken
        print("APNs Token registrado: \(deviceToken.map { String(format: "%02.2hhx", $0) }.joined())")
    }

    // Manejo de errores al registrar el dispositivo para notificaciones push
    override func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("Error al registrar para notificaciones: \(error.localizedDescription)")
    }
}