import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationPreview extends StatefulWidget {
  final String text;
  final double lat;
  final double lng;

  const LocationPreview({
    Key? key,
    required this.text,
    required this.lat,
    required this.lng,
  }) : super(key: key);

  @override
  _LocationPreviewState createState() => _LocationPreviewState();
}

class _LocationPreviewState extends State<LocationPreview> {
  late GoogleMapController _controller;
  LatLng? _currentLocation;
  String _destinationName = '';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _getPlaceName(widget.lat, widget.lng);
  }

  Future<void> _getCurrentLocation() async {
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
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });
  }

  Future<void> _getPlaceName(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        setState(() {
          _destinationName = placemarks.first.name ?? '';
        });
      }
    } catch (e) {
      print('Error getting place name: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.text)),
      body: Column(
        children: [
          if (_destinationName.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _destinationName,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          Expanded(
            child: _currentLocation == null
                ? Center(child: CircularProgressIndicator())
                : GoogleMap(
                    onMapCreated: (controller) {
                      _controller = controller;
                    },
                    initialCameraPosition: CameraPosition(
                      target: _currentLocation!,
                      zoom: 14.0,
                    ),
                    markers: {
                      Marker(
                        markerId: MarkerId('currentLocation'),
                        position: _currentLocation!,
                        infoWindow: InfoWindow(title: 'Current Location'),
                      ),
                      Marker(
                        markerId: MarkerId('destination'),
                        position: LatLng(widget.lat, widget.lng),
                        infoWindow: InfoWindow(title: 'Destination'),
                      ),
                    },
                  ),
          ),
        ],
      ),
    );
  }
}