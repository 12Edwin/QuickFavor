import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile_favor/config/alerts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioConfig {
  static Dio createDio(BuildContext context) {
    final dio = Dio(BaseOptions(
      baseUrl: 'https://backend-app-y3z1.onrender.com',
      connectTimeout: const Duration(milliseconds: 10000),
      receiveTimeout: const Duration(milliseconds: 10000),
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Add authentication token to headers
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? token = prefs.getString('token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioError error, handler) async {
        // Handle errors
        if (error.response == null) {
          return handler.reject(DioException(
            requestOptions: error.requestOptions,
            response: Response(
              requestOptions: error.requestOptions,
              statusCode: 502,
              statusMessage: 'Network error',
              data: {'error': true, 'message': 'Network error', 'data': null},
            ),
          ));
        }
        if (error.response?.statusCode == 401) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.remove('token');
          prefs.remove('no_user');
          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        } else if (error.response?.statusCode == 403) {
          showErrorAlert(context, 'Acceso denegado a este recurso');
        }
        return handler.next(error);
      },
    ));

    return dio;
  }
}