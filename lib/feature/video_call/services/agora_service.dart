import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// Comprehensive Agora service for one-to-one video calling
/// Handles all video call functionality with proper error handling and state management
class AgoraService extends ChangeNotifier {
  // Singleton pattern for global access
  AgoraService._private();

  static final AgoraService _instance = AgoraService._private();

  static AgoraService get instance => _instance;

  // Agora configuration
  static const String _appId =
      "a9f7f312cd2c4d8abf56a0e6bfe89888"; // Replace with your App ID
  static const String _token = ""; // Use empty string for testing mode

  // Engine instance
  RtcEngine? _engine;
  bool _isInitialized = false;

  // Platform channel for native screen sharing
  // Screen sharing is now handled by Agora Flutter plugin directly

  // Connection state
  String? _currentChannelId;
  int? _localUid;
  int? _remoteUid;
  bool _isJoined = false;
  bool _isConnecting = false;

  // Media state
  bool _isMuted = false;
  bool _isVideoEnabled = true;
  bool _isSpeakerEnabled = true;

  // Screen sharing state
  bool _isScreenSharing = false;
  bool _isScreenShareAvailable =
      true; // Whether current user can start screen share
  int? _screenSharingUid; // UID of user currently sharing screen

  // Error handling
  String? _lastError;
  ConnectionStateType _connectionState =
      ConnectionStateType.connectionStateDisconnected;

  // Getters
  String? get currentChannelId => _currentChannelId;

  int? get localUid => _localUid;

  int? get remoteUid => _remoteUid;

  bool get isJoined => _isJoined;

  bool get isConnecting => _isConnecting;

  bool get isMuted => _isMuted;

  bool get isVideoEnabled => _isVideoEnabled;

  bool get isSpeakerEnabled => _isSpeakerEnabled;

  bool get isScreenSharing => _isScreenSharing;

  bool get isScreenShareAvailable => _isScreenShareAvailable;

  int? get screenSharingUid => _screenSharingUid;

  String? get lastError => _lastError;

  ConnectionStateType get connectionState => _connectionState;

  bool get isInitialized => _isInitialized;

  /// Check if the service is ready to use (initialized and engine exists)
  bool get isReady => _isInitialized && _engine != null;

  /// Initialize the Agora RTC engine
  Future<void> initialize() async {
    if (_isInitialized && _engine != null) {
      debugPrint('[AgoraService] Already initialized, skipping...');
      return;
    }

    try {
      debugPrint('[AgoraService] Initializing Agora engine...');

      // Request permissions first
      await _requestPermissions();

      // Create and initialize engine only if not already created
      if (_engine == null) {
        _engine = createAgoraRtcEngine();
        debugPrint('[AgoraService] Engine created');
      }

      await _engine!.initialize(
        const RtcEngineContext(
          appId: _appId,
          logConfig: LogConfig(
            level: LogLevel.logLevelInfo,
            filePath: 'agora.log',
          ),
        ),
      );

      // Configure engine for one-to-one communication
      await _configureEngine();

      // Register event handlers
      _registerEventHandlers();

      _isInitialized = true;
      _lastError = null;
      notifyListeners();

      debugPrint('[AgoraService] Engine initialized successfully');
    } catch (e) {
      _lastError = 'Failed to initialize Agora: $e';
      debugPrint('[AgoraService] Initialization error: $e');
      notifyListeners();
      rethrow;
    }
  }

  /// Configure engine settings for optimal one-to-one video calling
  Future<void> _configureEngine() async {
    if (_engine == null) return;

    // Enable video
    await _engine!.enableVideo();

    // Set channel profile to communication (one-to-one)
    await _engine!.setChannelProfile(
      ChannelProfileType.channelProfileCommunication,
    );

    // Enable audio
    await _engine!.enableAudio();

    // Set audio profile for better quality
    await _engine!.setAudioProfile(
      profile: AudioProfileType.audioProfileMusicHighQuality,
      scenario: AudioScenarioType.audioScenarioGameStreaming,
    );

    // Configure video settings
    await _engine!.setVideoEncoderConfiguration(
      const VideoEncoderConfiguration(
        dimensions: VideoDimensions(width: 640, height: 480),
        frameRate: 15,
        bitrate: 0, // Let Agora determine optimal bitrate
        orientationMode: OrientationMode.orientationModeFixedPortrait,
      ),
    );

    // Enable local video preview
    await _engine!.startPreview();

    // Set default audio route to speaker
    await _engine!.setDefaultAudioRouteToSpeakerphone(true);

    // Enable screen sharing capability
    await _engine!.enableLocalVideo(
      false,
    ); // Disable local video initially for screen share
    await _engine!.enableLocalVideo(true); // Re-enable for normal video
  }

