// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WalletTransaction _$WalletTransactionFromJson(Map<String, dynamic> json) =>
    _WalletTransaction(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: $enumDecode(_$WalletTransactionTypeEnumMap, json['type']),
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$WalletTransactionToJson(_WalletTransaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'type': _$WalletTransactionTypeEnumMap[instance.type]!,
      'amount': instance.amount,
      'description': instance.description,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$WalletTransactionTypeEnumMap = {
  WalletTransactionType.commission: 'commission',
  WalletTransactionType.cashback: 'cashback',
  WalletTransactionType.pointsConversion: 'pointsConversion',
  WalletTransactionType.withdrawal: 'withdrawal',
};
