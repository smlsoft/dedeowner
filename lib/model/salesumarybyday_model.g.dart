// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salesumarybyday_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SalesumaryByDayModel _$SalesumaryByDayModelFromJson(
        Map<String, dynamic> json) =>
    SalesumaryByDayModel(
      monday: (json['monday'] as num?)?.toDouble(),
      tuesday: (json['tuesday'] as num?)?.toDouble(),
      wednesday: (json['wednesday'] as num?)?.toDouble(),
      thursday: (json['thursday'] as num?)?.toDouble(),
      friday: (json['friday'] as num?)?.toDouble(),
      saturday: (json['saturday'] as num?)?.toDouble(),
      sunday: (json['sunday'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$SalesumaryByDayModelToJson(
        SalesumaryByDayModel instance) =>
    <String, dynamic>{
      'monday': instance.monday,
      'tuesday': instance.tuesday,
      'wednesday': instance.wednesday,
      'thursday': instance.thursday,
      'friday': instance.friday,
      'saturday': instance.saturday,
      'sunday': instance.sunday,
    };
