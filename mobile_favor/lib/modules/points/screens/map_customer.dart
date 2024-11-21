import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_for_flutter/google_places_for_flutter.dart';
import 'package:geolocator/geolocator.dart'; // Importamos geolocator

class MapCustomer extends StatefulWidget {
  const MapCustomer({super.key});

  @override
  _MapCustomerState createState() => _MapCustomerState();
}

class _MapCustomerState extends State<MapCustomer> {
  late GoogleMapController mapController; // Controlador del mapa
  late Set<Marker> _markers; // Conjunto de marcadores
  late Set<Circle> _circles; // Conjunto de círculos (para el radio de 5 km)
  late LatLng _center; // Centro inicial del mapa
  List<LatLng> selectedPlaces = []; // Lista de lugares seleccionados
  LatLng? _currentLocation; // Ubicación actual del usuario (LatLng)

  @override
  void initState() {
    super.initState();
    _markers = {};
    _circles = {};
    _center = LatLng(37.7749, -122.4194); // Lugar por defecto (San Francisco)
    _getCurrentLocation(); // Obtenemos la ubicación actual
  }

  // Función para obtener la ubicación actual del usuario
  Future<void> _getCurrentLocation() async {
    // Verificamos si tenemos permiso para acceder a la ubicación
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Por favor habilita los servicios de ubicación')),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('El permiso de ubicación es necesario')),
        );
        return;
      }
    }

    // Obtenemos la ubicación actual
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy:
          LocationAccuracy.high, // Exactitud alta para la ubicación
    );

    setState(() {
      _currentLocation = LatLng(
          position.latitude, position.longitude); // Guardamos la ubicación
      _center = _currentLocation!; // Actualizamos el centro del mapa

      // Agregamos un círculo de 5 km alrededor de la ubicación
      _circles.add(Circle(
        circleId: CircleId('5km_radius'),
        center: _center,
        radius: 5000, // 5 km en metros
        fillColor: Colors.blue.withOpacity(0.3),
        strokeWidth: 0,
      ));
    });

    // Movemos la cámara al centro (la ubicación actual)
    mapController.animateCamera(CameraUpdate.newLatLng(_center));
  }

  // Maneja la selección de un lugar
  void _onPlaceSelected(Place place) async {
    if (selectedPlaces.length >= 3) {
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

      selectedPlaces.add(geolocation?.coordinates ?? _center);
    });

    mapController.animateCamera(
        CameraUpdate.newLatLng(geolocation?.coordinates ?? _center));
    mapController
        .animateCamera(CameraUpdate.newLatLngBounds(geolocation?.bounds, 0));
  }

  // Inicializa el mapa
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('¿Necesitas algo Merri?'),
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
                  apiKey:
                      'AIzaSyBqG_XDPOTcaSKF3lsfNWmtWbzl6x3L77Y', // Reemplaza con tu API key
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
