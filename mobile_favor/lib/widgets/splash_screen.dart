import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      _getSession().then((isLoggedIn) {
        if (isLoggedIn) {
          Navigator.pushReplacementNamed(context, '/navigation');
        } else {
          Navigator.pushReplacementNamed(context, '/login');
        }
      });
    });
  }

  Future<bool> _getSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', height: 200),
            const SizedBox(height: 20),
            Text('Quick Favor', style: TextStyle(fontSize: 24, color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
