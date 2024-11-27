import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_for_flutter/google_places_for_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mobile_favor/config/alerts.dart';
import 'package:mobile_favor/config/utils.dart';
import 'package:mobile_favor/navigation/customer/create_order.dart';

class MapCustomer extends StatefulWidget {
  const MapCustomer({super.key});

  @override
  _MapCustomerState createState() => _MapCustomerState();
}

class _MapCustomerState extends State<MapCustomer> {
  String name = 'Cliente';
  late GoogleMapController mapController;
  late Set<Marker> _markers;
  late Set<Circle> _circles;
  late LatLng _center;
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
    _center = LatLng(37.7749, -122.4194);
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    name = await getStorageName() ?? 'Cliente';
    try {
      LatLng location = await getLatLngFromStorageOrCurrent();
      setState(() {
        _currentLocation = location;
        _center = _currentLocation!;
        _lastValidCenter = _center;

        _circles.add(Circle(
          circleId: CircleId('5km_radius'),
          center: _center,
          radius: _radius,
          fillColor: Colors.blue.withOpacity(0.3),
          strokeWidth: 0,
        ));
      });
      mapController.animateCamera(CameraUpdate.newLatLng(_center));

    } catch (e) {
      print('Error al obtener la ubicación: $e');
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
        position: geolocation?.coordinates ?? _center,
        infoWindow: InfoWindow(
          title: place.description,
          snippet: place.placeId,
        ),
      ));
    });

    mapController.animateCamera(
        CameraUpdate.newLatLng(geolocation?.coordinates ?? _center));
    mapController
        .animateCamera(CameraUpdate.newLatLngBounds(geolocation?.bounds, 0));
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _initializeLocation();
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

  void _navigateToCreateOrder() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateOrder(
          lat: _center.latitude,
          lng: _center.longitude,
          address: _address,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('¿Necesitas algo ${name}?'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 12,
              ),
              onMapCreated: _onMapCreated,
              markers: _markers,
              circles: _circles,
              onCameraMove: (position) {
                setState(() {
                  _center = position.target;
                  _isDragging = true;
                });
              },
              onCameraIdle: () {
                if (_isWithinRadius(_currentLocation!, _center, _radius)) {
                  _lastValidCenter = _center;
                  _getAddressFromLatLng(_center);
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
        onPressed: _navigateToCreateOrder,
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }
}