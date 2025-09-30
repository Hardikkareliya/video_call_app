// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'users_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UsersState {

 bool get isLoading; List<UserModel> get usersList; int get totalDataCount; int? get nextPageIndex; bool get isOffline; bool get isFromCache; String? get lastError;
/// Create a copy of UsersState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UsersStateCopyWith<UsersState> get copyWith => _$UsersStateCopyWithImpl<UsersState>(this as UsersState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UsersState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other.usersList, usersList)&&(identical(other.totalDataCount, totalDataCount) || other.totalDataCount == totalDataCount)&&(identical(other.nextPageIndex, nextPageIndex) || other.nextPageIndex == nextPageIndex)&&(identical(other.isOffline, isOffline) || other.isOffline == isOffline)&&(identical(other.isFromCache, isFromCache) || other.isFromCache == isFromCache)&&(identical(other.lastError, lastError) || other.lastError == lastError));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(usersList),totalDataCount,nextPageIndex,isOffline,isFromCache,lastError);

@override
String toString() {
  return 'UsersState(isLoading: $isLoading, usersList: $usersList, totalDataCount: $totalDataCount, nextPageIndex: $nextPageIndex, isOffline: $isOffline, isFromCache: $isFromCache, lastError: $lastError)';
}


}

/// @nodoc
abstract mixin class $UsersStateCopyWith<$Res>  {
  factory $UsersStateCopyWith(UsersState value, $Res Function(UsersState) _then) = _$UsersStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, List<UserModel> usersList, int totalDataCount, int? nextPageIndex, bool isOffline, bool isFromCache, String? lastError
});




}
/// @nodoc
class _$UsersStateCopyWithImpl<$Res>
    implements $UsersStateCopyWith<$Res> {
  _$UsersStateCopyWithImpl(this._self, this._then);

  final UsersState _self;
  final $Res Function(UsersState) _then;

/// Create a copy of UsersState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? usersList = null,Object? totalDataCount = null,Object? nextPageIndex = freezed,Object? isOffline = null,Object? isFromCache = null,Object? lastError = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,usersList: null == usersList ? _self.usersList : usersList // ignore: cast_nullable_to_non_nullable
as List<UserModel>,totalDataCount: null == totalDataCount ? _self.totalDataCount : totalDataCount // ignore: cast_nullable_to_non_nullable
as int,nextPageIndex: freezed == nextPageIndex ? _self.nextPageIndex : nextPageIndex // ignore: cast_nullable_to_non_nullable
as int?,isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,isFromCache: null == isFromCache ? _self.isFromCache : isFromCache // ignore: cast_nullable_to_non_nullable
as bool,lastError: freezed == lastError ? _self.lastError : lastError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UsersState].
extension UsersStatePatterns on UsersState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UsersState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UsersState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UsersState value)  $default,){
final _that = this;
switch (_that) {
case _UsersState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UsersState value)?  $default,){
final _that = this;
switch (_that) {
case _UsersState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  List<UserModel> usersList,  int totalDataCount,  int? nextPageIndex,  bool isOffline,  bool isFromCache,  String? lastError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UsersState() when $default != null:
return $default(_that.isLoading,_that.usersList,_that.totalDataCount,_that.nextPageIndex,_that.isOffline,_that.isFromCache,_that.lastError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  List<UserModel> usersList,  int totalDataCount,  int? nextPageIndex,  bool isOffline,  bool isFromCache,  String? lastError)  $default,) {final _that = this;
switch (_that) {
case _UsersState():
return $default(_that.isLoading,_that.usersList,_that.totalDataCount,_that.nextPageIndex,_that.isOffline,_that.isFromCache,_that.lastError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  List<UserModel> usersList,  int totalDataCount,  int? nextPageIndex,  bool isOffline,  bool isFromCache,  String? lastError)?  $default,) {final _that = this;
switch (_that) {
case _UsersState() when $default != null:
return $default(_that.isLoading,_that.usersList,_that.totalDataCount,_that.nextPageIndex,_that.isOffline,_that.isFromCache,_that.lastError);case _:
  return null;

}
}

}

/// @nodoc


class _UsersState implements UsersState {
  const _UsersState({this.isLoading = false, final  List<UserModel> usersList = const [], this.totalDataCount = 0, this.nextPageIndex, this.isOffline = false, this.isFromCache = false, this.lastError}): _usersList = usersList;
  

@override@JsonKey() final  bool isLoading;
 final  List<UserModel> _usersList;
@override@JsonKey() List<UserModel> get usersList {
  if (_usersList is EqualUnmodifiableListView) return _usersList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_usersList);
}

@override@JsonKey() final  int totalDataCount;
@override final  int? nextPageIndex;
@override@JsonKey() final  bool isOffline;
@override@JsonKey() final  bool isFromCache;
@override final  String? lastError;

/// Create a copy of UsersState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UsersStateCopyWith<_UsersState> get copyWith => __$UsersStateCopyWithImpl<_UsersState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UsersState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other._usersList, _usersList)&&(identical(other.totalDataCount, totalDataCount) || other.totalDataCount == totalDataCount)&&(identical(other.nextPageIndex, nextPageIndex) || other.nextPageIndex == nextPageIndex)&&(identical(other.isOffline, isOffline) || other.isOffline == isOffline)&&(identical(other.isFromCache, isFromCache) || other.isFromCache == isFromCache)&&(identical(other.lastError, lastError) || other.lastError == lastError));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(_usersList),totalDataCount,nextPageIndex,isOffline,isFromCache,lastError);

@override
String toString() {
  return 'UsersState(isLoading: $isLoading, usersList: $usersList, totalDataCount: $totalDataCount, nextPageIndex: $nextPageIndex, isOffline: $isOffline, isFromCache: $isFromCache, lastError: $lastError)';
}


}

/// @nodoc
abstract mixin class _$UsersStateCopyWith<$Res> implements $UsersStateCopyWith<$Res> {
  factory _$UsersStateCopyWith(_UsersState value, $Res Function(_UsersState) _then) = __$UsersStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, List<UserModel> usersList, int totalDataCount, int? nextPageIndex, bool isOffline, bool isFromCache, String? lastError
});




}
/// @nodoc
class __$UsersStateCopyWithImpl<$Res>
    implements _$UsersStateCopyWith<$Res> {
  __$UsersStateCopyWithImpl(this._self, this._then);

  final _UsersState _self;
  final $Res Function(_UsersState) _then;

/// Create a copy of UsersState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? usersList = null,Object? totalDataCount = null,Object? nextPageIndex = freezed,Object? isOffline = null,Object? isFromCache = null,Object? lastError = freezed,}) {
  return _then(_UsersState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,usersList: null == usersList ? _self._usersList : usersList // ignore: cast_nullable_to_non_nullable
as List<UserModel>,totalDataCount: null == totalDataCount ? _self.totalDataCount : totalDataCount // ignore: cast_nullable_to_non_nullable
as int,nextPageIndex: freezed == nextPageIndex ? _self.nextPageIndex : nextPageIndex // ignore: cast_nullable_to_non_nullable
as int?,isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,isFromCache: null == isFromCache ? _self.isFromCache : isFromCache // ignore: cast_nullable_to_non_nullable
as bool,lastError: freezed == lastError ? _self.lastError : lastError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
