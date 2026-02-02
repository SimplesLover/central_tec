// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'points_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PointsEntry {

 String get id; String get userId; int get points; String get source; DateTime get createdAt;
/// Create a copy of PointsEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PointsEntryCopyWith<PointsEntry> get copyWith => _$PointsEntryCopyWithImpl<PointsEntry>(this as PointsEntry, _$identity);

  /// Serializes this PointsEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PointsEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.points, points) || other.points == points)&&(identical(other.source, source) || other.source == source)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,points,source,createdAt);

@override
String toString() {
  return 'PointsEntry(id: $id, userId: $userId, points: $points, source: $source, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $PointsEntryCopyWith<$Res>  {
  factory $PointsEntryCopyWith(PointsEntry value, $Res Function(PointsEntry) _then) = _$PointsEntryCopyWithImpl;
@useResult
$Res call({
 String id, String userId, int points, String source, DateTime createdAt
});




}
/// @nodoc
class _$PointsEntryCopyWithImpl<$Res>
    implements $PointsEntryCopyWith<$Res> {
  _$PointsEntryCopyWithImpl(this._self, this._then);

  final PointsEntry _self;
  final $Res Function(PointsEntry) _then;

/// Create a copy of PointsEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? points = null,Object? source = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PointsEntry].
extension PointsEntryPatterns on PointsEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PointsEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PointsEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PointsEntry value)  $default,){
final _that = this;
switch (_that) {
case _PointsEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PointsEntry value)?  $default,){
final _that = this;
switch (_that) {
case _PointsEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  int points,  String source,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PointsEntry() when $default != null:
return $default(_that.id,_that.userId,_that.points,_that.source,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  int points,  String source,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _PointsEntry():
return $default(_that.id,_that.userId,_that.points,_that.source,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  int points,  String source,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _PointsEntry() when $default != null:
return $default(_that.id,_that.userId,_that.points,_that.source,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PointsEntry implements PointsEntry {
  const _PointsEntry({required this.id, required this.userId, required this.points, required this.source, required this.createdAt});
  factory _PointsEntry.fromJson(Map<String, dynamic> json) => _$PointsEntryFromJson(json);

@override final  String id;
@override final  String userId;
@override final  int points;
@override final  String source;
@override final  DateTime createdAt;

/// Create a copy of PointsEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PointsEntryCopyWith<_PointsEntry> get copyWith => __$PointsEntryCopyWithImpl<_PointsEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PointsEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PointsEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.points, points) || other.points == points)&&(identical(other.source, source) || other.source == source)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,points,source,createdAt);

@override
String toString() {
  return 'PointsEntry(id: $id, userId: $userId, points: $points, source: $source, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$PointsEntryCopyWith<$Res> implements $PointsEntryCopyWith<$Res> {
  factory _$PointsEntryCopyWith(_PointsEntry value, $Res Function(_PointsEntry) _then) = __$PointsEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, int points, String source, DateTime createdAt
});




}
/// @nodoc
class __$PointsEntryCopyWithImpl<$Res>
    implements _$PointsEntryCopyWith<$Res> {
  __$PointsEntryCopyWithImpl(this._self, this._then);

  final _PointsEntry _self;
  final $Res Function(_PointsEntry) _then;

/// Create a copy of PointsEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? points = null,Object? source = null,Object? createdAt = null,}) {
  return _then(_PointsEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
