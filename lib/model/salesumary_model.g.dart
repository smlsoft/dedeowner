// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salesumary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SalesumaryModel _$SalesumaryModelFromJson(Map<String, dynamic> json) =>
    SalesumaryModel(
      cashierAmount: (json['cashierAmount'] as num).toDouble(),
      cash: (json['cash'] as num).toDouble(),
      takeAway: (json['takeAway'] as num).toDouble(),
      qrcode: (json['qrcode'] as List<dynamic>)
          .map((e) => WalletPaymentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      wallet: (json['wallet'] as List<dynamic>)
          .map((e) => WalletPaymentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      delivery: (json['delivery'] as List<dynamic>)
          .map((e) => DeliveryPaymentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      qrcodeAmount: (json['qrcodeAmount'] as num).toDouble(),
      walletAmount: (json['walletAmount'] as num).toDouble(),
      deliveryAmount: (json['deliveryAmount'] as num).toDouble(),
      gpAmount: (json['gpAmount'] as num).toDouble(),
      bestseller: (json['bestseller'] as List<dynamic>)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      bestsellershop: (json['bestsellershop'] as List<dynamic>)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      bestsellerdelivery: (json['bestsellerdelivery'] as List<dynamic>)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SalesumaryModelToJson(SalesumaryModel instance) =>
    <String, dynamic>{
      'cashierAmount': instance.cashierAmount,
      'cash': instance.cash,
      'takeAway': instance.takeAway,
      'qrcodeAmount': instance.qrcodeAmount,
      'walletAmount': instance.walletAmount,
      'deliveryAmount': instance.deliveryAmount,
      'gpAmount': instance.gpAmount,
      'qrcode': instance.qrcode,
      'wallet': instance.wallet,
      'delivery': instance.delivery,
      'bestseller': instance.bestseller,
      'bestsellershop': instance.bestsellershop,
      'bestsellerdelivery': instance.bestsellerdelivery,
    };

WalletPaymentModel _$WalletPaymentModelFromJson(Map<String, dynamic> json) =>
    WalletPaymentModel(
      code: json['code'] as String,
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
    );

Map<String, dynamic> _$WalletPaymentModelToJson(WalletPaymentModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
      'amount': instance.amount,
    };

DeliveryPaymentModel _$DeliveryPaymentModelFromJson(
        Map<String, dynamic> json) =>
    DeliveryPaymentModel(
      code: json['code'] as String,
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
      gpPercent: (json['gpPercent'] as num).toDouble(),
      gpAmount: (json['gpAmount'] as num).toDouble(),
    );

Map<String, dynamic> _$DeliveryPaymentModelToJson(
        DeliveryPaymentModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
      'amount': instance.amount,
      'gpPercent': instance.gpPercent,
      'gpAmount': instance.gpAmount,
    };

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
      imgUri: json['imgUri'] as String,
      barcode: json['barcode'] as String,
      name: json['name'] as String,
      qty: (json['qty'] as num).toDouble(),
      unit: json['unit'] as String,
    );

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'imgUri': instance.imgUri,
      'barcode': instance.barcode,
      'name': instance.name,
      'unit': instance.unit,
      'qty': instance.qty,
    };
