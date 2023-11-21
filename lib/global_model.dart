import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'global_model.g.dart';

enum PayScreenNumberPadWidgetEnum {
  text,
  number,
}

class SyncMasterStatusModel {
  late String tableName;
  late String lastUpdate;
}

@JsonSerializable(explicitToJson: true)
class HttpGetDataModel {
  String code;
  String json;

  HttpGetDataModel({required this.code, required this.json});

  factory HttpGetDataModel.fromJson(Map<String, dynamic> json) => _$HttpGetDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$HttpGetDataModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class HttpParameterModel {
  String parentGuid;
  String guid;
  String barcode;
  String jsonData;
  String holdCode;
  int docMode;

  HttpParameterModel({this.parentGuid = "", this.guid = "", this.barcode = "", this.jsonData = "", this.holdCode = "", this.docMode = 0});

  factory HttpParameterModel.fromJson(Map<String, dynamic> json) => _$HttpParameterModelFromJson(json);
  Map<String, dynamic> toJson() => _$HttpParameterModelToJson(this);
}

class HttpPost {
  late String command;
  late String data;

  HttpPost({required this.command, this.data = ""});

  Map toJson() => {
        'command': command,
        'data': data,
      };

  factory HttpPost.fromJson(Map<String, dynamic> json) {
    return HttpPost(
      command: json['command'],
      data: json['data'],
    );
  }
}

class PosProcessResultModel {
  String lineGuid;
  int lastCommandCode;

  PosProcessResultModel({this.lineGuid = "", this.lastCommandCode = 0});
}

class InformationModel {
  // 0=Image,1=Video
  int mode = 0;
  String sourceUrl = "";
  int delaySecond = 10;

  InformationModel({required this.mode, required delaySecond, required this.sourceUrl});
}

@JsonSerializable()
class ResponseDataModel {
  dynamic? data;

  ResponseDataModel({
    required this.data,
  });

  factory ResponseDataModel.fromJson(Map<String, dynamic> json) => _$ResponseDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$ResponseDataModelToJson(this);
}

class MoneyRoundPayModel {
  double begin;
  double end;
  double value;

  MoneyRoundPayModel({
    required this.begin,
    required this.end,
    required this.value,
  });
}