  /// Register all event handlers
  void _registerEventHandlers() {
    if (_engine == null) return;

    _engine!.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: _onJoinChannelSuccess,
        onLeaveChannel: _onLeaveChannel,
        onUserJoined: _onUserJoined,
        onUserOffline: _onUserOffline,
        onConnectionStateChanged: _onConnectionStateChanged,
        onError: _onError,
        onLocalVideoStateChanged: _onLocalVideoStateChanged,
        onRemoteVideoStateChanged: _onRemoteVideoStateChanged,
        onLocalAudioStateChanged: _onLocalAudioStateChanged,
        onRemoteAudioStateChanged: _onRemoteAudioStateChanged,
        onNetworkQuality: _onNetworkQuality,
      ),
    );
  }

  /// Request necessary permissions
  Future<void> _requestPermissions() async {
    final permissions = [Permission.camera, Permission.microphone];

    final statuses = await permissions.request();

    for (final status in statuses.values) {
      if (status != PermissionStatus.granted) {
        throw Exception('Required permissions not granted: $status');
      }
    }
  }

  /// Check and request screen recording permission
  Future<void> _checkAndRequestScreenRecordingPermission() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      // Check current permission status first
      final systemAlertStatus = await Permission.systemAlertWindow.status;

      if (systemAlertStatus != PermissionStatus.granted) {
        // Request the permission
        final status = await Permission.systemAlertWindow.request();

        if (status != PermissionStatus.granted) {
          throw Exception(
            'Screen recording permission not granted. Please enable "Display over other apps" permission in Settings > Apps > Agora Demo > Permissions > Display over other apps',
          );
        }
      }

      // Also ensure camera and microphone permissions are granted
      final cameraStatus = await Permission.camera.status;
      final micStatus = await Permission.microphone.status;

      if (cameraStatus != PermissionStatus.granted) {
        final status = await Permission.camera.request();
        if (status != PermissionStatus.granted) {
          throw Exception('Camera permission is required for screen sharing');
        }
      }

      if (micStatus != PermissionStatus.granted) {
        final status = await Permission.microphone.request();
        if (status != PermissionStatus.granted) {
          throw Exception(
            'Microphone permission is required for screen sharing',
          );
        }
      }
    }
    // iOS handles screen recording permission automatically through ReplayKit
  }

  /// Join a channel with the given meeting ID
  Future<void> joinChannel(String meetingId) async {
    if (!_isInitialized || _engine == null) {
      throw Exception('Agora engine not initialized. Call initialize() first.');
    }

    if (_isJoined) {
      debugPrint(
        '[AgoraService] Already joined to channel: $_currentChannelId',
      );
      return;
    }

    try {
      _isConnecting = true;
      _lastError = null;
      notifyListeners();

      await _engine!.joinChannel(
        token: _token,
        channelId: meetingId,
        uid: 0, // Let Agora assign UID
        options: const ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          channelProfile: ChannelProfileType.channelProfileCommunication,
        ),
      );

      _currentChannelId = meetingId;
      debugPrint('[AgoraService] Joining channel: $meetingId');
    } catch (e) {
      _isConnecting = false;
      _lastError = 'Failed to join channel: $e';
      debugPrint('[AgoraService] Join channel error: $e');
      notifyListeners();
      rethrow;
    }
  }

  /// Leave the current channel
  Future<void> leaveChannel() async {
    if (!_isJoined || _engine == null) {
      debugPrint('[AgoraService] Not in any channel');
      return;
    }

    try {
      // Stop screen sharing if active
      if (_isScreenSharing) {
        await stopScreenShare();
      }

      await _engine!.leaveChannel();
      debugPrint('[AgoraService] Left channel: $_currentChannelId');
    } catch (e) {
      _lastError = 'Failed to leave channel: $e';
      debugPrint('[AgoraService] Leave channel error: $e');
      notifyListeners();
      rethrow;
    }
  }

  /// Toggle microphone mute/unmute
  Future<void> toggleMute() async {
    if (!_isInitialized || _engine == null) return;

    try {
      _isMuted = !_isMuted;
      await _engine!.muteLocalAudioStream(_isMuted);
      notifyListeners();
      debugPrint('[AgoraService] Audio ${_isMuted ? 'muted' : 'unmuted'}');
    } catch (e) {
      _isMuted = !_isMuted; // Revert on error
      _lastError = 'Failed to toggle mute: $e';
      debugPrint('[AgoraService] Toggle mute error: $e');
      notifyListeners();
    }
  }

  Future<void> toggleVideo() async {
    if (!_isInitialized || !_isJoined || _engine == null) return;

    try {
      _isVideoEnabled = !_isVideoEnabled;

      // Enable/disable local video capture
      await _engine!.enableLocalVideo(_isVideoEnabled);

      // Mute/unmute the video stream for remote users
      await _engine!.muteLocalVideoStream(!_isVideoEnabled);

      notifyListeners();
      debugPrint(
        '[AgoraService] Video ${_isVideoEnabled ? 'enabled' : 'disabled'}',
      );
    } catch (e) {
      _isVideoEnabled = !_isVideoEnabled; // Revert on error
      _lastError = 'Failed to toggle video: $e';
      debugPrint('[AgoraService] Toggle video error: $e');
      notifyListeners();
    }
  }

  Future<void> toggleSpeaker() async {
    if (!_isInitialized || _engine == null) return;

    try {
      _isSpeakerEnabled = !_isSpeakerEnabled;
      await _engine!.setEnableSpeakerphone(_isSpeakerEnabled);
      notifyListeners();
      debugPrint(
        '[AgoraService] Speaker ${_isSpeakerEnabled ? 'enabled' : 'disabled'}',
      );
    } catch (e) {
      _isSpeakerEnabled = !_isSpeakerEnabled; // Revert on error
      _lastError = 'Failed to toggle speaker: $e';
      debugPrint('[AgoraService] Toggle speaker error: $e');
      notifyListeners();
    }
  }

  Future<void> switchCamera() async {
    if (!_isInitialized || !_isVideoEnabled || _engine == null) return;

    try {
      await _engine!.switchCamera();
      debugPrint('[AgoraService] Camera switched');
    } catch (e) {
      _lastError = 'Failed to switch camera: $e';
      debugPrint('[AgoraService] Switch camera error: $e');
      notifyListeners();
    }
  }

  Future<void> startScreenShare() async {
    if (!_isInitialized || !_isJoined || _engine == null) {
      throw Exception('Not connected to a channel');
    }

    if (_isScreenSharing) {
      debugPrint('[AgoraService] Already sharing screen');
      return;
    }

    if (!_isScreenShareAvailable) {
      throw Exception(
        'Screen sharing is not available. Another user is already sharing.',
      );
    }

    try {
      // Check and request screen recording permission
      await _checkAndRequestScreenRecordingPermission();

      // Use Agora Flutter plugin's screen sharing
      await _engine!.startScreenCapture(
        const ScreenCaptureParameters2(
          captureVideo: true,
          captureAudio: true,
          videoParams: ScreenVideoParameters(
            dimensions: VideoDimensions(width: 1280, height: 720),
            frameRate: 15,
            bitrate: 0,
          ),
        ),
      );

      // Update state
      _isScreenSharing = true;
      _isScreenShareAvailable = false;
      _screenSharingUid = _localUid;

      notifyListeners();
      debugPrint(
        '[AgoraService] Screen sharing started using Agora Flutter plugin',
      );

      // In a real app, you would signal other users about screen sharing
      // For now, we'll simulate this with a delay
      Future.delayed(const Duration(seconds: 2), () {
        if (_isScreenSharing) {
          debugPrint(
            '[AgoraService] Screen sharing is active - other users should see your screen',
          );
        }
      });
    } catch (e) {
      _lastError = 'Failed to start screen sharing: $e';
      debugPrint('[AgoraService] Start screen share error: $e');
      notifyListeners();
      rethrow;
    }
  }

  Future<void> stopScreenShare() async {
    if (!_isInitialized || !_isScreenSharing || _engine == null) {
      debugPrint('[AgoraService] Not currently sharing screen');
      return;
    }

    try {
      await _engine!.stopScreenCapture();

      // Update state
      _isScreenSharing = false;
      _isScreenShareAvailable = true;
      _screenSharingUid = null;

      notifyListeners();
      debugPrint(
        '[AgoraService] Screen sharing stopped using Agora Flutter plugin',
      );
    } catch (e) {
      _lastError = 'Failed to stop screen sharing: $e';
      debugPrint('[AgoraService] Stop screen share error: $e');
      notifyListeners();
      rethrow;
    }
  }

  Future<void> requestScreenShareTakeover() async {
    if (!_isInitialized || !_isJoined) {
      throw Exception('Not connected to a channel');
    }

    if (_isScreenSharing) {
      debugPrint('[AgoraService] Already sharing screen');
      return;
    }

    if (_isScreenShareAvailable) {
      await startScreenShare();
      return;
    }

    try {
      throw Exception(
        'Another user is currently sharing their screen. Please ask them to stop sharing first.',
      );
    } catch (e) {
      _lastError = 'Cannot take over screen sharing: $e';
      debugPrint('[AgoraService] Screen share takeover error: $e');
      notifyListeners();
      rethrow;
    }
  }

  Widget buildLocalVideoView() {
    if (!_isInitialized || _engine == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: AgoraVideoView(
          controller: VideoViewController(
            rtcEngine: _engine!,
            canvas: const VideoCanvas(
              uid: 0,
              renderMode: RenderModeType.renderModeHidden,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRemoteVideoView() {
    if (!_isInitialized || _remoteUid == null || _engine == null) {
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

    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: AgoraVideoView(
          controller: VideoViewController.remote(
            rtcEngine: _engine!,
            canvas: VideoCanvas(
              uid: _remoteUid!,
              renderMode: RenderModeType.renderModeHidden,
            ),
            connection: RtcConnection(channelId: _currentChannelId ?? ''),
          ),
        ),
      ),
    );
  }

  // Event Handlers
  void _onJoinChannelSuccess(RtcConnection connection, int elapsed) {
    _isJoined = true;
    _isConnecting = false;
    _localUid = connection.localUid;
    _lastError = null;
    notifyListeners();
    debugPrint(
      '[AgoraService] Joined channel successfully: ${connection.channelId}, UID: ${connection.localUid}',
    );
  }

  void _onLeaveChannel(RtcConnection connection, RtcStats stats) {
    _isJoined = false;
    _isConnecting = false;
    _localUid = null;
    _remoteUid = null;
    _currentChannelId = null;
    notifyListeners();
    debugPrint('[AgoraService] Left channel: ${connection.channelId}');
  }

  void _onUserJoined(RtcConnection connection, int remoteUid, int elapsed) {
    _remoteUid = remoteUid;
    notifyListeners();
    debugPrint('[AgoraService] Remote user joined: $remoteUid');
  }

  void onRemoteScreenShareStarted(int remoteUid) {
    _isScreenShareAvailable = false;
    _screenSharingUid = remoteUid;
    notifyListeners();
    debugPrint('[AgoraService] Remote user started screen sharing: $remoteUid');
  }

  void onRemoteScreenShareStopped(int remoteUid) {
    if (_screenSharingUid == remoteUid) {
      _isScreenShareAvailable = true;
      _screenSharingUid = null;
      notifyListeners();
      debugPrint(
        '[AgoraService] Remote user stopped screen sharing: $remoteUid',
      );
    }
  }

  void signalScreenShareState(bool isSharing, int uid) {
    if (isSharing) {
      _isScreenShareAvailable = false;
      _screenSharingUid = uid;
    } else {
      _isScreenShareAvailable = true;
      _screenSharingUid = null;
    }
    notifyListeners();
    debugPrint(
      '[AgoraService] Screen share state signaled: isSharing=$isSharing, uid=$uid',
    );
  }

  void _onUserOffline(
    RtcConnection connection,
    int remoteUid,
    UserOfflineReasonType reason,
  ) {
    if (_remoteUid == remoteUid) {
      _remoteUid = null;
    }

    // If the user who was sharing screen left, make screen sharing available again
    if (_screenSharingUid == remoteUid) {
      _isScreenShareAvailable = true;
      _screenSharingUid = null;
    }

    notifyListeners();
    debugPrint('[AgoraService] Remote user left: $remoteUid, reason: $reason');
  }

  void _onConnectionStateChanged(
    RtcConnection connection,
    ConnectionStateType state,
    ConnectionChangedReasonType reason,
  ) {
    _connectionState = state;
    notifyListeners();
    debugPrint(
      '[AgoraService] Connection state changed: $state, reason: $reason',
    );
  }

  void _onError(ErrorCodeType err, String msg) {
    _lastError = 'Agora Error ($err): $msg';
    debugPrint('[AgoraService] Error: $err - $msg');
    notifyListeners();
  }

  void _onLocalVideoStateChanged(
    VideoSourceType source,
    LocalVideoStreamState state,
    LocalVideoStreamReason reason,
  ) {
    debugPrint(
      '[AgoraService] Local video state changed: $state, reason: $reason',
    );

    // Update video enabled state based on local video stream state
    if (state == LocalVideoStreamState.localVideoStreamStateStopped) {
      _isVideoEnabled = false;
    } else if (state == LocalVideoStreamState.localVideoStreamStateCapturing ||
        state == LocalVideoStreamState.localVideoStreamStateEncoding) {
      _isVideoEnabled = true;
    }

    notifyListeners();
  }

  void _onRemoteVideoStateChanged(
    RtcConnection connection,
    int remoteUid,
    RemoteVideoState state,
    RemoteVideoStateReason reason,
    int elapsed,
  ) {
    debugPrint(
      '[AgoraService] Remote video state changed: UID $remoteUid, state: $state, reason: $reason',
    );
  }

  void _onLocalAudioStateChanged(
    RtcConnection connection,
    LocalAudioStreamState state,
    LocalAudioStreamReason reason,
  ) {
    debugPrint(
      '[AgoraService] Local audio state changed: $state, reason: $reason',
    );
  }

  void _onRemoteAudioStateChanged(
    RtcConnection connection,
    int remoteUid,
    RemoteAudioState state,
    RemoteAudioStateReason reason,
    int elapsed,
  ) {}

  void _onNetworkQuality(
    RtcConnection connection,
    int remoteUid,
    QualityType txQuality,
    QualityType rxQuality,
  ) {}

  // Note: For proper screen sharing detection, you would need RTM or custom signaling
  // This is a simplified implementation that assumes screen sharing based on user actions

  /// Clear any error state
  void clearError() {
    _lastError = null;
    notifyListeners();
  }

  Future<void> cleanupSession() async {
    try {
      // Leave channel if joined
      if (_isJoined) {
        await leaveChannel();
      }

      _isJoined = false;
      _isConnecting = false;
      _currentChannelId = null;
      _localUid = null;
      _remoteUid = null;
      _isMuted = false;
      _isVideoEnabled = true;
      _isScreenSharing = false;
      _isScreenShareAvailable = true;
      _screenSharingUid = null;
      _lastError = null;
      _connectionState = ConnectionStateType.connectionStateDisconnected;

      notifyListeners();
      debugPrint('[AgoraService] Session cleaned up');
    } catch (e) {
      debugPrint('[AgoraService] Error cleaning up session: $e');
    }
  }

  void reset() {
    _isInitialized = false;
    _isJoined = false;
    _isConnecting = false;
    _isMuted = false;
    _isVideoEnabled = true;
    _isSpeakerEnabled = true;
    _isScreenSharing = false;
    _isScreenShareAvailable = true;
    _screenSharingUid = null;
    _currentChannelId = null;
    _localUid = null;
    _remoteUid = null;
    _lastError = null;
    _connectionState = ConnectionStateType.connectionStateDisconnected;

    if (_engine != null) {
      _engine!.release();
      _engine = null;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    if (_isInitialized && _engine != null) {
      _engine!.release();
    }
    super.dispose();
  }
}
