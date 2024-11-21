import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile_favor/config/dio_config.dart';
import 'package:mobile_favor/config/error_response.dart';
import 'package:mobile_favor/modules/auth/entity/auth.entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Dio dio;

  AuthService(BuildContext context) : dio = DioConfig.createDio(context);

  Future<ResponseEntity> login(LoginEntity credentials) async {
    try {
      final response = await dio.post('/auth/login', data: credentials.toJson());
      final data = response.data['data'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      await prefs.setString('no_user', data['user']['no_user']);
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('role', data['user']['role']);
      return ResponseEntity.fromJson(response.data);
    } catch (error) {
      ResponseEntity resp = ResponseEntity.fromJson ((error as DioError).response!.data);
      if (resp.data != null) {
        return getErrorMessages(resp);
      }else {
        return resp;
      }
    }
  }
}