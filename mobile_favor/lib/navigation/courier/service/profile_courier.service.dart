import 'dart:convert';
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

      print('UID: $uid');
      final response = await dio.get('/courier/profile/$uid');

      if (response.statusCode == 200) {
        print('Perfil obtenido con éxito');
        return ProfileCourierEntity.fromJson(response.data);
      } else {
        print('Error al obtener los datos del perfil: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error en la llamada a la API: $e');
      return null;
    }
  }

  Future<ProfileCourierEntity?> getProfileCustomer(String uid) async {
    try {
      final response = await dio.get('/courier/profile/$uid');

      if (response.statusCode == 200) {
        print(response.data);
        return ProfileCourierEntity.fromJson(response.data);
      } else {
        print('Error al obtener los datos del perfil: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error en la llamada a la API: $e');
      return null;
    }
  }

  // Método para actualizar el perfil de un usuario (si es necesario)
  Future<bool> updateProfile(ProfileCourierEntity profile) async {
    try {
      final data = profile.toJson();
      final response = await dio.put(
        '/profiles/${profile.uid}',
        data: json.encode(data),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Error al actualizar el perfil: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error al hacer la solicitud de actualización: $e');
      return false;
    }
  }
}
