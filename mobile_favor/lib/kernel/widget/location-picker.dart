import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_for_flutter/google_places_for_flutter.dart';
import 'package:geolocator/geolocator.dart';

class LocationPicker extends StatefulWidget {
  final Function(LatLng, String) onLocationPicked;

  const LocationPicker({required this.onLocationPicked, super.key});

  @override
  _LocationPickerState createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  late GoogleMapController mapController;
  LatLng? _currentLocation;
  LatLng? _mapCenter;
  String _address = '';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enable location services')),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission is required')),
        );
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      _mapCenter = _currentLocation;
    });

    mapController.animateCamera(CameraUpdate.newLatLng(_currentLocation!));
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
    final geolocation = await place.geolocation;

    setState(() {
      _currentLocation = geolocation?.coordinates;
      _mapCenter = _currentLocation;
      _address = place.description ?? '';
    });

    mapController.animateCamera(CameraUpdate.newLatLng(_currentLocation!));
  }

  void _confirmLocation() {
    if (_currentLocation != null) {
      widget.onLocationPicked(_currentLocation!, _address);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Direccion de entrega'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentLocation ?? const LatLng(37.7749, -122.4194),
                zoom: 12,
              ),
              onMapCreated: (controller) {
                mapController = controller;
              },
              onCameraMove: (position) {
                setState(() {
                  _mapCenter = position.target;
                });
              },
              onCameraIdle: () {
                setState(() {
                  _currentLocation = _mapCenter;
                });
                _getAddressFromLatLng(_mapCenter!);
              },
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
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
                const Icon(Icons.location_pin, size: 40, color: Colors.red),
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
                  placeholder: 'Buscar...',
                  onSearch: (Place place) {
                    print(place.description);
                  },
                  onSelected: _onPlaceSelected,
                  apiKey: 'AIzaSyBqG_XDPOTcaSKF3lsfNWmtWbzl6x3L77Y', // Replace with your API key
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