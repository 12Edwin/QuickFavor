import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile_favor/navigation/courier/entity/profile_courier.entity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/dio_config.dart';
import '../../../config/error_response.dart';

class ProfileCourierService {
  final Dio dio;
  late SharedPreferences prefs;

  ProfileCourierService(BuildContext context) : dio = DioConfig.createDio(context);

  Future<void> _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  // Obtener el perfil del repartidor
  Future<ProfileCourierEntity?> getProfileCourier() async {
    // Inicializar prefs antes de hacer la solicitud
    await _initPrefs();

    try {
      final uid = prefs.getString('uid');
      if (uid == null) {
        print('UID no encontrado en SharedPreferences');
        return null; // Si el UID no está disponible, retorna null
      }
      final response = await dio.get('/courier/profile/$uid');

      if (response.statusCode == 200) {
        print('response${response.data}');
        return ProfileCourierEntity.fromJson(response.data['data']);
      } else {
        print('Error al obtener los datos del perfil: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error en la llamada a la API: $e');
      return null;
    }
  }

// Actualizar el perfil del repartidor
  Future<bool> updateProfile(ProfileCourierEntity profile) async {
    await _initPrefs();

    try {
      final response = await dio.put(
        '/courier/profile/', // No se envía el uid en la URL
        data: jsonEncode(profile.toJson()), // El uid está en el cuerpo del JSON
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Perfil actualizado exitosamente');
        return true;
      } else {
        print('Error al actualizar el perfil: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error en la llamada a la API para actualizar el perfil: $e');
      return false;
    }
  }

  String? extraerBase64(String? dataUrl) {
    const String base64Prefix = 'base64,';
    if (dataUrl != null && dataUrl.contains(base64Prefix)) {
      return dataUrl.split(base64Prefix)[1]; // Retorna solo la parte base64
    }
    return null; // Si no tiene el prefijo esperado, devuelve null
  }

Future<String?> convertirImagenABase64(File? imageFile) async {
  if (imageFile == null) return null;
  try {
    List<int> imageBytes = await imageFile.readAsBytes();
    String base64Image = base64Encode(imageBytes);
    String mimeType = _getMimeType(imageFile.path);
    return 'data:$mimeType;base64,$base64Image'; // Devuelve el base64 con el prefijo
  } catch (e) {
    print('Error al convertir la imagen a base64: $e');
    return null;
  }
}

String _getMimeType(String filePath) {
  String extension = filePath.split('.').last.toLowerCase();
  switch (extension) {
    case 'jpg':
    case 'jpeg':
      return 'image/jpeg';
    case 'png':
      return 'image/png';
    default:
      return 'application/octet-stream';
  }
}

  // Actualizar el vehículo del repartidor
  Future<ResponseEntity> updateVehicle(ProfileCourierEntity profile, {File? licensePhoto}) async {
    await _initPrefs();
    try {
      String? photoBase64 = await convertirImagenABase64(licensePhoto);
      String? cleanedBase64 = extraerBase64(photoBase64);

      // Crear el cuerpo de la solicitud
      final data = {
        "vehicle_type": profile.vehicleType,
        "brand": profile.brand,
        "model": profile.model,
        "license_plate": profile.licensePlate,
        "color": profile.color,
        "description": profile.description,
        "plate_photo": cleanedBase64,
      };

      print('Datos enviados a la API: $data');
      final response = await dio.put('/courier/vehicle', data: data);

      print(ResponseEntity.fromJson(response.data).data);
      return ResponseEntity.fromJson(response.data);

    } catch (e) {
      ResponseEntity resp = ResponseEntity.fromJson((e as DioException).response!.data);
      print(resp.message);
      if (resp.data != null) {
        return getErrorMessages(resp);
      } else {
        return resp;
      }
    }
  }
}
