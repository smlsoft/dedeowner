import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'salesumarybyday_model.g.dart';

@JsonSerializable()
class SalesumaryByDayModel {
  double monday;
  double tuesday;
  double wednesday;
  double thursday;
  double friday;
  double saturday;
  double sunday;

  SalesumaryByDayModel({
    double? monday,
    double? tuesday,
    double? wednesday,
    double? thursday,
    double? friday,
    double? saturday,
    double? sunday,
  })  : monday = monday ?? 0,
        tuesday = tuesday ?? 0,
        wednesday = wednesday ?? 0,
        thursday = thursday ?? 0,
        friday = friday ?? 0,
        saturday = saturday ?? 0,
        sunday = sunday ?? 0;

  factory SalesumaryByDayModel.fromJson(Map<String, dynamic> json) => _$SalesumaryByDayModelFromJson(json);

  Map<String, dynamic> toJson() => _$SalesumaryByDayModelToJson(this);
}
