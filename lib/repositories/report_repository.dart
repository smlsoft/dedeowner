import 'dart:convert';

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

      String querySummaryRaw = " SELECT CASE WHEN takeaway = 0 THEN paymentdetailraw ELSE '[]' END AS paymentdetailrawshop,";
      querySummaryRaw += " CASE WHEN takeaway = 1 AND (salechannelcode IS NULL OR salechannelcode = '') THEN paymentdetailraw ELSE '[]' END AS paymentdetailrawtakeaway, ";
      querySummaryRaw += " CASE WHEN takeaway = 1 AND salechannelcode IS NOT NULL AND salechannelcode != ''  THEN paymentdetailraw ELSE '[]' END AS paymentdetailrawDelivery ";
      querySummaryRaw += " FROM dedebi.doc ";
      querySummaryRaw += " WHERE shopid = '$shopid' $where ";
      double sumQr = 0.0;
      double sumTransfer = 0.0;
      double sumCraditCard = 0.0;
      double sumQrTakeaway = 0.0;
      double sumTransferTakeaway = 0.0;
      double sumCraditCardTakeaway = 0.0;
      double sumQrDelivery = 0.0;
      double sumTransferDelivery = 0.0;
      double sumCraditCardDelivery = 0.0;
      var responseRaw = await clickHouseSelect(querySummaryRaw);
      if (responseRaw['success']) {
        for (var i = 0; i < responseRaw['data'].length; i++) {
          var jsonArrayShop = jsonDecode(responseRaw['data'][i]['paymentdetailrawshop']);
          if (jsonArrayShop is List) {
            for (var item in jsonArrayShop) {
              if (item['trans_flag'] == 5) {
                sumQr += item['amount'];
              } else if (item['trans_flag'] == 1) {
                sumCraditCard += item['amount'];
              } else if (item['trans_flag'] == 2) {
                sumTransfer += item['amount'];
              }
            }
          }
          var jsonArrayTakeAway = jsonDecode(responseRaw['data'][i]['paymentdetailrawtakeaway']);
          if (jsonArrayTakeAway is List) {
            for (var item in jsonArrayTakeAway) {
              if (item['trans_flag'] == 5) {
                sumQrTakeaway += item['amount'];
              } else if (item['trans_flag'] == 1) {
                sumCraditCardTakeaway += item['amount'];
              } else if (item['trans_flag'] == 2) {
                sumTransferTakeaway += item['amount'];
              }
            }
          }
          var jsonArrayDelivery = jsonDecode(responseRaw['data'][i]['paymentdetailrawDelivery']);
          if (jsonArrayDelivery is List) {
            for (var item in jsonArrayDelivery) {
              if (item['trans_flag'] == 5) {
                sumQrDelivery += item['amount'];
              } else if (item['trans_flag'] == 1) {
                sumTransferDelivery += item['amount'];
              } else if (item['trans_flag'] == 2) {
                sumCraditCardDelivery += item['amount'];
              }
            }
          }
        }
      }
      if (responseShop['data'].length > 0) {
        responseShop['data'][0]['sumqrcode'] = sumQr + sumQrTakeaway + sumQrDelivery;
        responseShop['data'][0]['summoneytransfer'] = sumTransfer + sumTransferTakeaway + sumTransferDelivery;
        responseShop['data'][0]['sumcreditcard'] = sumCraditCard + sumCraditCardTakeaway + sumCraditCardDelivery;

        responseShop['data'][0]['sumqrcodeshop'] = sumQr;
        responseShop['data'][0]['summoneytransfershop'] = sumTransfer;
        responseShop['data'][0]['sumcreditcardshop'] = sumCraditCard;

        responseShop['data'][0]['sumqrcodetakeaway'] = sumQrTakeaway;
        responseShop['data'][0]['summoneytransfertakeaway'] = sumTransferTakeaway;
        responseShop['data'][0]['sumcreditcardtakeaway'] = sumCraditCardTakeaway;
        responseShop['data'][0]['sumqrcodedelivery'] = sumQrDelivery;
        responseShop['data'][0]['summoneytransferdelivery'] = sumTransferDelivery;
        responseShop['data'][0]['sumcreditcarddelivery'] = sumCraditCardDelivery;
      }
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
          " shopid,salechannelcode as code,sc.name as name,sum(totalamount) as amount,avg(salechannelgp) as gpPercent ,(avg(salechannelgp)*sum(totalamount))/100 as gpAmount";
      querySummaryShop += " FROM dedebi.doc AS doc  LEFT JOIN dedebi.salechannel AS sc ON doc.salechannelcode  = sc.code and doc.shopid = sc.shopid ";
      querySummaryShop += " WHERE shopid = '$shopid' and salechannelcode IS NOT NULL and salechannelcode != ''  $where ";
      querySummaryShop += " GROUP BY doc.shopid,doc.salechannelcode,sc.name ";

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

  Future<ApiResponse> getReportSaleSummaryByManufacturer(String fromdate, String todate) async {
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
      String querySummary =
          " SELECT doc.barcode as barcode,p.name0 as itemname,doc.unitcode as unitcode,c.name1  as owner,sum(sumamount) as sumamount,doc.price as price,sum(qty) as qty ";
      querySummary += " FROM dedebi.docdetail AS doc";
      querySummary += " LEFT JOIN dedebi.creditors AS c ON doc.manufacturerguid = c.guidfixed and doc.shopid = c.shopid  ";
      querySummary += " LEFT JOIN dedebi.productbarcode AS p ON doc.barcode  = p.barcode  and doc.shopid = p.shopid  ";
      querySummary += " WHERE doc.shopid = '$shopid' $where ";
      querySummary += " GROUP BY  doc.barcode,p.name0,doc.unitcode,doc.price,c.name1  order by qty desc ";

      var response = await clickHouseSelect(querySummary);

      try {
        return ApiResponse.fromMap(response);
      } catch (e) {
        throw Exception(e);
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  Future<ApiResponse> getReportSaleSummaryByOwner(String fromdate, String todate, String owner) async {
    try {
      var shopid = appConfig.read("shopid");
      var where = "";

      if (owner.isNotEmpty) {
        where += " AND c.name1 = '$owner' ";
      }
      if (fromdate.isNotEmpty && todate.isNotEmpty) {
        where += "  AND toDate(toDateTime(docdatetime, 'Asia/Bangkok'))  BETWEEN '$fromdate' AND '$todate' ";
      } else if (fromdate.isNotEmpty) {
        where += " AND toDate(toDateTime(docdatetime, 'Asia/Bangkok'))  >= '$fromdate' ";
      } else if (todate.isNotEmpty) {
        where += " AND toDate(toDateTime(docdatetime, 'Asia/Bangkok')) <= '$todate' ";
      }

      String querySummary =
          " SELECT doc.barcode as barcode,p.name0 as itemname,doc.unitcode as unitcode,doc.manufacturerguid as manufacturerguid,c.name1  as owner,sum(sumamount) as sumamount,doc.price as price,sum(qty) as qty ";
      querySummary += " FROM dedebi.docdetail AS doc";
      querySummary += " LEFT JOIN dedebi.creditors AS c ON doc.manufacturerguid = c.guidfixed and doc.shopid = c.shopid  ";
      querySummary += " LEFT JOIN dedebi.productbarcode AS p ON doc.barcode  = p.barcode  and doc.shopid = p.shopid  ";
      querySummary += " WHERE doc.shopid = '$shopid' $where ";
      querySummary += " GROUP BY  doc.barcode,p.name0,doc.unitcode,doc.price,c.name1,doc.manufacturerguid  order by qty desc ";

      var response = await clickHouseSelect(querySummary);

      try {
        return ApiResponse.fromMap(response);
      } catch (e) {
        throw Exception(e);
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  // Future<ApiResponse> getReportSaleWeeklySummary(String fromdate, String todate) async {
  //   try {
  //     var shopid = appConfig.read("shopid");
  //     var where = "";
  //     if (fromdate.isNotEmpty && todate.isNotEmpty) {
  //       where = "  AND toDate(toDateTime(docdatetime, 'Asia/Bangkok'))  BETWEEN '$fromdate' AND '$todate' ";
  //     } else if (fromdate.isNotEmpty) {
  //       where = " AND toDate(toDateTime(docdatetime, 'Asia/Bangkok'))  >= '$fromdate' ";
  //     } else if (todate.isNotEmpty) {
  //       where = " AND toDate(toDateTime(docdatetime, 'Asia/Bangkok')) <= '$todate' ";
  //     }
  //     String querySummary =
  //         " SELECT docdatetime::date,sum(totalamount) as totalamount FROM dedebi.doc where shopid='$shopid' $where  group by shopid,docdate order by docdatetime asc ";

  //     var response = await clickHouseSelect(querySummary);

  //     try {
  //       return ApiResponse.fromMap(response);
  //     } catch (e) {
  //       throw Exception(e);
  //     }
  //   } catch (e) {
  //     print(e);
  //     throw Exception(e);
  //   }
  // }

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

  // Future<ApiResponse> getProductSales(String fromdate, String todate) async {
  //   Dio dio = Dio();
  //   final token = appConfig.read("token");
  //   print("getProductSales");
  //   try {
  //     final response = await dio.get('${Environment().config.reportApi}/salesummarypg/productsales?token=$token$fromdate$todate');
  //     try {
  //       return ApiResponse.fromMap(response.data);
  //     } catch (ex) {
  //       throw Exception(ex);
  //     }
  //   } on DioError catch (ex) {
  //     String errorMessage = ex.error.toString();
  //     throw Exception(errorMessage);
  //   }
  // }

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
