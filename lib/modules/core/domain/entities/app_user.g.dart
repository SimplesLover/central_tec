// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppUser _$AppUserFromJson(Map<String, dynamic> json) => _AppUser(
  id: json['id'] as String,
  fullName: json['fullName'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String,
  passwordHash: json['passwordHash'] as String,
  referralCode: json['referralCode'] as String,
  referredByCode: json['referredByCode'] as String?,
  isActive: json['isActive'] as bool,
  points: (json['points'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$AppUserToJson(_AppUser instance) => <String, dynamic>{
  'id': instance.id,
  'fullName': instance.fullName,
  'email': instance.email,
  'phone': instance.phone,
  'passwordHash': instance.passwordHash,
  'referralCode': instance.referralCode,
  'referredByCode': instance.referredByCode,
  'isActive': instance.isActive,
  'points': instance.points,
  'createdAt': instance.createdAt.toIso8601String(),
};
