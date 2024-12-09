import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapWidget extends StatefulWidget {
  final Position? currentPosition;

  const MapWidget({super.key, this.currentPosition});

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  GoogleMapController? mapController;
  LatLng _center = const LatLng(19.4326, -99.1332); // Default to Mexico City
  final Set<Circle> _circles = {};
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    if (widget.currentPosition != null) {
      _updateMapLocation(widget.currentPosition!);
    } else {
      _getCurrentLocation();
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (widget.currentPosition == null) {
      _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _setMapToDefaultLocation();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      _setMapToDefaultLocation();
      return;
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        _setMapToDefaultLocation();
        return;
      }
    }

    try {
      Position position = await Geolocator.getCurrentPosition();
      _updateMapLocation(position);
    } catch (e) {
      _setMapToDefaultLocation();
    }
  }

  void _updateMapLocation(Position position) {
    _center = LatLng(position.latitude, position.longitude);
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId("currentLocation"),
          position: _center,
          infoWindow: const InfoWindow(title: "You are here"),
        ),
      );
      _circles.add(
        Circle(
          circleId: const CircleId("currentLocation"),
          center: _center,
          radius: 5000, // 5 km
          fillColor: Colors.blue.withOpacity(0.5),
          strokeColor: Colors.blue,
          strokeWidth: 1,
        ),
      );

      if (mapController != null) {
        mapController!.animateCamera(CameraUpdate.newLatLngZoom(_center, 12.5)); // Zoom 15
      }
    });
  }

  void _setMapToDefaultLocation() {
    setState(() {
      if (mapController != null) {
        mapController!.animateCamera(CameraUpdate.newLatLngZoom(_center, 12.5)); // Zoom 15
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(target: _center, zoom: 12.5), // Default zoom 15
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        circles: _circles,
        markers: _markers,
      ),
    );
  }
}