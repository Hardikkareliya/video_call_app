import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hipster_assignment_task/core/theme/app_theme.dart';

import '../../../core/utils/constants.dart';
import '../cubit/video_call_cubit.dart';
import '../models/ui_stats/video_call_state.dart';

class VideoCallView extends StatefulWidget {
  const VideoCallView({super.key});

  @override
  State<VideoCallView> createState() => _VideoCallViewState();
}

class _VideoCallViewState extends State<VideoCallView>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      context.read<VideoCallCubit>().leaveChannel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoCallCubit, VideoCallState>(
      builder: (context, state) {
        final isLandscape =
            MediaQuery.of(context).orientation == Orientation.landscape;

        return Scaffold(
          backgroundColor: AppColors.black,
          appBar: isLandscape
              ? null
              : AppBar(
                  title: Text(
                    'Video Call',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 20,
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  backgroundColor: Colors.black,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                ),
          body: state.isInitialized
              ? isLandscape
                    ? _buildLandscapeLayout(context, state)
                    : _buildPortraitLayout(context, state)
              : _buildInitializationView(),
        );
      },
    );
  }

  Widget _buildPortraitLayout(BuildContext context, VideoCallState state) {
    return Column(
      children: [
        Expanded(child: _buildVideoCallView(context, state)),
        _buildControls(context, state),
      ],
    );
  }

  Widget _buildLandscapeLayout(BuildContext context, VideoCallState state) {
    return Row(
      children: [
        // Video area takes most of the space
        Expanded(flex: 3, child: _buildVideoCallView(context, state)),
        // Controls on the right side
        Container(
          width: 120,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: _buildLandscapeControls(context, state),
        ),
      ],
    );
  }

  Widget _buildInitializationView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Colors.blue),
          const SizedBox(height: 24),
          Text(
            'Initializing Agora...',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Setting up video calling engine',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.whiteTwo,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoCallView(BuildContext context, VideoCallState state) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Container(
      margin: EdgeInsets.all(isLandscape ? 8 : 16),
      child: Stack(
        children: [
          // Remote video (main view)
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(isLandscape ? 8 : 12),
              border: Border.all(color: Colors.white24, width: 1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(isLandscape ? 8 : 12),
              child: context.read<VideoCallCubit>().buildRemoteVideoView(),
            ),
          ),

          // Local video (picture-in-picture) - responsive sizing
          Positioned(
            top: isLandscape ? 8 : 16,
            right: isLandscape ? 8 : 16,
            child: Container(
              width: isLandscape ? 100 : 120,
              height: isLandscape ? 75 : 160,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white54, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: context.read<VideoCallCubit>().buildLocalVideoView(),
              ),
            ),
          ),

          // Connection status overlay
          if (state.isConnecting)
            Container(
              color: Colors.black54,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(color: Colors.white),
                    const SizedBox(height: 16),
                    Text(
                      'Connecting...',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Error banner
          if (state.hasError)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        state.error!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () =>
                          context.read<VideoCallCubit>().clearError(),
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildControls(BuildContext context, VideoCallState state) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Join/Leave button
          _buildControlButton(
            icon: state.isJoined ? Icons.call_end : Icons.call,
            label: state.isJoined ? 'Leave' : 'Join',
            color: state.isJoined ? Colors.red : Colors.green,
            onPressed: state.isJoined
                ? () => context.read<VideoCallCubit>().leaveChannel()
                : () =>
                      context.read<VideoCallCubit>().joinChannel(CHANNEL_NAME),
          ),

          // Mute/Unmute button
          _buildControlButton(
            icon: state.isMuted ? Icons.mic_off : Icons.mic,
            label: state.isMuted ? 'Unmute' : 'Mute',
            color: state.isMuted ? Colors.red : Colors.white,
            onPressed: state.canToggleAudio
                ? () => context.read<VideoCallCubit>().toggleMute()
                : null,
          ),

          // Video on/off button
          _buildControlButton(
            icon: state.isVideoEnabled ? Icons.videocam : Icons.videocam_off,
            label: state.isVideoEnabled ? 'Video Off' : 'Video On',
            color: state.isVideoEnabled ? Colors.white : Colors.red,
            onPressed: state.canToggleVideo
                ? () => context.read<VideoCallCubit>().toggleVideo()
                : null,
          ),

          // Switch camera button
          _buildControlButton(
            icon: Icons.switch_camera,
            label: 'Switch',
            color: Colors.white,
            onPressed: state.isJoined && state.isVideoEnabled
                ? () => context.read<VideoCallCubit>().switchCamera()
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildLandscapeControls(BuildContext context, VideoCallState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Join/Leave button
        _buildLandscapeControlButton(
          icon: state.isJoined ? Icons.call_end : Icons.call,
          color: state.isJoined ? Colors.red : Colors.green,
          onPressed: state.isJoined
              ? () => context.read<VideoCallCubit>().leaveChannel()
              : () => context.read<VideoCallCubit>().joinChannel(CHANNEL_NAME),
        ),

        // Mute/Unmute button
        _buildLandscapeControlButton(
          icon: state.isMuted ? Icons.mic_off : Icons.mic,
          color: state.isMuted ? Colors.red : Colors.white,
          onPressed: state.canToggleAudio
              ? () => context.read<VideoCallCubit>().toggleMute()
              : null,
        ),

        // Video on/off button
        _buildLandscapeControlButton(
          icon: state.isVideoEnabled ? Icons.videocam : Icons.videocam_off,
          color: state.isVideoEnabled ? Colors.white : Colors.red,
          onPressed: state.canToggleVideo
              ? () => context.read<VideoCallCubit>().toggleVideo()
              : null,
        ),

        // Switch camera button
        _buildLandscapeControlButton(
          icon: Icons.switch_camera,
          color: Colors.white,
          onPressed: state.isJoined && state.isVideoEnabled
              ? () => context.read<VideoCallCubit>().switchCamera()
              : null,
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: onPressed != null
                ? color.withValues(alpha: 0.2)
                : Colors.grey.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(icon, color: onPressed != null ? color : Colors.grey),
            iconSize: 28,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: onPressed != null ? color : Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildLandscapeControlButton({
    required IconData icon,
    required Color color,
    VoidCallback? onPressed,
  }) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: onPressed != null
            ? color.withValues(alpha: 0.2)
            : Colors.grey.withValues(alpha: 0.2),
        shape: BoxShape.circle,
        border: Border.all(
          color: onPressed != null ? color : Colors.grey,
          width: 1,
        ),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: onPressed != null ? color : Colors.grey),
        iconSize: 24,
      ),
    );
  }
}
