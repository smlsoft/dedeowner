// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'global_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SortDataModel _$SortDataModelFromJson(Map<String, dynamic> json) =>
    SortDataModel(
      code: json['code'] as String,
      xorder: json['xorder'] as int,
    );

Map<String, dynamic> _$SortDataModelToJson(SortDataModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'xorder': instance.xorder,
    };

XSortModel _$XSortModelFromJson(Map<String, dynamic> json) => XSortModel(
      guidfixed: json['guidfixed'] as String,
      xorder: json['xorder'] as int,
      code: json['code'] as String,
    );

Map<String, dynamic> _$XSortModelToJson(XSortModel instance) =>
    <String, dynamic>{
      'guidfixed': instance.guidfixed,
      'code': instance.code,
      'xorder': instance.xorder,
    };

LanguageDataModel _$LanguageDataModelFromJson(Map<String, dynamic> json) =>
    LanguageDataModel(
      code: json['code'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$LanguageDataModelToJson(LanguageDataModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
    };

LanguageSystemModel _$LanguageSystemModelFromJson(Map<String, dynamic> json) =>
    LanguageSystemModel(
      code: json['code'] as String,
      text: json['text'] as String,
    );

Map<String, dynamic> _$LanguageSystemModelToJson(
        LanguageSystemModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'text': instance.text,
    };

LanguageSystemCodeModel _$LanguageSystemCodeModelFromJson(
        Map<String, dynamic> json) =>
    LanguageSystemCodeModel(
      code: json['code'] as String,
      langs: (json['langs'] as List<dynamic>)
          .map((e) => LanguageSystemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LanguageSystemCodeModelToJson(
        LanguageSystemCodeModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'langs': instance.langs.map((e) => e.toJson()).toList(),
    };

ImageUpload _$ImageUploadFromJson(Map<String, dynamic> json) => ImageUpload(
      uri: json['uri'] as String,
    );

Map<String, dynamic> _$ImageUploadToJson(ImageUpload instance) =>
    <String, dynamic>{
      'uri': instance.uri,
    };

ImagesModel _$ImagesModelFromJson(Map<String, dynamic> json) => ImagesModel(
      uri: json['uri'] as String,
      xorder: json['xorder'] as int,
    );

Map<String, dynamic> _$ImagesModelToJson(ImagesModel instance) =>
    <String, dynamic>{
      'uri': instance.uri,
      'xorder': instance.xorder,
    };
