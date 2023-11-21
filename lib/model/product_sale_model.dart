import 'package:dedeowner/model/global_model.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_sale_model.g.dart';

@JsonSerializable()
class ProductSaleModel {
  String shopid;
  double qty;
  double price;
  double sumamount;
  String unitcode;
  String barcode;
  String owner;
  String itemname;
  List<LanguageDataModel> names;
  ProductSaleModel({
    String? shopid,
    String? owner,
    String? itemname,
    double? qty,
    double? price,
    double? sumamount,
    String? unitcode,
    String? barcode,
    List<LanguageDataModel>? names,
  })  : shopid = shopid ?? "",
        unitcode = unitcode ?? "",
        itemname = itemname ?? "",
        barcode = barcode ?? "",
        owner = owner ?? "",
        qty = qty ?? 0,
        price = price ?? 0,
        sumamount = sumamount ?? 0,
        names = names ?? [];

  factory ProductSaleModel.fromJson(Map<String, dynamic> json) => _$ProductSaleModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductSaleModelToJson(this);
}
