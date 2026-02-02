// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'points_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PointsEntry _$PointsEntryFromJson(Map<String, dynamic> json) => _PointsEntry(
  id: json['id'] as String,
  userId: json['userId'] as String,
  points: (json['points'] as num).toInt(),
  source: json['source'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$PointsEntryToJson(_PointsEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'points': instance.points,
      'source': instance.source,
      'createdAt': instance.createdAt.toIso8601String(),
    };
