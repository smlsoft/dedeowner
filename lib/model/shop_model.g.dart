// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShopModel _$ShopModelFromJson(Map<String, dynamic> json) => ShopModel(
      names: (json['names'] as List<dynamic>?)
          ?.map((e) => LanguageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      shopid: json['shopid'] as String,
      name: json['name'] as String,
      branchcode: json['branchcode'] as String,
      role: json['role'] as int,
      isfavorite: json['isfavorite'] as bool,
      lastaccessedat: json['lastaccessedat'] as String,
    );

Map<String, dynamic> _$ShopModelToJson(ShopModel instance) => <String, dynamic>{
      'shopid': instance.shopid,
      'name': instance.name,
      'names': instance.names,
      'branchcode': instance.branchcode,
      'role': instance.role,
      'isfavorite': instance.isfavorite,
      'lastaccessedat': instance.lastaccessedat,
    };
