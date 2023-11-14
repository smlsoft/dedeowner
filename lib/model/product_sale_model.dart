import 'package:dedeowner/model/global_model.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_sale_model.g.dart';

@JsonSerializable()
class ProductSaleModel {
  String shopid;
  double qty;
  double price;
  String unitcode;
  String barcode;
  List<LanguageDataModel> names;
  ProductSaleModel({
    String? shopid,
    double? qty,
    double? price,
    String? unitcode,
    String? barcode,
    List<LanguageDataModel>? names,
  })  : shopid = shopid ?? "",
        unitcode = unitcode ?? "",
        barcode = barcode ?? "",
        qty = qty ?? 0,
        price = price ?? 0,
        names = names ?? [];

  factory ProductSaleModel.fromJson(Map<String, dynamic> json) => _$ProductSaleModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductSaleModelToJson(this);
}
