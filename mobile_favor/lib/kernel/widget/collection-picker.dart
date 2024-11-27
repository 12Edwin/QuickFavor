import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_for_flutter/google_places_for_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mobile_favor/config/alerts.dart';
import 'package:mobile_favor/config/utils.dart'; // Import the utils.dart

class CollectionPicker extends StatefulWidget {
  final double? initialLat;
  final double? initialLng;
  final Function(double, double, String) onLocationPicked;

  const CollectionPicker({
    this.initialLat,
    this.initialLng,
    required this.onLocationPicked,
    super.key,
  });

  @override
  _CollectionPickerState createState() => _CollectionPickerState();
}

class _CollectionPickerState extends State<CollectionPicker> {
  late GoogleMapController mapController;
  late Set<Marker> _markers;
  late Set<Circle> _circles;
  late LatLng _circleCenter;
  LatLng? _currentLocation;
  LatLng? _lastValidCenter;
  String _address = '';
  final double _radius = 5000; // 5 km radius
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _markers = {};
    _circles = {};
    _initializeCircleLocation();
    _initializeMarkerLocation();
  }

  Future<void> _initializeCircleLocation() async {
    try {
      LatLng location = await getLatLngFromStorageOrCurrent();
      setState(() {
        _circleCenter = location;
        _circles.add(Circle(
          circleId: CircleId('5km_radius'),
          center: _circleCenter,
          radius: _radius,
          fillColor: Colors.blue.withOpacity(0.3),
          strokeWidth: 0,
        ));
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al obtener la ubicación: $e')),
      );
    }
  }

  Future<void> _initializeMarkerLocation() async {
  if (widget.initialLat != null && widget.initialLng != null) {
    _currentLocation = LatLng(widget.initialLat!, widget.initialLng!);
    _lastValidCenter = _currentLocation;
    _getAddressFromLatLng(_currentLocation!);
    setState(() {});
    if (mapController != null) {
      mapController.animateCamera(CameraUpdate.newLatLng(_currentLocation!));
    }
  } else {
    try {
      LatLng location = await getLatLngFromStorageOrCurrent();
      setState(() {
        _currentLocation = location;
        _lastValidCenter = _currentLocation;
      });
      if (mapController != null) {
        mapController.animateCamera(CameraUpdate.newLatLng(_currentLocation!));
      }
    } catch (e) {
      print('Error al obtener la ubicación: $e');
    }
  }
}

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks[0];
      setState(() {
        _address = "${place.street}, ${place.locality}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  void _onPlaceSelected(Place place) async {
    if (_markers.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ya has seleccionado 3 lugares.')),
      );
      return;
    }

    final geolocation = await place.geolocation;

    setState(() {
      _markers.add(Marker(
        markerId: MarkerId(place.placeId ?? 'default_place_id'),
        position: geolocation?.coordinates ?? _currentLocation!,
        infoWindow: InfoWindow(
          title: place.description,
          snippet: place.placeId,
        ),
      ));
    });

    mapController.animateCamera(
        CameraUpdate.newLatLng(geolocation?.coordinates ?? _currentLocation!));
    mapController
        .animateCamera(CameraUpdate.newLatLngBounds(geolocation?.bounds, 0));
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _initializeMarkerLocation(); // Ensure marker location is initialized after map is created
  }

  bool _isWithinRadius(LatLng center, LatLng point, double radius) {
    final distance = Geolocator.distanceBetween(
      center.latitude,
      center.longitude,
      point.latitude,
      point.longitude,
    );
    return distance <= radius;
  }

  void _confirmLocation() {
    if (_currentLocation != null) {
      widget.onLocationPicked(_currentLocation!.latitude, _currentLocation!.longitude, _address);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dirección de compra'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentLocation ?? LatLng(37.7749, -122.4194),
                zoom: 12,
              ),
              onMapCreated: _onMapCreated,
              markers: _markers,
              circles: _circles,
              onCameraMove: (position) {
                setState(() {
                  _currentLocation = position.target;
                  _isDragging = true;
                });
              },
              onCameraIdle: () {
                if (_isWithinRadius(_circleCenter, _currentLocation!, _radius)) {
                  _lastValidCenter = _currentLocation;
                  _getAddressFromLatLng(_currentLocation!);
                } else {
                  mapController.animateCamera(CameraUpdate.newLatLng(_lastValidCenter!));
                  showWarningAlert(context, 'El marcador debe estar dentro del radio permitido');
                }
                setState(() {
                  _isDragging = false;
                });
              },
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedOpacity(
                  opacity: _isDragging ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      _address,
                      style: TextStyle(fontSize: 12, color: Colors.white, backgroundColor: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: const Icon(Icons.location_pin, size: 40, color: Colors.red),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: SearchGooglePlacesWidget(
                  language: 'es',
                  placeholder: 'Buscar',
                  onSearch: (Place place) {
                    print(place.description);
                  },
                  onSelected: _onPlaceSelected,
                  apiKey: 'AIzaSyBqG_XDPOTcaSKF3lsfNWmtWbzl6x3L77Y', // Reemplaza con tu API key
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _confirmLocation,
        child: const Icon(Icons.check),
      ),
    );
  }
}