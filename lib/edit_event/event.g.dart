// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EventModel _$EventModelFromJson(Map<String, dynamic> json) => _EventModel(
      id: json['id'] as String,
      title: json['title'] as String,
      start: DateTime.parse(json['start'] as String),
      finish: DateTime.parse(json['finish'] as String),
      address: json['address'] as String?,
    );

Map<String, dynamic> _$EventModelToJson(_EventModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'start': instance.start.toIso8601String(),
      'finish': instance.finish.toIso8601String(),
      'address': instance.address,
    };
