// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_call_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VideoCallState {

 bool get isInitialized; bool get isJoined; bool get isMuted; bool get isVideoEnabled; bool get isScreenSharing; bool get isConnecting; bool get isDisconnected; VideoCallConnectionState get connectionState; List<int> get remoteUids; int get localUid; String? get error; String get channelName; String get token;
/// Create a copy of VideoCallState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VideoCallStateCopyWith<VideoCallState> get copyWith => _$VideoCallStateCopyWithImpl<VideoCallState>(this as VideoCallState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VideoCallState&&(identical(other.isInitialized, isInitialized) || other.isInitialized == isInitialized)&&(identical(other.isJoined, isJoined) || other.isJoined == isJoined)&&(identical(other.isMuted, isMuted) || other.isMuted == isMuted)&&(identical(other.isVideoEnabled, isVideoEnabled) || other.isVideoEnabled == isVideoEnabled)&&(identical(other.isScreenSharing, isScreenSharing) || other.isScreenSharing == isScreenSharing)&&(identical(other.isConnecting, isConnecting) || other.isConnecting == isConnecting)&&(identical(other.isDisconnected, isDisconnected) || other.isDisconnected == isDisconnected)&&(identical(other.connectionState, connectionState) || other.connectionState == connectionState)&&const DeepCollectionEquality().equals(other.remoteUids, remoteUids)&&(identical(other.localUid, localUid) || other.localUid == localUid)&&(identical(other.error, error) || other.error == error)&&(identical(other.channelName, channelName) || other.channelName == channelName)&&(identical(other.token, token) || other.token == token));
}


@override
int get hashCode => Object.hash(runtimeType,isInitialized,isJoined,isMuted,isVideoEnabled,isScreenSharing,isConnecting,isDisconnected,connectionState,const DeepCollectionEquality().hash(remoteUids),localUid,error,channelName,token);

@override
String toString() {
  return 'VideoCallState(isInitialized: $isInitialized, isJoined: $isJoined, isMuted: $isMuted, isVideoEnabled: $isVideoEnabled, isScreenSharing: $isScreenSharing, isConnecting: $isConnecting, isDisconnected: $isDisconnected, connectionState: $connectionState, remoteUids: $remoteUids, localUid: $localUid, error: $error, channelName: $channelName, token: $token)';
}


}

