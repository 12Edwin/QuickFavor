import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile_favor/config/dio_config.dart';
import 'package:mobile_favor/config/error_response.dart';
import 'package:mobile_favor/modules/auth/entity/auth.entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/firebase_service.dart';

class AuthService {
  final Dio dio;

  AuthService(BuildContext context) : dio = DioConfig.createDio(context);

  Future<ResponseEntity> login(LoginEntity credentials) async {
    try {
      String? firebaseToken = await FirebaseService.getFirebaseToken();
      print('Token: $firebaseToken');
      credentials.tokenFirebase = firebaseToken;
      final response = await dio.post('/auth/login', data: credentials.toJson());
      final data = response.data['data'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      await prefs.setString('no_user', data['user']['no_user']);
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('role', data['user']['role']);
      await prefs.setString('name', data['user']['name']);
      if(data['user']['location'] != null) await prefs.setDouble('lat', data['user']['location']['lat']);
      if(data['user']['location'] != null) await prefs.setDouble('lng', data['user']['location']['lng']);
      print(data);
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

  Future<ResponseEntity> registerCourier(RegisterCourierEntity courier) async {
    try {
      final response = await dio.post('/auth/courier-register', data: courier.toJson());
      print(ResponseEntity.fromJson(response.data).data);
      return ResponseEntity.fromJson(response.data);
    } catch (error) {
      ResponseEntity resp = ResponseEntity.fromJson ((error as DioError).response!.data);
      print(resp.message);
      if (resp.data != null) {
        return getErrorMessages(resp);
      }else {
        return resp;
      }
    }
  }

  Future<ResponseEntity> registerCustomer(RegisterCustomerEntity customer) async {
    try {
      final response = await dio.post('/auth/customer-register', data: customer.toJson());
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