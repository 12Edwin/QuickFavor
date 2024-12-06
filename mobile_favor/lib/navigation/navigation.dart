import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile_favor/kernel/widget/chat.dart';
import 'package:mobile_favor/modules/points/screens/map_courier.dart';
import 'package:mobile_favor/modules/points/screens/map_customer.dart';
import 'package:mobile_favor/navigation/courier/favor_progress_courier.dart';
import 'package:mobile_favor/navigation/courier/history_courier.dart';
import 'package:mobile_favor/navigation/courier/notifications.dart';
import 'package:mobile_favor/navigation/courier/profile_courier.dart';
import 'package:mobile_favor/navigation/customer/create_order.dart';
import 'package:mobile_favor/navigation/customer/favor_progress_customer.dart';
import 'package:mobile_favor/navigation/customer/history_order.dart';
import 'package:mobile_favor/navigation/customer/profile_customer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/alerts.dart';
import '../config/utils.dart';
import 'customer/entity/location.entity.dart';
import 'customer/service/favor.service.dart';

class Navigation extends StatefulWidget {
  final int? tap;
  const Navigation({super.key, this.tap});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0;
  String _role = '';
  Timer? _timer;
  DateTime? _lastPressedTime;

  late List<Widget> _courierWidgets = [];
  late List<Widget> _customerWidgets = [];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.tap ?? 0;
    _getRole();
    initCourierWidgets();
    initCustomerWidgets();

    (() async {
      bool result = await getStorageAvailability();
      if (result) {
        _startTimer();
      }else{
        _stopTimer();
      }
    })();
  }

  void onSwitchChanged(bool value) async {
    await toggleStorageAvailability(value);
    if (value) {
      _startTimer();
    } else {
      _stopTimer();
    }
  }

  void _startTimer() async {
    _stopTimer();
    _updateService();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      _updateService();
    });
  }

  void _updateService() async {
    final FavorService _favorService = FavorService(context);
    final String? no_courier = await getStorageNoUser();
    Position position = await _getCurrentLocation();
    UpdateLocationEntity location = UpdateLocationEntity(
      no_courier: no_courier ?? '',
      lat: position.latitude,
      lng: position.longitude,
    );
    final result = await _favorService.updateLocation(location);
    if (result.error) {
      showErrorAlert(context, 'Ocurrió un error al actualizar la ubicación');
    }
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
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
        prefs.getString('no_order') != null ? const FavorProgressCourier() : MapCourier(onSwitchChanged: onSwitchChanged,),
        const Notifications(),
        const HistoryCourier(),
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

  Future<bool> _handlePopScope() {
    DateTime now = DateTime.now();

    if (_lastPressedTime == null ||
        now.difference(_lastPressedTime!) > const Duration(seconds: 2)) {
      _lastPressedTime = now;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Presione de nuevo para salir'),
          duration: Duration(seconds: 2),
        ),
      );

      return Future.value(false); // Previene el cierre de la app
    } else {
      SystemNavigator.pop();
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handlePopScope();
      },
      child: Scaffold(
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
      ),
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