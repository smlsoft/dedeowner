import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'salesumary_model.g.dart';

@JsonSerializable()
class SalesumaryModel {
  double cashierAmount;
  double cash;
  double takeAway;

  double qrcodeAmount;
  double walletAmount;
  double deliveryAmount;
  double gpAmount;
  List<WalletPaymentModel> qrcode;
  List<WalletPaymentModel> wallet;
  List<DeliveryPaymentModel> delivery;
  List<ProductModel> bestseller;
  List<ProductModel> bestsellershop;
  List<ProductModel> bestsellerdelivery;
  SalesumaryModel({
    required this.cashierAmount,
    required this.cash,
    required this.takeAway,
    required this.qrcode,
    required this.wallet,
    required this.delivery,
    required this.qrcodeAmount,
    required this.walletAmount,
    required this.deliveryAmount,
    required this.gpAmount,
    required this.bestseller,
    required this.bestsellershop,
    required this.bestsellerdelivery,
  });

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
