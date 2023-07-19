// ignore_for_file: unused_local_variable, deprecated_member_use

import 'dart:convert';

import 'package:dedeowner/model/create_shop_model.dart';

import 'client.dart';
import 'package:dio/dio.dart';

class UserRepository {
  Future<ApiResponse> authenUser(String userName, String passWord) async {
    Dio client = Client().init();

    try {
      final response = await client.post('/login', data: {"username": userName, "password": passWord});
      try {
        final result = json.decode(response.toString());
        final rawData = {"success": result["success"], "data": result};

        if (rawData['error'] != null) {
          String errorMessage = '${rawData['code']}: ${rawData['message']}';
          throw Exception('${rawData['code']}: ${rawData['message']}');
        }

        return ApiResponse.fromMap(rawData);
      } catch (ex) {
        throw Exception(ex);
      }
    } on DioError catch (ex) {
      String errorMessage = ex.response.toString();
      if (ex.type == DioErrorType.connectionTimeout) {
        throw Exception('Connection Timeout');
      }
      if (ex.type == DioErrorType.receiveTimeout) {
        throw Exception('unable to connect to the server');
      }
      /*if (ex.type == DioErrorType.other) {
        throw Exception('Something went wrong');
      }
      if (ex.type == DioErrorType.response) {
        print(ex.response?.statusCode);
        throw Exception('User Not Found');
      }*/

      throw Exception(errorMessage);
    }
  }

  /// token login
  Future<ApiResponse> authenUserByToken(String token) async {
    Dio client = Client().init();

    try {
      final response = await client.post('/tokenlogin', data: {"token": token});
      try {
        final result = json.decode(response.toString());
        final rawData = {"success": result["success"], "data": result};

        if (rawData['error'] != null) {
          String errorMessage = '${rawData['code']}: ${rawData['message']}';
          throw Exception('${rawData['code']}: ${rawData['message']}');
        }

        return ApiResponse.fromMap(rawData);
      } catch (ex) {
        throw Exception(ex);
      }
    } on DioError catch (ex) {
      String errorMessage = ex.response.toString();
      if (ex.type == DioErrorType.connectionTimeout) {
        throw Exception('Connection Timeout');
      }
      if (ex.type == DioErrorType.receiveTimeout) {
        throw Exception('unable to connect to the server');
      }
      /*if (ex.type == DioErrorType.other) {
        throw Exception('Something went wrong');
      }
      if (ex.type == DioErrorType.response) {
        print(ex.response?.statusCode);
        throw Exception('User Not Found');
      }*/

      throw Exception(errorMessage);
    }
  }

  Future<ApiResponse> getShopList() async {
    Dio client = await Client().init();

    try {
      final response = await client.get('/list-shop');
      try {
        final rawData = json.decode(response.toString());

        // print(rawData);

        if (rawData['error'] != null) {
          String errorMessage = '${rawData['code']}: ${rawData['message']}';
          throw Exception('${rawData['code']}: ${rawData['message']}');
        }

        return ApiResponse.fromMap(rawData);
      } catch (ex) {
        throw Exception(ex);
      }
    } on DioError catch (ex) {
      String errorMessage = ex.response.toString();
      throw Exception(errorMessage);
    }
  }

  Future<ApiResponse> selectShop(String shopid) async {
    Dio client = Client().init();

    try {
      final response = await client.post('/select-shop', data: {"shopid": shopid});
      try {
        final rawData = json.decode(response.toString());

        if (rawData['error'] != null) {
          String errorMessage = '${rawData['code']}: ${rawData['message']}';
          throw Exception('${rawData['code']}: ${rawData['message']}');
        }

        return ApiResponse.fromMap(rawData);
      } catch (ex) {
        throw Exception(ex);
      }
    } on DioError catch (ex) {
      String errorMessage = ex.response.toString();
      throw Exception(errorMessage);
    }
  }

  Future<ApiResponse> createShop(CreateShopModel createShop) async {
    Dio client = Client().init();
    final data = createShop.toJson();
    try {
      final response = await client.post('/create-shop', data: data);
      try {
        return ApiResponse.fromMap(response.data);
      } catch (ex) {
        throw Exception(ex);
      }
    } on DioError catch (ex) {
      String errorMessage = ex.response.toString();
      throw errorMessage;
    }
  }
}
