import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileCustomer extends StatefulWidget {
  const ProfileCustomer({super.key});

  @override
  State<ProfileCustomer> createState() => _ProfileCustomerState();
}

class _ProfileCustomerState extends State<ProfileCustomer> {
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
