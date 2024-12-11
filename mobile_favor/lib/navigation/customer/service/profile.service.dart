import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile_favor/navigation/customer/entity/profile.entity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/dio_config.dart';
import '../../../config/error_response.dart';

class ProfileService {
  final Dio dio;
  late SharedPreferences prefs;

  ProfileService(BuildContext context) : dio = DioConfig.createDio(context) {
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<ProfileEntity?> getProfileCourier() async {
    try {
      final uid = prefs.getString('uid');
      final response = await dio.get('/courier/profile/$uid');

      if (response.statusCode == 200) {
        print(response.data);
        // Convertir la respuesta JSON en una instancia de ProfileEntity
        return ProfileEntity.fromJson(response.data);
      } else {
        print('Error al obtener los datos del perfil: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error en la llamada a la API: $e');
      return null;
    }
  }

  Future<ProfileEntity?> getProfileCustomer(String uid) async {
    try {
      final response = await dio.get('/courier/profile/$uid');

      if (response.statusCode == 200) {
        print(response.data);
        // Convertir la respuesta JSON en una instancia de ProfileEntity
        return ProfileEntity.fromJson(response.data);
      } else {
        print('Error al obtener los datos del perfil: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error en la llamada a la API: $e');
      return null;
    }
  }

  Future<ResponseEntity> updateCustomerProfile(Map<String, dynamic> customer) async {
    try {
      final response = await dio.put('/customer/profile', data: customer);
      print(ResponseEntity.fromJson(response.data).data);
      return ResponseEntity.fromJson(response.data);
    } catch (error) {
      print(error);
      ResponseEntity resp = ResponseEntity.fromJson((error as DioException).response!.data);
      print(resp.message);
      if (resp.data != null) {
        return getErrorMessages(resp);
      } else {
        return resp;
      }
    }
  }

  // Método para actualizar el perfil de un usuario (si es necesario)
  Future<bool> updateProfile(ProfileEntity profile) async {
    try {
      // Convertir el perfil a un mapa JSON
      final data = profile.toJson();

      // Llamada PUT para actualizar el perfil
      final response = await dio.put(
        '/profiles/${profile.uid}',
        data: json.encode(data), // Mandar los datos en formato JSON
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