/// @nodoc
abstract mixin class $VideoCallStateCopyWith<$Res>  {
  factory $VideoCallStateCopyWith(VideoCallState value, $Res Function(VideoCallState) _then) = _$VideoCallStateCopyWithImpl;
@useResult
$Res call({
 bool isInitialized, bool isJoined, bool isMuted, bool isVideoEnabled, bool isScreenSharing, bool isConnecting, bool isDisconnected, VideoCallConnectionState connectionState, List<int> remoteUids, int localUid, String? error, String channelName, String token
});




}
/// @nodoc
class _$VideoCallStateCopyWithImpl<$Res>
    implements $VideoCallStateCopyWith<$Res> {
  _$VideoCallStateCopyWithImpl(this._self, this._then);

  final VideoCallState _self;
  final $Res Function(VideoCallState) _then;

/// Create a copy of VideoCallState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isInitialized = null,Object? isJoined = null,Object? isMuted = null,Object? isVideoEnabled = null,Object? isScreenSharing = null,Object? isConnecting = null,Object? isDisconnected = null,Object? connectionState = null,Object? remoteUids = null,Object? localUid = null,Object? error = freezed,Object? channelName = null,Object? token = null,}) {
  return _then(_self.copyWith(
isInitialized: null == isInitialized ? _self.isInitialized : isInitialized // ignore: cast_nullable_to_non_nullable
as bool,isJoined: null == isJoined ? _self.isJoined : isJoined // ignore: cast_nullable_to_non_nullable
as bool,isMuted: null == isMuted ? _self.isMuted : isMuted // ignore: cast_nullable_to_non_nullable
as bool,isVideoEnabled: null == isVideoEnabled ? _self.isVideoEnabled : isVideoEnabled // ignore: cast_nullable_to_non_nullable
as bool,isScreenSharing: null == isScreenSharing ? _self.isScreenSharing : isScreenSharing // ignore: cast_nullable_to_non_nullable
as bool,isConnecting: null == isConnecting ? _self.isConnecting : isConnecting // ignore: cast_nullable_to_non_nullable
as bool,isDisconnected: null == isDisconnected ? _self.isDisconnected : isDisconnected // ignore: cast_nullable_to_non_nullable
as bool,connectionState: null == connectionState ? _self.connectionState : connectionState // ignore: cast_nullable_to_non_nullable
as VideoCallConnectionState,remoteUids: null == remoteUids ? _self.remoteUids : remoteUids // ignore: cast_nullable_to_non_nullable
as List<int>,localUid: null == localUid ? _self.localUid : localUid // ignore: cast_nullable_to_non_nullable
as int,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,channelName: null == channelName ? _self.channelName : channelName // ignore: cast_nullable_to_non_nullable
as String,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [VideoCallState].
extension VideoCallStatePatterns on VideoCallState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VideoCallState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VideoCallState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VideoCallState value)  $default,){
final _that = this;
switch (_that) {
case _VideoCallState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VideoCallState value)?  $default,){
final _that = this;
switch (_that) {
case _VideoCallState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isInitialized,  bool isJoined,  bool isMuted,  bool isVideoEnabled,  bool isScreenSharing,  bool isConnecting,  bool isDisconnected,  VideoCallConnectionState connectionState,  List<int> remoteUids,  int localUid,  String? error,  String channelName,  String token)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VideoCallState() when $default != null:
return $default(_that.isInitialized,_that.isJoined,_that.isMuted,_that.isVideoEnabled,_that.isScreenSharing,_that.isConnecting,_that.isDisconnected,_that.connectionState,_that.remoteUids,_that.localUid,_that.error,_that.channelName,_that.token);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isInitialized,  bool isJoined,  bool isMuted,  bool isVideoEnabled,  bool isScreenSharing,  bool isConnecting,  bool isDisconnected,  VideoCallConnectionState connectionState,  List<int> remoteUids,  int localUid,  String? error,  String channelName,  String token)  $default,) {final _that = this;
switch (_that) {
case _VideoCallState():
return $default(_that.isInitialized,_that.isJoined,_that.isMuted,_that.isVideoEnabled,_that.isScreenSharing,_that.isConnecting,_that.isDisconnected,_that.connectionState,_that.remoteUids,_that.localUid,_that.error,_that.channelName,_that.token);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isInitialized,  bool isJoined,  bool isMuted,  bool isVideoEnabled,  bool isScreenSharing,  bool isConnecting,  bool isDisconnected,  VideoCallConnectionState connectionState,  List<int> remoteUids,  int localUid,  String? error,  String channelName,  String token)?  $default,) {final _that = this;
switch (_that) {
case _VideoCallState() when $default != null:
return $default(_that.isInitialized,_that.isJoined,_that.isMuted,_that.isVideoEnabled,_that.isScreenSharing,_that.isConnecting,_that.isDisconnected,_that.connectionState,_that.remoteUids,_that.localUid,_that.error,_that.channelName,_that.token);case _:
  return null;

}
}

}

/// @nodoc


class _VideoCallState implements VideoCallState {
  const _VideoCallState({this.isInitialized = false, this.isJoined = false, this.isMuted = false, this.isVideoEnabled = false, this.isScreenSharing = false, this.isConnecting = false, this.isDisconnected = false, this.connectionState = VideoCallConnectionState.disconnected, final  List<int> remoteUids = const [], this.localUid = 0, this.error, this.channelName = '', this.token = ''}): _remoteUids = remoteUids;
  

@override@JsonKey() final  bool isInitialized;
@override@JsonKey() final  bool isJoined;
@override@JsonKey() final  bool isMuted;
@override@JsonKey() final  bool isVideoEnabled;
@override@JsonKey() final  bool isScreenSharing;
@override@JsonKey() final  bool isConnecting;
@override@JsonKey() final  bool isDisconnected;
@override@JsonKey() final  VideoCallConnectionState connectionState;
 final  List<int> _remoteUids;
@override@JsonKey() List<int> get remoteUids {
  if (_remoteUids is EqualUnmodifiableListView) return _remoteUids;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_remoteUids);
}

@override@JsonKey() final  int localUid;
@override final  String? error;
@override@JsonKey() final  String channelName;
@override@JsonKey() final  String token;

