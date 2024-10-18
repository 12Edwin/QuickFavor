import 'package:flutter/material.dart';
import 'package:mobile_favor/modules/points/screens/map_customer.dart';
import 'package:mobile_favor/navigation/courier/profile_courier.dart';
import 'package:mobile_favor/navigation/customer/profile_customer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0;
  String _role = 'customer';
  final List<Widget> _courierWidgets = [
    const Placeholder(),
    const Placeholder(),
    const Placeholder(),
    const ProfileCourier()
  ];
  final List<Widget> _customerWidgets = [
    const MapCustomer(),
    const Placeholder(),
    const Placeholder(),
    const ProfileCustomer()
  ];

  @override
  void initState() {
    super.initState();
    _getRole();
  }

  void _getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _role = prefs.getString('role') ?? 'customer';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: _role == 'courier' ? courierTabs() : customerTabs(),
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: _role == 'courier'
          ? _courierWidgets[_selectedIndex]
          : _customerWidgets[_selectedIndex],
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<BottomNavigationBarItem> courierTabs() {
    return [
      const BottomNavigationBarItem(
          icon: Icon(Icons.location_on), label: 'Lugares'),
      const BottomNavigationBarItem(
          icon: Icon(Icons.notifications), label: 'Favores'),
      const BottomNavigationBarItem(
          icon: Icon(Icons.history), label: 'Historial'),
      const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil')
    ];
  }

  List<BottomNavigationBarItem> customerTabs() {
    return [
      const BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Locales'),
      const BottomNavigationBarItem(
          icon: Icon(Icons.add_circle), label: 'Nuevo favor'),
      const BottomNavigationBarItem(
          icon: Icon(Icons.history), label: 'Historial'),
      const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil')
    ];
  }
}
