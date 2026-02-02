import 'package:freezed_annotation/freezed_annotation.dart';

part 'referral_entry.freezed.dart';
part 'referral_entry.g.dart';

@freezed
abstract class ReferralEntry with _$ReferralEntry {
  const factory ReferralEntry({
    required String id,
    required String referrerId,
    required String referredUserId,
    required DateTime createdAt,
  }) = _ReferralEntry;

  factory ReferralEntry.fromJson(Map<String, dynamic> json) =>
      _$ReferralEntryFromJson(json);
}
