import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getStorageName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('name');
}

Future<String?> getStorageNoUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('no_user');
}

Future<String?> getStorageNoOrder() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('no_order');
}

Future<void> removeStorageNoOrder() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('no_order');
}

Future<LatLng> getLatLngFromStorageOrCurrent() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  double? lat = prefs.getDouble('lat');
  double? lng = prefs.getDouble('lng');

  if (lat != null && lng != null) {
    return LatLng(lat, lng);
  } else {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return LatLng(position.latitude, position.longitude);
  }
}