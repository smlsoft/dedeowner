// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'global_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HttpGetDataModel _$HttpGetDataModelFromJson(Map<String, dynamic> json) =>
    HttpGetDataModel(
      code: json['code'] as String,
      json: json['json'] as String,
    );

Map<String, dynamic> _$HttpGetDataModelToJson(HttpGetDataModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'json': instance.json,
    };

HttpParameterModel _$HttpParameterModelFromJson(Map<String, dynamic> json) =>
    HttpParameterModel(
      parentGuid: json['parentGuid'] as String? ?? "",
      guid: json['guid'] as String? ?? "",
      barcode: json['barcode'] as String? ?? "",
      jsonData: json['jsonData'] as String? ?? "",
      holdCode: json['holdCode'] as String? ?? "",
      docMode: json['docMode'] as int? ?? 0,
    );

Map<String, dynamic> _$HttpParameterModelToJson(HttpParameterModel instance) =>
    <String, dynamic>{
      'parentGuid': instance.parentGuid,
      'guid': instance.guid,
      'barcode': instance.barcode,
      'jsonData': instance.jsonData,
      'holdCode': instance.holdCode,
      'docMode': instance.docMode,
    };

ResponseDataModel _$ResponseDataModelFromJson(Map<String, dynamic> json) =>
    ResponseDataModel(
      data: json['data'],
    );

Map<String, dynamic> _$ResponseDataModelToJson(ResponseDataModel instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
