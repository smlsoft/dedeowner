// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_sale_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductSaleModel _$ProductSaleModelFromJson(Map<String, dynamic> json) =>
    ProductSaleModel(
      shopid: json['shopid'] as String?,
      qty: (json['qty'] as num?)?.toDouble(),
      price: (json['price'] as num?)?.toDouble(),
      unitcode: json['unitcode'] as String?,
      barcode: json['barcode'] as String?,
      names: (json['names'] as List<dynamic>?)
          ?.map((e) => LanguageDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductSaleModelToJson(ProductSaleModel instance) =>
    <String, dynamic>{
      'shopid': instance.shopid,
      'qty': instance.qty,
      'price': instance.price,
      'unitcode': instance.unitcode,
      'barcode': instance.barcode,
      'names': instance.names,
    };
