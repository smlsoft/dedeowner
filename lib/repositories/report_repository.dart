import 'package:dedeowner/environment.dart';
import 'package:get_storage/get_storage.dart';

import 'client.dart';
import 'package:dio/dio.dart';

class ReportRepository {
  final appConfig = GetStorage("AppConfig");

  Future<ApiResponse> getReportSaleSummary(String fromdate, String todate) async {
    Dio dio = Dio();
    final token = appConfig.read("token");
    print("getReportSaleSummary");
    try {
      final response = await dio.get('${Environment().config.reportApi}/salesummarypg?token=$token$fromdate$todate');
      try {
        return ApiResponse.fromMap(response.data);
      } catch (ex) {
        throw Exception(ex);
      }
    } on DioError catch (ex) {
      String errorMessage = ex.error.toString();
      throw Exception(errorMessage);
    }
  }

  Future<ApiResponse> getReportSaleWeeklySummary(String fromdate, String todate) async {
    Dio dio = Dio();
    final token = appConfig.read("token");
    print("getReportSaleSummary");
    try {
      final response = await dio.get('${Environment().config.reportApi}/salesummarypg/weeklysales?token=$token$fromdate$todate');
      try {
        return ApiResponse.fromMap(response.data);
      } catch (ex) {
        throw Exception(ex);
      }
    } on DioError catch (ex) {
      String errorMessage = ex.error.toString();
      throw Exception(errorMessage);
    }
  }

  Future<ApiResponse> getReportBestSellSummary(String fromdate, String todate) async {
    Dio dio = Dio();
    final token = appConfig.read("token");
    print(token);
    try {
      final response = await dio.get('${Environment().config.reportApi}/bestseller?token=$token$fromdate$todate');
      try {
        return ApiResponse.fromMap(response.data);
      } catch (ex) {
        throw Exception(ex);
      }
    } on DioError catch (ex) {
      String errorMessage = ex.error.toString();
      throw Exception(errorMessage);
    }
  }
}
