import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});
  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  GoogleMapController? mapController;
  LatLng _center =
      const LatLng(19.4326, -99.1332); // Centro de la Ciudad de México
  Position? _currentPosition;
  final Set<Circle> _circles = {};
  final Set<Marker> _markers = {}; // Para los marcadores

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _getCurrentLocation(); // Llamar para obtener la localización
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verificar si los servicios de ubicación están habilitados
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _setMapToDefaultLocation(); // Cargar ubicación por defecto
      return;
    }

    // Solicitar permiso para obtener la ubicación del usuario
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      _setMapToDefaultLocation(); // Cargar ubicación por defecto
      return;
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        _setMapToDefaultLocation(); // Cargar ubicación por defecto
        return;
      }
    }

    // Obtener la ubicación actual del usuario
    try {
      _currentPosition = await Geolocator.getCurrentPosition();
      _center = LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
      setState(() {
        _markers.add(
          Marker(
            markerId: const MarkerId("currentLocation"),
            position: _center,
            infoWindow: InfoWindow(title: "Estás aquí"),
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

        // Centrar el mapa en la ubicación actual
        if (mapController != null) {
          mapController!.animateCamera(
              CameraUpdate.newLatLngZoom(_center, 12.5)); // Zoom 15
        }
      });
    } catch (e) {
      _setMapToDefaultLocation(); // Cargar ubicación por defecto en caso de error
    }
  }

  void _setMapToDefaultLocation() {
    setState(() {
      // Centrar el mapa en la Ciudad de México
      if (mapController != null) {
        mapController!.animateCamera(
            CameraUpdate.newLatLngZoom(_center, 12.5)); // Zoom 15
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition:
            CameraPosition(target: _center, zoom: 12.5), // Zoom 15 por defecto
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        circles: _circles,
        markers: _markers, // Agregar marcadores al mapa
      ),
    );
  }
}
