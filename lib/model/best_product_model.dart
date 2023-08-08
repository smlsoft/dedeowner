import 'package:dedeowner/model/global_model.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'best_product_model.g.dart';

@JsonSerializable()
class BestProductModel {
  String shopid;
  double qty;
  String unitcode;
  List<LanguageDataModel> names;
  BestProductModel({
    String? shopid,
    double? qty,
    String? unitcode,
    List<LanguageDataModel>? names,
  })  : shopid = shopid ?? "",
        unitcode = unitcode ?? "",
        qty = qty ?? 0,
        names = names ?? [];

  factory BestProductModel.fromJson(Map<String, dynamic> json) => _$BestProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$BestProductModelToJson(this);
}
