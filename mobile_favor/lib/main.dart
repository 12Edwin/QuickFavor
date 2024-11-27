import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobile_favor/modules/points/screens/map_customer.dart';
import 'package:mobile_favor/navigation/courier/profile_courier.dart';
import 'package:mobile_favor/navigation/customer/create_order.dart';
import 'package:mobile_favor/utils/app_colors.dart';
import 'package:mobile_favor/widgets/splash_screen.dart';
import 'package:mobile_favor/modules/auth/Register.dart';
import 'package:mobile_favor/modules/auth/login.dart';
import 'package:mobile_favor/navigation/navigation.dart';
import 'config/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initializeFirebase();
  FirebaseService.configurePushNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const Login(),
        '/register': (context) => const Register(),
        '/profile': (context) => const ProfileCourier(),
        '/sarch_customer': (context) => const MapCustomer(),
        '/navigation': (context) => const Navigation(),
        '/create-order': (context) => const CreateOrder(),
      },
    );
  }
}
