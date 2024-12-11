import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_for_flutter/google_places_for_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mobile_favor/config/alerts.dart';
import 'package:mobile_favor/config/utils.dart';

class MapCustomerPick extends StatefulWidget {
  final Function(double, double, String) onLocationPicked;

  const MapCustomerPick({super.key, required this.onLocationPicked});

  @override
  _MapCustomerPickState createState() => _MapCustomerPickState();
}

class _MapCustomerPickState extends State<MapCustomerPick> {
  late GoogleMapController mapController;
  late Set<Marker> _markers;
  late LatLng _center;
  LatLng? _currentLocation;
  String _address = '';
  final double _radius = 5000; // 5 km radius
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _markers = {};
    _center = const LatLng(37.7749, -122.4194);
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    try {
      LatLng location = await getLatLngFromStorageOrCurrent();
      setState(() {
        _currentLocation = location;
        _center = _currentLocation!;
      });
      mapController.animateCamera(CameraUpdate.newLatLng(_center));
      _getAddressFromLatLng(_center);
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

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _initializeLocation();
  }

  void _onPlaceSelected(Place place) async {
    final geolocation = await place.geolocation;

    setState(() {
      _center = geolocation?.coordinates ?? _center;
      _markers.clear();
      _markers.add(Marker(
        markerId: MarkerId(place.placeId ?? 'default_place_id'),
        position: _center,
        infoWindow: InfoWindow(title: place.description),
      ));
    });

    mapController.animateCamera(CameraUpdate.newLatLng(_center));
    _getAddressFromLatLng(_center);
  }

  void _confirmSelection() {
    widget.onLocationPicked(
      _center.latitude,
      _center.longitude,
      _address,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecciona una Ubicación'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 12,
            ),
            onMapCreated: _onMapCreated,
            markers: _markers,
            onCameraMove: (position) {
              setState(() {
                _center = position.target;
                _isDragging = true;
              });
            },
            onCameraIdle: () {
              _getAddressFromLatLng(_center);
              setState(() {
                _isDragging = false;
              });
            },
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
                  placeholder: 'Buscar ubicación',
                  onSearch: (Place place) {
                    print(place.description);
                  },
                  onSelected: _onPlaceSelected,
                  apiKey: 'AIzaSyBqG_XDPOTcaSKF3lsfNWmtWbzl6x3L77Y',
                ),
              ),
            ),
          ),
          Center(
            child: Icon(
              Icons.location_pin,
              size: 40,
              color: _isDragging ? Colors.grey : Colors.red,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _confirmSelection,
        label: const Text('Confirmar'),
        icon: const Icon(Icons.check),
      ),
    );
  }
}
