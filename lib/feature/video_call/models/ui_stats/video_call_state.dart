import 'package:freezed_annotation/freezed_annotation.dart';

part 'video_call_state.freezed.dart';

enum VideoCallConnectionState { disconnected, connecting, connected, reconnecting }

@freezed
abstract class VideoCallState with _$VideoCallState {
  const factory VideoCallState({
    @Default(false) bool isInitialized,
    @Default(false) bool isJoined,
    @Default(false) bool isMuted,
    @Default(false) bool isVideoEnabled,
    @Default(false) bool isScreenSharing,
    @Default(false) bool isConnecting,
    @Default(false) bool isDisconnected,
    @Default(VideoCallConnectionState.disconnected) VideoCallConnectionState connectionState,
    @Default([]) List<int> remoteUids,
    @Default(0) int localUid,
    String? error,
    @Default('') String channelName,
    @Default('') String token,
  }) = _VideoCallState;
}

extension VideoCallStateExtension on VideoCallState {
  bool get hasError => error != null;
  bool get isConnected => connectionState == VideoCallConnectionState.connected;
  bool get hasRemoteUsers => remoteUids.isNotEmpty;
  bool get canToggleVideo => isJoined && !isScreenSharing;
  bool get canToggleAudio => isJoined;
  bool get canScreenShare => isJoined && !isScreenSharing;
}

