import 'package:freezed_annotation/freezed_annotation.dart';

part 'points_entry.freezed.dart';
part 'points_entry.g.dart';

@freezed
abstract class PointsEntry with _$PointsEntry {
  const factory PointsEntry({
    required String id,
    required String userId,
    required int points,
    required String source,
    required DateTime createdAt,
  }) = _PointsEntry;

  factory PointsEntry.fromJson(Map<String, dynamic> json) =>
      _$PointsEntryFromJson(json);
}
