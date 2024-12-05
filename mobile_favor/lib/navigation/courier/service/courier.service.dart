import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile_favor/navigation/courier/entity/notification.entity.dart';
import '../../../config/dio_config.dart';
import '../../../config/error_response.dart';

class CourierService {
  final Dio dio;

  CourierService(BuildContext context) : dio = DioConfig.createDio(context);

  Future<ResponseEntity> readNotifications(String courierId) async {
    try {
      final response = await dio.get('/favor/notification/$courierId');
      print(ResponseEntity.fromJson(response.data).data);
      return ResponseEntity.fromJson(response.data);
    } catch (error) {
      ResponseEntity resp = ResponseEntity.fromJson(
          (error as DioException).response!.data);
      print(resp.message);
      if (resp.data != null) {
        return getErrorMessages(resp);
      } else {
        return resp;
      }
    }
  }

  Future<ResponseEntity> rejectFavor(AcceptFavorEntity favor) async {
    try {
      final String orderId = favor.order_id;
      final response = await dio.put('/favor/reject/$orderId', data: favor.toJson());
      print(ResponseEntity.fromJson(response.data).data);
      return ResponseEntity.fromJson(response.data);
    } catch (error) {
      ResponseEntity resp = ResponseEntity.fromJson(
          (error as DioException).response!.data);
      print(resp.message);
      if (resp.data != null) {
        return getErrorMessages(resp);
      } else {
        return resp;
      }
    }
  }

  Future<ResponseEntity> acceptFavor(AcceptFavorEntity payload) async {
    try {
      final response = await dio.put('/favor/accept/${payload.order_id}', data: payload.toJson());
      print(ResponseEntity.fromJson(response.data).data);
      return ResponseEntity.fromJson(response.data);
    } catch (error) {
      ResponseEntity resp = ResponseEntity.fromJson(
          (error as DioException).response!.data);
      print(resp.message);
      if (resp.data != null) {
        return getErrorMessages(resp);
      } else {
        return resp;
      }
    }
  }
}