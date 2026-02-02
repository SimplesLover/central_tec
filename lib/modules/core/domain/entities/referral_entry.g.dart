// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'referral_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReferralEntry _$ReferralEntryFromJson(Map<String, dynamic> json) =>
    _ReferralEntry(
      id: json['id'] as String,
      referrerId: json['referrerId'] as String,
      referredUserId: json['referredUserId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ReferralEntryToJson(_ReferralEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'referrerId': instance.referrerId,
      'referredUserId': instance.referredUserId,
      'createdAt': instance.createdAt.toIso8601String(),
    };
