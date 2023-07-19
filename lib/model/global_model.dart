import 'package:json_annotation/json_annotation.dart';

part 'global_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SortDataModel {
  String code;
  int xorder;

  SortDataModel({required this.code, required this.xorder});

  factory SortDataModel.fromJson(Map<String, dynamic> json) =>
      _$SortDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$SortDataModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class XSortModel {
  String guidfixed;
  String code;
  int xorder;

  XSortModel({
    required this.guidfixed,
    required this.xorder,
    required this.code,
  });

  factory XSortModel.fromJson(Map<String, dynamic> json) =>
      _$XSortModelFromJson(json);

  Map<String, dynamic> toJson() => _$XSortModelToJson(this);
}

class LanguageModel {
  String code;
  String codeTranslator;
  String name;
  bool use;

  LanguageModel(
      {required this.code,
      required this.codeTranslator,
      required this.name,
      required this.use});
}

@JsonSerializable(explicitToJson: true)
class LanguageDataModel {
  String code;
  String name;

  LanguageDataModel({required this.code, required this.name});

  factory LanguageDataModel.fromJson(Map<String, dynamic> json) =>
      _$LanguageDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$LanguageDataModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class LanguageSystemModel {
  String code;
  String text;

  LanguageSystemModel({required this.code, required this.text});

  factory LanguageSystemModel.fromJson(Map<String, dynamic> json) =>
      _$LanguageSystemModelFromJson(json);
  Map<String, dynamic> toJson() => _$LanguageSystemModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class LanguageSystemCodeModel {
  String code;
  List<LanguageSystemModel> langs;

  LanguageSystemCodeModel({required this.code, required this.langs});

  factory LanguageSystemCodeModel.fromJson(Map<String, dynamic> json) =>
      _$LanguageSystemCodeModelFromJson(json);
  Map<String, dynamic> toJson() => _$LanguageSystemCodeModelToJson(this);
}

@JsonSerializable()
class ImageUpload {
  String uri;

  ImageUpload({
    required this.uri,
  });

  factory ImageUpload.fromJson(Map<String, dynamic> json) =>
      _$ImageUploadFromJson(json);

  Map<String, dynamic> toJson() => _$ImageUploadToJson(this);
}

@JsonSerializable()
class ImagesModel {
  String uri;
  int xorder;

  ImagesModel({
    required this.uri,
    required this.xorder,
  });

  factory ImagesModel.fromJson(Map<String, dynamic> json) =>
      _$ImagesModelFromJson(json);

  Map<String, dynamic> toJson() => _$ImagesModelToJson(this);
}

class SearchCodeAndNameModel {
  String code;
  List<LanguageDataModel> name;

  SearchCodeAndNameModel({required this.code, required this.name});
}
