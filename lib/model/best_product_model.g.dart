// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'best_product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BestProductModel _$BestProductModelFromJson(Map<String, dynamic> json) =>
    BestProductModel(
      shopid: json['shopid'] as String?,
      itemname: json['itemname'] as String?,
      qty: (json['qty'] as num?)?.toDouble(),
      unitcode: json['unitcode'] as String?,
      sumamount: (json['sumamount'] as num?)?.toDouble(),
      price: (json['price'] as num?)?.toDouble(),
      names: (json['names'] as List<dynamic>?)
          ?.map((e) => LanguageDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BestProductModelToJson(BestProductModel instance) =>
    <String, dynamic>{
      'shopid': instance.shopid,
      'qty': instance.qty,
      'unitcode': instance.unitcode,
      'price': instance.price,
      'sumamount': instance.sumamount,
      'itemname': instance.itemname,
      'names': instance.names,
    };
