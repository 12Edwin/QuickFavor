import 'package:flutter/material.dart';
import 'package:mobile_favor/modules/points/screens/map_courier.dart';
import 'package:mobile_favor/modules/points/screens/map_customer.dart';
import 'package:mobile_favor/navigation/courier/favor_progress_courier.dart';
import 'package:mobile_favor/navigation/courier/notifications.dart';
import 'package:mobile_favor/navigation/courier/profile_courier.dart';
import 'package:mobile_favor/navigation/customer/create_order.dart';
import 'package:mobile_favor/navigation/customer/favor_progress_customer.dart';
import 'package:mobile_favor/navigation/customer/history_order.dart';
import 'package:mobile_favor/navigation/customer/profile_customer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Navigation extends StatefulWidget {
  final int? tap;
  const Navigation({super.key, this.tap});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0;
  String _role = '';
  String _noOrder = '';
  bool _thereIsFavor = false;

  late List<Widget> _courierWidgets = [];
  late List<Widget> _customerWidgets = [];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.tap ?? 0;
    _getRole();
    initCourierWidgets();
    initCustomerWidgets();
  }

  void _getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _role = prefs.getString('role') ?? 'Customer';
    });
  }

  void initCourierWidgets() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _courierWidgets = [
        prefs.getString('no_order') != null ? const FavorProgressCourier() : const MapCourier(),
        const Notifications(),
        const Placeholder(),
        const ProfileCourier()
      ];
    });
  }

  void initCustomerWidgets() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _customerWidgets = [
        prefs.getString('no_order') != null
            ? const FavorProgressCustomer()
            : const MapCustomer(),
        const CreateOrder(),
        const HistoryOrder(),
        const ProfileCustomer()
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: _role == 'Courier' ? courierTabs() : customerTabs(),
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: _role == 'Courier'
          ? (_courierWidgets.isNotEmpty
              ? _courierWidgets[_selectedIndex]
              : Container())
          : (_customerWidgets.isNotEmpty
              ? _customerWidgets[_selectedIndex]
              : Container()),
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