/// Create a copy of VideoCallState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VideoCallStateCopyWith<_VideoCallState> get copyWith => __$VideoCallStateCopyWithImpl<_VideoCallState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VideoCallState&&(identical(other.isInitialized, isInitialized) || other.isInitialized == isInitialized)&&(identical(other.isJoined, isJoined) || other.isJoined == isJoined)&&(identical(other.isMuted, isMuted) || other.isMuted == isMuted)&&(identical(other.isVideoEnabled, isVideoEnabled) || other.isVideoEnabled == isVideoEnabled)&&(identical(other.isScreenSharing, isScreenSharing) || other.isScreenSharing == isScreenSharing)&&(identical(other.isConnecting, isConnecting) || other.isConnecting == isConnecting)&&(identical(other.isDisconnected, isDisconnected) || other.isDisconnected == isDisconnected)&&(identical(other.connectionState, connectionState) || other.connectionState == connectionState)&&const DeepCollectionEquality().equals(other._remoteUids, _remoteUids)&&(identical(other.localUid, localUid) || other.localUid == localUid)&&(identical(other.error, error) || other.error == error)&&(identical(other.channelName, channelName) || other.channelName == channelName)&&(identical(other.token, token) || other.token == token));
}


@override
int get hashCode => Object.hash(runtimeType,isInitialized,isJoined,isMuted,isVideoEnabled,isScreenSharing,isConnecting,isDisconnected,connectionState,const DeepCollectionEquality().hash(_remoteUids),localUid,error,channelName,token);

@override
String toString() {
  return 'VideoCallState(isInitialized: $isInitialized, isJoined: $isJoined, isMuted: $isMuted, isVideoEnabled: $isVideoEnabled, isScreenSharing: $isScreenSharing, isConnecting: $isConnecting, isDisconnected: $isDisconnected, connectionState: $connectionState, remoteUids: $remoteUids, localUid: $localUid, error: $error, channelName: $channelName, token: $token)';
}


}

/// @nodoc
abstract mixin class _$VideoCallStateCopyWith<$Res> implements $VideoCallStateCopyWith<$Res> {
  factory _$VideoCallStateCopyWith(_VideoCallState value, $Res Function(_VideoCallState) _then) = __$VideoCallStateCopyWithImpl;
@override @useResult
$Res call({
 bool isInitialized, bool isJoined, bool isMuted, bool isVideoEnabled, bool isScreenSharing, bool isConnecting, bool isDisconnected, VideoCallConnectionState connectionState, List<int> remoteUids, int localUid, String? error, String channelName, String token
});




}
/// @nodoc
class __$VideoCallStateCopyWithImpl<$Res>
    implements _$VideoCallStateCopyWith<$Res> {
  __$VideoCallStateCopyWithImpl(this._self, this._then);

  final _VideoCallState _self;
  final $Res Function(_VideoCallState) _then;

/// Create a copy of VideoCallState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isInitialized = null,Object? isJoined = null,Object? isMuted = null,Object? isVideoEnabled = null,Object? isScreenSharing = null,Object? isConnecting = null,Object? isDisconnected = null,Object? connectionState = null,Object? remoteUids = null,Object? localUid = null,Object? error = freezed,Object? channelName = null,Object? token = null,}) {
  return _then(_VideoCallState(
isInitialized: null == isInitialized ? _self.isInitialized : isInitialized // ignore: cast_nullable_to_non_nullable
as bool,isJoined: null == isJoined ? _self.isJoined : isJoined // ignore: cast_nullable_to_non_nullable
as bool,isMuted: null == isMuted ? _self.isMuted : isMuted // ignore: cast_nullable_to_non_nullable
as bool,isVideoEnabled: null == isVideoEnabled ? _self.isVideoEnabled : isVideoEnabled // ignore: cast_nullable_to_non_nullable
as bool,isScreenSharing: null == isScreenSharing ? _self.isScreenSharing : isScreenSharing // ignore: cast_nullable_to_non_nullable
as bool,isConnecting: null == isConnecting ? _self.isConnecting : isConnecting // ignore: cast_nullable_to_non_nullable
as bool,isDisconnected: null == isDisconnected ? _self.isDisconnected : isDisconnected // ignore: cast_nullable_to_non_nullable
as bool,connectionState: null == connectionState ? _self.connectionState : connectionState // ignore: cast_nullable_to_non_nullable
as VideoCallConnectionState,remoteUids: null == remoteUids ? _self._remoteUids : remoteUids // ignore: cast_nullable_to_non_nullable
as List<int>,localUid: null == localUid ? _self.localUid : localUid // ignore: cast_nullable_to_non_nullable
as int,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,channelName: null == channelName ? _self.channelName : channelName // ignore: cast_nullable_to_non_nullable
as String,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
