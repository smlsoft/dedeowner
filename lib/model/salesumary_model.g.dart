// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salesumary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SalesumaryModel _$SalesumaryModelFromJson(Map<String, dynamic> json) =>
    SalesumaryModel(
      shopid: json['shopid'] as String?,
      totalamount: (json['totalamount'] as num?)?.toDouble(),
      totaldiscount: (json['totaldiscount'] as num?)?.toDouble(),
      roundamount: (json['roundamount'] as num?)?.toDouble(),
      paycashamount: (json['paycashamount'] as num?)?.toDouble(),
      sumcreditcard: (json['sumcreditcard'] as num?)?.toDouble(),
      summoneytransfer: (json['summoneytransfer'] as num?)?.toDouble(),
      sumcredit: (json['sumcredit'] as num?)?.toDouble(),
      sumqrcode: (json['sumqrcode'] as num?)?.toDouble(),
      totaldiscountshop: (json['totaldiscountshop'] as num?)?.toDouble(),
      totalamountshop: (json['totalamountshop'] as num?)?.toDouble(),
      roundamountshop: (json['roundamountshop'] as num?)?.toDouble(),
      paycashamountshop: (json['paycashamountshop'] as num?)?.toDouble(),
      sumcreditcardshop: (json['sumcreditcardshop'] as num?)?.toDouble(),
      summoneytransfershop: (json['summoneytransfershop'] as num?)?.toDouble(),
      sumcreditshop: (json['sumcreditshop'] as num?)?.toDouble(),
      sumqrcodeshop: (json['sumqrcodeshop'] as num?)?.toDouble(),
      totaldiscounttakeaway:
          (json['totaldiscounttakeaway'] as num?)?.toDouble(),
      totalamounttakeaway: (json['totalamounttakeaway'] as num?)?.toDouble(),
      roundamounttakeaway: (json['roundamounttakeaway'] as num?)?.toDouble(),
      paycashamounttakeaway:
          (json['paycashamounttakeaway'] as num?)?.toDouble(),
      sumcreditcardtakeaway:
          (json['sumcreditcardtakeaway'] as num?)?.toDouble(),
      summoneytransfertakeaway:
          (json['summoneytransfertakeaway'] as num?)?.toDouble(),
      sumcredittakeaway: (json['sumcredittakeaway'] as num?)?.toDouble(),
      sumqrcodetakeaway: (json['sumqrcodetakeaway'] as num?)?.toDouble(),
      totaldiscountdelivery:
          (json['totaldiscountdelivery'] as num?)?.toDouble(),
      totalamountdelivery: (json['totalamountdelivery'] as num?)?.toDouble(),
      roundamountdelivery: (json['roundamountdelivery'] as num?)?.toDouble(),
      paycashamountdelivery:
          (json['paycashamountdelivery'] as num?)?.toDouble(),
      sumcreditcarddelivery:
          (json['sumcreditcarddelivery'] as num?)?.toDouble(),
      summoneytransferdelivery:
          (json['summoneytransferdelivery'] as num?)?.toDouble(),
      sumcreditdelivery: (json['sumcreditdelivery'] as num?)?.toDouble(),
      sumqrcodedelivery: (json['sumqrcodedelivery'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$SalesumaryModelToJson(SalesumaryModel instance) =>
    <String, dynamic>{
      'shopid': instance.shopid,
      'totalamount': instance.totalamount,
      'totaldiscount': instance.totaldiscount,
      'roundamount': instance.roundamount,
      'paycashamount': instance.paycashamount,
      'sumcreditcard': instance.sumcreditcard,
      'summoneytransfer': instance.summoneytransfer,
      'sumcredit': instance.sumcredit,
      'sumqrcode': instance.sumqrcode,
      'totaldiscountshop': instance.totaldiscountshop,
      'totalamountshop': instance.totalamountshop,
      'roundamountshop': instance.roundamountshop,
      'paycashamountshop': instance.paycashamountshop,
      'sumcreditcardshop': instance.sumcreditcardshop,
      'summoneytransfershop': instance.summoneytransfershop,
      'sumcreditshop': instance.sumcreditshop,
      'sumqrcodeshop': instance.sumqrcodeshop,
      'totaldiscounttakeaway': instance.totaldiscounttakeaway,
      'totalamounttakeaway': instance.totalamounttakeaway,
      'roundamounttakeaway': instance.roundamounttakeaway,
      'paycashamounttakeaway': instance.paycashamounttakeaway,
      'sumcreditcardtakeaway': instance.sumcreditcardtakeaway,
      'summoneytransfertakeaway': instance.summoneytransfertakeaway,
      'sumcredittakeaway': instance.sumcredittakeaway,
      'sumqrcodetakeaway': instance.sumqrcodetakeaway,
      'totaldiscountdelivery': instance.totaldiscountdelivery,
      'totalamountdelivery': instance.totalamountdelivery,
      'roundamountdelivery': instance.roundamountdelivery,
      'paycashamountdelivery': instance.paycashamountdelivery,
      'sumcreditcarddelivery': instance.sumcreditcarddelivery,
      'summoneytransferdelivery': instance.summoneytransferdelivery,
      'sumcreditdelivery': instance.sumcreditdelivery,
      'sumqrcodedelivery': instance.sumqrcodedelivery,
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
