// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'referral_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReferralEntry {

 String get id; String get referrerId; String get referredUserId; DateTime get createdAt;
/// Create a copy of ReferralEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReferralEntryCopyWith<ReferralEntry> get copyWith => _$ReferralEntryCopyWithImpl<ReferralEntry>(this as ReferralEntry, _$identity);

  /// Serializes this ReferralEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReferralEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.referrerId, referrerId) || other.referrerId == referrerId)&&(identical(other.referredUserId, referredUserId) || other.referredUserId == referredUserId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,referrerId,referredUserId,createdAt);

@override
String toString() {
  return 'ReferralEntry(id: $id, referrerId: $referrerId, referredUserId: $referredUserId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ReferralEntryCopyWith<$Res>  {
  factory $ReferralEntryCopyWith(ReferralEntry value, $Res Function(ReferralEntry) _then) = _$ReferralEntryCopyWithImpl;
@useResult
$Res call({
 String id, String referrerId, String referredUserId, DateTime createdAt
});




}
/// @nodoc
class _$ReferralEntryCopyWithImpl<$Res>
    implements $ReferralEntryCopyWith<$Res> {
  _$ReferralEntryCopyWithImpl(this._self, this._then);

  final ReferralEntry _self;
  final $Res Function(ReferralEntry) _then;

/// Create a copy of ReferralEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? referrerId = null,Object? referredUserId = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,referrerId: null == referrerId ? _self.referrerId : referrerId // ignore: cast_nullable_to_non_nullable
as String,referredUserId: null == referredUserId ? _self.referredUserId : referredUserId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ReferralEntry].
extension ReferralEntryPatterns on ReferralEntry {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReferralEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReferralEntry() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReferralEntry value)  $default,){
final _that = this;
switch (_that) {
case _ReferralEntry():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReferralEntry value)?  $default,){
final _that = this;
switch (_that) {
case _ReferralEntry() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String referrerId,  String referredUserId,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReferralEntry() when $default != null:
return $default(_that.id,_that.referrerId,_that.referredUserId,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String referrerId,  String referredUserId,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _ReferralEntry():
return $default(_that.id,_that.referrerId,_that.referredUserId,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String referrerId,  String referredUserId,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ReferralEntry() when $default != null:
return $default(_that.id,_that.referrerId,_that.referredUserId,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReferralEntry implements ReferralEntry {
  const _ReferralEntry({required this.id, required this.referrerId, required this.referredUserId, required this.createdAt});
  factory _ReferralEntry.fromJson(Map<String, dynamic> json) => _$ReferralEntryFromJson(json);

@override final  String id;
@override final  String referrerId;
@override final  String referredUserId;
@override final  DateTime createdAt;

/// Create a copy of ReferralEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReferralEntryCopyWith<_ReferralEntry> get copyWith => __$ReferralEntryCopyWithImpl<_ReferralEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReferralEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReferralEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.referrerId, referrerId) || other.referrerId == referrerId)&&(identical(other.referredUserId, referredUserId) || other.referredUserId == referredUserId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,referrerId,referredUserId,createdAt);

@override
String toString() {
  return 'ReferralEntry(id: $id, referrerId: $referrerId, referredUserId: $referredUserId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ReferralEntryCopyWith<$Res> implements $ReferralEntryCopyWith<$Res> {
  factory _$ReferralEntryCopyWith(_ReferralEntry value, $Res Function(_ReferralEntry) _then) = __$ReferralEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, String referrerId, String referredUserId, DateTime createdAt
});




}
/// @nodoc
class __$ReferralEntryCopyWithImpl<$Res>
    implements _$ReferralEntryCopyWith<$Res> {
  __$ReferralEntryCopyWithImpl(this._self, this._then);

  final _ReferralEntry _self;
  final $Res Function(_ReferralEntry) _then;

/// Create a copy of ReferralEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? referrerId = null,Object? referredUserId = null,Object? createdAt = null,}) {
  return _then(_ReferralEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,referrerId: null == referrerId ? _self.referrerId : referrerId // ignore: cast_nullable_to_non_nullable
as String,referredUserId: null == referredUserId ? _self.referredUserId : referredUserId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
