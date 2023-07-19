import 'package:json_annotation/json_annotation.dart';

part 'shop_model.g.dart';

@JsonSerializable()
class ShopModel {
  String shopid;
  String name;
  String branchcode;
  int role;
  bool isfavorite;
  String lastaccessedat;

  ShopModel({
    required this.shopid,
    required this.name,
    required this.branchcode,
    required this.role,
    required this.isfavorite,
    required this.lastaccessedat,
  });

  factory ShopModel.fromJson(Map<String, dynamic> json) =>
      _$ShopModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShopModelToJson(this);
}
