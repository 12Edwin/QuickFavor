import 'dart:async';
import 'dart:convert';
import 'dart:typed_data' show Uint8List;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile_favor/navigation/customer/entity/order.entity.dart';
import '../../../config/dio_config.dart';
import '../../../config/error_response.dart';
import '../entity/sse.entity.dart';

class FavorService {
  final Dio dio;
  FavorService(BuildContext context) : dio = DioConfig.createDio(context);

  Future<ResponseEntity> registerFavor(CreateOrderEntity order) async {
    try {
      final response = await dio.post('/favor/', data: order.toJson());
      print(ResponseEntity.fromJson(response.data).data);
      return ResponseEntity.fromJson(response.data);
    } catch (error) {
      ResponseEntity resp = ResponseEntity.fromJson((error as DioError).response!.data);
      print(resp.message);
      if (resp.data != null) {
        return getErrorMessages(resp);
      } else {
        return resp;
      }
    }
  }

  Stream<SSEMessage> listenToSSE(SearchCourierEntity data) async* {
  final response = await dio.post(
    '/location/search',
    data: data.toJson(),
    options: Options(
      responseType: ResponseType.stream,
    ),
  );

  List<int> buffer = [];
  await for (final chunk in response.data.stream) {
    buffer.addAll(chunk);
    String text = utf8.decode(buffer);
    buffer.clear();

    for (final line in LineSplitter.split(text)) {
      if (line.isNotEmpty) {
        print('Línea recibida: $line');
        try {
          final jsonData = jsonDecode(line);
          yield SSEMessage.fromJson(jsonData);
        } catch (e) {
          print('Error decodificando JSON: $e');
          continue;
        }
      }
    }
  }
}

Future<ResponseEntity> getDetailsFavor(String idOrder) async {
    try {
      final response = await dio.get('/favor/details/$idOrder');
      print(ResponseEntity.fromJson(response.data).data);
      return ResponseEntity.fromJson(response.data);
    } catch (error) {
      print(error);
      ResponseEntity resp = ResponseEntity.fromJson((error as DioError).response!.data);
      print(resp.message);
      if (resp.data != null) {
        return getErrorMessages(resp);
      } else {
        return resp;
      }
    }
  }

Stream<SSEOrderMessage> favorStatus(String idFavor) async* {
  final response = await dio.get(
    '/favor/status/$idFavor',
    options: Options(
      responseType: ResponseType.stream,
    ),
  );

  List<int> buffer = [];
  await for (final chunk in response.data.stream) {
    buffer.addAll(chunk);
    String text = utf8.decode(buffer);
    buffer.clear();

    for (final line in LineSplitter.split(text)) {
      if (line.isNotEmpty) {
        print('Línea recibida: $line');
        try {
          final jsonData = jsonDecode(line);
          yield SSEOrderMessage.fromJson(jsonData);
        } catch (e) {
          print('Error decodificando JSON: $e');
          continue;
        }
      }
    }
  }
}
}