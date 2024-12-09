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

  ProfileCourierService(BuildContext context)
      : dio = DioConfig.createDio(context);

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

  // Actualizar el vehículo del repartidor
  Future<bool> updateVehicle(ProfileCourierEntity profile,
      {File? licensePhoto}) async {
    await _initPrefs();

    try {
      final credential = prefs.getString('token');
      if (credential == null) {
        print('Credencial no encontrada en SharedPreferences');
        return false;
      }

      // Convertir la foto a base64 si existe
      String? photoBase64;
      if (licensePhoto != null) {
        final bytes = await licensePhoto.readAsBytes();
        photoBase64 = base64Encode(bytes);
      }

      // Crear el cuerpo de la solicitud
      final data = {
        "vehicle_type": profile.vehicleType,
        "brand": profile.brand,
        "model": profile.model,
        "license_plate": profile.licensePlate,
        "color": profile.color,
        "description": profile.description,
        "plate_url": photoBase64, // Enviar la foto como base64
      };

      final response = await dio.put(
        '/courier/vehicle',
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                'Bearer $credential', // Enviar la credencial en el encabezado
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Vehículo actualizado exitosamente');
        return true;
      } else {
        print('Error al actualizar el vehículo: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error en la llamada a la API para actualizar el vehículo: $e');
      return false;
    }
  }
}
