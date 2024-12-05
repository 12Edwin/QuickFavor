import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile_favor/config/alerts.dart';
import 'package:mobile_favor/config/utils.dart';
import 'package:mobile_favor/modules/points/widgets/map_widget.dart';
import 'package:mobile_favor/navigation/customer/entity/location.entity.dart';
import 'package:mobile_favor/navigation/customer/service/favor.service.dart';

class MapCourier extends StatefulWidget {
  const MapCourier({super.key});

  @override
  _MapCourierState createState() => _MapCourierState();
}

class _MapCourierState extends State<MapCourier> {
  bool _isActive = false;
  Timer? _timer;
  Position? _currentPosition;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    (() async {
      final result = await getStorageAvailability();
      setState(() {
        _isActive = result;
      });
    })();
  }

  void _startTimer() async {
    final FavorService favorService = FavorService(context);
    final String? noCourier = await getStorageNoUser();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      Position position = await _getCurrentLocation();
      setState(() {
        _currentPosition = position;
      });
      UpdateLocationEntity location = UpdateLocationEntity(
        no_courier: noCourier ?? '',
        lat: position.latitude,
        lng: position.longitude,
      );
      final result = await favorService.updateLocation(location);
      if (result.error) {
        showErrorAlert(context, 'Ocurrió un error al actualizar la ubicación');
      }
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('¿Donde estas?'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        automaticallyImplyLeading: false, // Remove the back arrow
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Switch(
              value: _isActive,
              onChanged: (value) {
                setState(() {
                  _isActive = value;
                  toggleStorageAvailability(value);
                  if (_isActive) {
                    _startTimer();
                  } else {
                    _stopTimer();
                  }
                });
              },
              activeColor: Colors.green,
              inactiveThumbColor: Colors.red,
              focusColor: Colors.blue,
            ),
          ),
        ],
      ),
      body: Center(
        child: MapWidget(
          currentPosition: _currentPosition,
        ), // Show the map with the current location
      ),
    );
  }
}