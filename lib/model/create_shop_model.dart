import 'package:json_annotation/json_annotation.dart';

part 'create_shop_model.g.dart';

@JsonSerializable()
class CreateShopModel {
  String branchcode;
  String name1;
  String profilepicture;
  String telephone;

  CreateShopModel({
    required this.branchcode,
    required this.name1,
    required this.profilepicture,
    required this.telephone,
  });

  factory CreateShopModel.fromJson(Map<String, dynamic> json) =>
      _$CreateShopModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateShopModelToJson(this);
}
