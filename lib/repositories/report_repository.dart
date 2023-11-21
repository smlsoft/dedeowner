import 'package:dedeowner/api/clickhouse/clickhouse_api.dart';
import 'package:dedeowner/environment.dart';
import 'package:dedeowner/global_model.dart';
import 'package:get_storage/get_storage.dart';

import 'client.dart';
import 'package:dio/dio.dart';

class ReportRepository {
  final appConfig = GetStorage("AppConfig");

  Future<ApiResponse> getReportSaleSummaryDio(String fromdate, String todate) async {
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

  Future<ApiResponse> getReportSaleSummary(String fromdate, String todate) async {
    try {
      var shopid = appConfig.read("shopid");
      var where = "";
      if (fromdate.isNotEmpty && todate.isNotEmpty) {
        where = "  AND toDate(toDateTime(docdatetime, 'Asia/Bangkok'))  BETWEEN '$fromdate' AND '$todate' ";
      } else if (fromdate.isNotEmpty) {
        where = " ((docdatetime AT TIME ZONE 'UTC') AT TIME ZONE '+7')::date  >= '$fromdate' ";
      } else if (todate.isNotEmpty) {
        where = " ((docdatetime AT TIME ZONE 'UTC') AT TIME ZONE '+7')::date  <= '$todate' ";
      }
      String querySummaryShop = "SELECT shopid, ";
      querySummaryShop += " totaldiscountshop + totaldiscounttakeaway + totaldiscountdelivery AS totaldiscount, ";
      querySummaryShop += " totalamountshop + totalamounttakeaway + totalamountdelivery AS totalamount, ";
      querySummaryShop += " roundamountshop + roundamounttakeaway + roundamountdelivery AS roundamount, ";
      querySummaryShop += " paycashamountshop + paycashamounttakeaway + paycashamountdelivery AS paycashamount, ";
      querySummaryShop += " sumcreditcardshop + sumcreditcardtakeaway + sumcreditcarddelivery AS sumcreditcard, ";
      querySummaryShop += " summoneytransfershop + summoneytransfertakeaway + summoneytransferdelivery AS summoneytransfer, ";
      querySummaryShop += " sumcreditshop + sumcredittakeaway + sumcreditdelivery AS sumcredit, ";
      querySummaryShop += " sumqrcodeshop + sumqrcodetakeaway + sumqrcodedelivery AS sumqrcode, ";
      querySummaryShop += " totaldiscountshop, ";
      querySummaryShop += " totalamountshop, ";
      querySummaryShop += " roundamountshop, ";
      querySummaryShop += " paycashamountshop, ";
      querySummaryShop += " sumcreditcardshop, ";
      querySummaryShop += " summoneytransfershop, ";
      querySummaryShop += " sumcreditshop, ";
      querySummaryShop += " sumqrcodeshop, ";

      querySummaryShop += " totaldiscounttakeaway, ";
      querySummaryShop += " totalamounttakeaway, ";
      querySummaryShop += " roundamounttakeaway, ";
      querySummaryShop += " paycashamounttakeaway, ";
      querySummaryShop += " sumcreditcardtakeaway, ";
      querySummaryShop += " summoneytransfertakeaway, ";
      querySummaryShop += " sumcredittakeaway, ";
      querySummaryShop += " sumqrcodetakeaway, ";
      querySummaryShop += " totaldiscountdelivery, ";
      querySummaryShop += " totalamountdelivery, ";
      querySummaryShop += " roundamountdelivery, ";
      querySummaryShop += " paycashamountdelivery, ";
      querySummaryShop += " sumcreditcarddelivery, ";
      querySummaryShop += " summoneytransferdelivery, ";
      querySummaryShop += " sumcreditdelivery, ";
      querySummaryShop += " sumqrcodedelivery ";

      querySummaryShop += " FROM ( SELECT ";
      querySummaryShop += " shopid, ";
      querySummaryShop += " SUM(CASE WHEN takeaway = 0 THEN totaldiscount ELSE 0 END) AS totaldiscountshop, ";
      querySummaryShop += " SUM(CASE WHEN takeaway = 0 THEN totalamount ELSE 0 END) AS totalamountshop, ";
      querySummaryShop += " SUM(CASE WHEN takeaway = 0 THEN roundamount ELSE 0 END) AS roundamountshop, ";
      querySummaryShop += " SUM(CASE WHEN takeaway = 0 THEN paycashamount ELSE 0 END) AS paycashamountshop, ";
      querySummaryShop += " SUM(CASE WHEN takeaway = 0 THEN sumcreditcard ELSE 0 END) AS sumcreditcardshop, ";
      querySummaryShop += " SUM(CASE WHEN takeaway = 0 THEN summoneytransfer ELSE 0 END) AS summoneytransfershop, ";
      querySummaryShop += " SUM(CASE WHEN takeaway = 0 THEN sumcredit ELSE 0 END) AS sumcreditshop, ";
      querySummaryShop += " SUM(CASE WHEN takeaway = 0 THEN sumqrcode ELSE 0 END) AS sumqrcodeshop, ";

      querySummaryShop += " SUM(CASE WHEN takeaway = 1 AND (salechannelcode IS NULL OR salechannelcode = '') THEN totaldiscount ELSE 0 END) AS totaldiscounttakeaway, ";
      querySummaryShop += " SUM(CASE WHEN takeaway = 1 AND (salechannelcode IS NULL OR salechannelcode = '') THEN totalamount ELSE 0 END) AS totalamounttakeaway, ";
      querySummaryShop += " SUM(CASE WHEN takeaway = 1 AND (salechannelcode IS NULL OR salechannelcode = '') THEN roundamount ELSE 0 END) AS roundamounttakeaway, ";
      querySummaryShop += " SUM(CASE WHEN takeaway = 1 AND (salechannelcode IS NULL OR salechannelcode = '') THEN paycashamount ELSE 0 END) AS paycashamounttakeaway, ";
      querySummaryShop += " SUM(CASE WHEN takeaway = 1 AND (salechannelcode IS NULL OR salechannelcode = '') THEN sumcreditcard ELSE 0 END) AS sumcreditcardtakeaway, ";
      querySummaryShop += " SUM(CASE WHEN takeaway = 1 AND (salechannelcode IS NULL OR salechannelcode = '') THEN summoneytransfer ELSE 0 END) AS summoneytransfertakeaway, ";
      querySummaryShop += " SUM(CASE WHEN takeaway = 1 AND (salechannelcode IS NULL OR salechannelcode = '') THEN sumcredit ELSE 0 END) AS sumcredittakeaway, ";
      querySummaryShop += " SUM(CASE WHEN takeaway = 1 AND (salechannelcode IS NULL OR salechannelcode = '') THEN sumqrcode ELSE 0 END) AS sumqrcodetakeaway, ";

      querySummaryShop += " SUM(CASE WHEN takeaway = 1 AND salechannelcode IS NOT NULL AND salechannelcode != '' THEN totaldiscount ELSE 0 END) AS totaldiscountdelivery, ";
      querySummaryShop += " SUM(CASE WHEN takeaway = 1 AND salechannelcode IS NOT NULL AND salechannelcode != '' THEN totalamount ELSE 0 END) AS totalamountdelivery, ";
      querySummaryShop += " SUM(CASE WHEN takeaway = 1 AND salechannelcode IS NOT NULL AND salechannelcode != '' THEN roundamount ELSE 0 END) AS roundamountdelivery, ";
      querySummaryShop += " SUM(CASE WHEN takeaway = 1 AND salechannelcode IS NOT NULL AND salechannelcode != '' THEN paycashamount ELSE 0 END) AS paycashamountdelivery, ";
      querySummaryShop += " SUM(CASE WHEN takeaway = 1 AND salechannelcode IS NOT NULL AND salechannelcode != '' THEN sumcreditcard ELSE 0 END) AS sumcreditcarddelivery, ";
      querySummaryShop += " SUM(CASE WHEN takeaway = 1 AND salechannelcode IS NOT NULL AND salechannelcode != '' THEN summoneytransfer ELSE 0 END) AS summoneytransferdelivery, ";
      querySummaryShop += " SUM(CASE WHEN takeaway = 1 AND salechannelcode IS NOT NULL AND salechannelcode != '' THEN sumcredit ELSE 0 END) AS sumcreditdelivery, ";
      querySummaryShop += " SUM(CASE WHEN takeaway = 1 AND salechannelcode IS NOT NULL AND salechannelcode != '' THEN sumqrcode ELSE 0 END) AS sumqrcodedelivery ";
      querySummaryShop += " FROM dedebi.doc ";
      querySummaryShop += " WHERE shopid = '$shopid' $where ";
      querySummaryShop += " GROUP BY shopid ) as subquery";

      var responseShop = await clickHouseSelect(querySummaryShop);

      try {
        return ApiResponse.fromMap(responseShop);
      } catch (e) {
        throw Exception(e);
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  Future<ApiResponse> getReportSaleSummaryDetail(String fromdate, String todate) async {
    try {
      var shopid = appConfig.read("shopid");
      var where = "";
      if (fromdate.isNotEmpty && todate.isNotEmpty) {
        where = "  AND toDate(toDateTime(docdatetime, 'Asia/Bangkok'))  BETWEEN '$fromdate' AND '$todate' ";
      } else if (fromdate.isNotEmpty) {
        where = " AND toDate(toDateTime(docdatetime, 'Asia/Bangkok'))  >= '$fromdate' ";
      } else if (todate.isNotEmpty) {
        where = " AND toDate(toDateTime(docdatetime, 'Asia/Bangkok')) <= '$todate' ";
      }
      String querySummaryShop = " SELECT ";
      querySummaryShop +=
          "shopid,salechannelcode as code,salechannelcode as name,sum(totalamount) as amount,avg(salechannelgp) as gpPercent ,(avg(salechannelgp)*sum(totalamount))/100 as gpAmount ";
      querySummaryShop += " FROM dedebi.doc  ";
      querySummaryShop += " WHERE shopid = '$shopid' and salechannelcode IS NOT NULL and salechannelcode != ''  $where ";
      querySummaryShop += " GROUP BY shopid,salechannelcode";

      var responseShop = await clickHouseSelect(querySummaryShop);

      try {
        return ApiResponse.fromMap(responseShop);
      } catch (e) {
        throw Exception(e);
      }
    } catch (e) {
      print(e);
      throw Exception(e);
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

  Future<ApiResponse> getProductSales(String fromdate, String todate) async {
    Dio dio = Dio();
    final token = appConfig.read("token");
    print("getProductSales");
    try {
      final response = await dio.get('${Environment().config.reportApi}/salesummarypg/productsales?token=$token$fromdate$todate');
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

  Future<ApiResponse> getSaleByProduct(String keyword, int page) async {
    Dio dio = Dio();
    String search = "";
    if (keyword.isNotEmpty) {
      search = "&search=$keyword";
    }

    final token = appConfig.read("token");
    print(token);
    try {
      final response = await dio.get('${Environment().config.reportApi}/salesummarypg/salebyitems?token=$token&page=$page$search');
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
