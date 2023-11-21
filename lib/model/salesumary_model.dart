import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'salesumary_model.g.dart';

@JsonSerializable()
class SalesumaryModel {
  String shopid;
  double totalamount;
  double totaldiscount;
  double roundamount;
  double paycashamount;
  double sumcreditcard;
  double summoneytransfer;
  double sumcredit;
  double sumqrcode;
  double totaldiscountshop;
  double totalamountshop;
  double roundamountshop;
  double paycashamountshop;
  double sumcreditcardshop;
  double summoneytransfershop;
  double sumcreditshop;
  double sumqrcodeshop;
  double totaldiscounttakeaway;
  double totalamounttakeaway;
  double roundamounttakeaway;
  double paycashamounttakeaway;
  double sumcreditcardtakeaway;
  double summoneytransfertakeaway;
  double sumcredittakeaway;
  double sumqrcodetakeaway;
  double totaldiscountdelivery;
  double totalamountdelivery;
  double roundamountdelivery;
  double paycashamountdelivery;
  double sumcreditcarddelivery;
  double summoneytransferdelivery;
  double sumcreditdelivery;
  double sumqrcodedelivery;

  // List<WalletPaymentModel> qrcode;
  // List<WalletPaymentModel> wallet;
  // List<DeliveryPaymentModel> delivery;

  SalesumaryModel({
    String? shopid,
    double? totalamount,
    double? totaldiscount,
    double? roundamount,
    double? paycashamount,
    double? sumcreditcard,
    double? summoneytransfer,
    double? sumcredit,
    double? sumqrcode,
    double? totaldiscountshop,
    double? totalamountshop,
    double? roundamountshop,
    double? paycashamountshop,
    double? sumcreditcardshop,
    double? summoneytransfershop,
    double? sumcreditshop,
    double? sumqrcodeshop,
    double? totaldiscounttakeaway,
    double? totalamounttakeaway,
    double? roundamounttakeaway,
    double? paycashamounttakeaway,
    double? sumcreditcardtakeaway,
    double? summoneytransfertakeaway,
    double? sumcredittakeaway,
    double? sumqrcodetakeaway,
    double? totaldiscountdelivery,
    double? totalamountdelivery,
    double? roundamountdelivery,
    double? paycashamountdelivery,
    double? sumcreditcarddelivery,
    double? summoneytransferdelivery,
    double? sumcreditdelivery,
    double? sumqrcodedelivery,
  })  : shopid = shopid ?? "",
        totalamount = totalamount ?? 0,
        totaldiscount = totaldiscount ?? 0,
        roundamount = roundamount ?? 0,
        paycashamount = paycashamount ?? 0,
        sumcreditcard = sumcreditcard ?? 0,
        summoneytransfer = summoneytransfer ?? 0,
        sumcredit = sumcredit ?? 0,
        sumqrcode = sumqrcode ?? 0,
        totaldiscountshop = totaldiscountshop ?? 0,
        totalamountshop = totalamountshop ?? 0,
        roundamountshop = roundamountshop ?? 0,
        paycashamountshop = paycashamountshop ?? 0,
        sumcreditcardshop = sumcreditcardshop ?? 0,
        summoneytransfershop = summoneytransfershop ?? 0,
        sumcreditshop = sumcreditshop ?? 0,
        sumqrcodeshop = sumqrcodeshop ?? 0,
        totaldiscounttakeaway = totaldiscounttakeaway ?? 0,
        totalamounttakeaway = totalamounttakeaway ?? 0,
        roundamounttakeaway = roundamounttakeaway ?? 0,
        paycashamounttakeaway = paycashamounttakeaway ?? 0,
        sumcreditcardtakeaway = sumcreditcardtakeaway ?? 0,
        summoneytransfertakeaway = summoneytransfertakeaway ?? 0,
        sumcredittakeaway = sumcredittakeaway ?? 0,
        sumqrcodetakeaway = sumqrcodetakeaway ?? 0,
        totaldiscountdelivery = totaldiscountdelivery ?? 0,
        totalamountdelivery = totalamountdelivery ?? 0,
        roundamountdelivery = roundamountdelivery ?? 0,
        paycashamountdelivery = paycashamountdelivery ?? 0,
        sumcreditcarddelivery = sumcreditcarddelivery ?? 0,
        summoneytransferdelivery = summoneytransferdelivery ?? 0,
        sumcreditdelivery = sumcreditdelivery ?? 0,
        sumqrcodedelivery = sumqrcodedelivery ?? 0;

  factory SalesumaryModel.fromJson(Map<String, dynamic> json) => _$SalesumaryModelFromJson(json);

  Map<String, dynamic> toJson() => _$SalesumaryModelToJson(this);
}

@JsonSerializable()
class WalletPaymentModel {
  String code;
  String name;
  double amount;

  WalletPaymentModel({required this.code, required this.name, required this.amount});

  factory WalletPaymentModel.fromJson(Map<String, dynamic> json) => _$WalletPaymentModelFromJson(json);

  Map<String, dynamic> toJson() => _$WalletPaymentModelToJson(this);
}

@JsonSerializable()
class DeliveryPaymentModel {
  String code;
  String name;
  double amount;
  double gpPercent;
  double gpAmount;
  DeliveryPaymentModel({required this.code, required this.name, required this.amount, required this.gpPercent, required this.gpAmount});

  factory DeliveryPaymentModel.fromJson(Map<String, dynamic> json) => _$DeliveryPaymentModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryPaymentModelToJson(this);
}

@JsonSerializable()
class ProductModel {
  String imgUri;
  String barcode;
  String name;
  String unit;
  double qty;

  ProductModel({required this.imgUri, required this.barcode, required this.name, required this.qty, required this.unit});

  factory ProductModel.fromJson(Map<String, dynamic> json) => _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}

class ChartData {
  final String label;
  final double value;
  final Color color;

  ChartData(this.label, this.value, this.color);
}
