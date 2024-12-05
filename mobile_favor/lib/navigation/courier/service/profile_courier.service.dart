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
}
