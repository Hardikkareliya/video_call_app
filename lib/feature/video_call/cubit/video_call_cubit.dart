import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/ui_stats/video_call_state.dart';
import '../services/agora_service.dart';

class VideoCallCubit extends Cubit<VideoCallState> {
  VideoCallCubit() : super(const VideoCallState()) {
    onInit();
  }

  late AgoraService _agoraService;
  bool _isInitialized = false;

  void onInit() {
    _initializeAgora();
  }

  Future<void> _initializeAgora() async {
    try {
      _agoraService = AgoraService.instance;

      // Only initialize if not already ready
      if (!_agoraService.isReady) {
        await _agoraService.initialize();
      }

      _isInitialized = true;
      _agoraService.addListener(_onAgoraServiceChanged);

      emit(state.copyWith(isInitialized: true));
    } catch (e) {
      debugPrint('Failed to initialize Agora: $e');
      emit(
        state.copyWith(
          isInitialized: true,
          error: 'Failed to initialize Agora: $e',
        ),
      );
    }
  }

  void _onAgoraServiceChanged() {
    if (!_isInitialized) return;

    final newState = state.copyWith(
      isJoined: _agoraService.isJoined,
      isMuted: _agoraService.isMuted,
      isVideoEnabled: _agoraService.isVideoEnabled,
      isScreenSharing: _agoraService.isScreenSharing,
      isConnecting: _agoraService.isConnecting,
      connectionState: _mapConnectionState(_agoraService.connectionState),
      localUid: _agoraService.localUid ?? 0,
      remoteUids: _agoraService.remoteUid != null
          ? [_agoraService.remoteUid!]
          : [],
      error: _agoraService.lastError,
      channelName: _agoraService.currentChannelId ?? '',
    );

    emit(newState);
  }

  VideoCallConnectionState _mapConnectionState(connectionState) {
    switch (connectionState.toString()) {
      case 'ConnectionStateType.connectionStateConnected':
        return VideoCallConnectionState.connected;
      case 'ConnectionStateType.connectionStateConnecting':
        return VideoCallConnectionState.connecting;
      case 'ConnectionStateType.connectionStateReconnecting':
        return VideoCallConnectionState.reconnecting;
      default:
        return VideoCallConnectionState.disconnected;
    }
  }

  Future<void> joinChannel(String channelName) async {
    if (!_isInitialized) {
      emit(state.copyWith(error: 'Agora not initialized'));
      return;
    }

    if (channelName.isEmpty) {
      emit(state.copyWith(error: 'Please enter a meeting ID'));
      return;
    }

    try {
      emit(
        state.copyWith(
          isConnecting: true,
          error: null,
          channelName: channelName,
        ),
      );

      await _agoraService.joinChannel(channelName);
    } catch (e) {
      emit(
        state.copyWith(
          isConnecting: false,
          error: 'Failed to join channel: $e',
        ),
      );
    }
  }

  Future<void> leaveChannel() async {
    if (!_isInitialized) return;

    try {
      await _agoraService.leaveChannel();
    } catch (e) {
      emit(state.copyWith(error: 'Failed to leave channel: $e'));
    }
  }

  Future<void> toggleMute() async {
    if (!_isInitialized || !state.isJoined) return;

    try {
      await _agoraService.toggleMute();
    } catch (e) {
      emit(state.copyWith(error: 'Failed to toggle mute: $e'));
    }
  }

  Future<void> toggleVideo() async {
    if (!_isInitialized || !state.isJoined) return;

    try {
      await _agoraService.toggleVideo();
    } catch (e) {
      emit(state.copyWith(error: 'Failed to toggle video: $e'));
    }
  }

  Future<void> switchCamera() async {
    if (!_isInitialized || !state.isJoined || !state.isVideoEnabled) return;

    try {
      await _agoraService.switchCamera();
    } catch (e) {
      emit(state.copyWith(error: 'Failed to switch camera: $e'));
    }
  }

  Future<void> startScreenShare() async {
    if (!_isInitialized || !state.isJoined) return;

    try {
      await _agoraService.startScreenShare();
    } catch (e) {
      emit(state.copyWith(error: 'Failed to start screen share: $e'));
    }
  }

  Future<void> stopScreenShare() async {
    if (!_isInitialized || !state.isScreenSharing) return;

    try {
      await _agoraService.stopScreenShare();
    } catch (e) {
      emit(state.copyWith(error: 'Failed to stop screen share: $e'));
    }
  }

  void clearError() {
    emit(state.copyWith(error: null));
  }

  Widget buildLocalVideoView() {
    if (!_isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return _agoraService.buildLocalVideoView();
  }

  Widget buildRemoteVideoView() {
    if (!_isInitialized) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.videocam_off, color: Colors.white54, size: 48),
              SizedBox(height: 16),
              Text(
                'Waiting for remote user...',
                style: TextStyle(color: Colors.white54, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }
    return _agoraService.buildRemoteVideoView();
  }

  @override
  Future<void> close() {
    if (_isInitialized) {
      _agoraService.removeListener(_onAgoraServiceChanged);
      _agoraService.cleanupSession();
    }
    return super.close();
  }
}
