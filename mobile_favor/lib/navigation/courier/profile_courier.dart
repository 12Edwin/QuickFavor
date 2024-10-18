import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileCourier extends StatefulWidget {
  const ProfileCourier({super.key});

  @override
  State<ProfileCourier> createState() => _ProfileCourierState();
}

class _ProfileCourierState extends State<ProfileCourier> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Perfil'),
          ElevatedButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove('isLoggedIn');
              prefs.remove('role');
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text('Cerrar sesión')
          )
        ]
      )
    );
  }
}
