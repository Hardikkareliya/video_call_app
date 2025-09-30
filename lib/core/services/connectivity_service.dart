import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';

/// Network connectivity states
enum ConnectivityStatus { connected, disconnected, unknown }

/// Service to monitor network connectivity
class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();

  factory ConnectivityService() => _instance;

  ConnectivityService._internal();

  final StreamController<ConnectivityStatus> _statusController =
      StreamController<ConnectivityStatus>.broadcast();

  Timer? _connectivityTimer;
  ConnectivityStatus _currentStatus = ConnectivityStatus.unknown;
  bool _isMonitoring = false;

  /// Stream of connectivity status changes
  Stream<ConnectivityStatus> get statusStream => _statusController.stream;

  /// Current connectivity status
  ConnectivityStatus get currentStatus => _currentStatus;

  /// Check if device is currently online
  bool get isOnline => _currentStatus == ConnectivityStatus.connected;

  /// Check if device is currently offline
  bool get isOffline => _currentStatus == ConnectivityStatus.disconnected;

  /// Start monitoring connectivity
  void startMonitoring({Duration interval = const Duration(seconds: 5)}) {
    if (_isMonitoring) return;

    _isMonitoring = true;
    _connectivityTimer = Timer.periodic(interval, (_) async {
      await _checkConnectivity();
    });

    // Initial check
    _checkConnectivity();
  }

  /// Stop monitoring connectivity
  void stopMonitoring() {
    _connectivityTimer?.cancel();
    _connectivityTimer = null;
    _isMonitoring = false;
  }

  /// Check connectivity status
  Future<ConnectivityStatus> checkConnectivity() async {
    await _checkConnectivity();
    return _currentStatus;
  }

  /// Internal method to check connectivity
  Future<void> _checkConnectivity() async {
    try {
      final status = await _performConnectivityCheck();

      if (status != _currentStatus) {
        _currentStatus = status;
        _statusController.add(status);

        if (kDebugMode) {
          print('ConnectivityService: Status changed to ${status.name}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('ConnectivityService: Error checking connectivity: $e');
      }

      if (_currentStatus != ConnectivityStatus.unknown) {
        _currentStatus = ConnectivityStatus.unknown;
        _statusController.add(_currentStatus);
      }
    }
  }

  /// Perform actual connectivity check
  Future<ConnectivityStatus> _performConnectivityCheck() async {
    try {
      // Try to connect to a reliable host with shorter timeout
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 3));

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return ConnectivityStatus.connected;
      } else {
        return ConnectivityStatus.disconnected;
      }
    } on SocketException catch (_) {
      return ConnectivityStatus.disconnected;
    } on TimeoutException catch (_) {
      return ConnectivityStatus.disconnected;
    } catch (_) {
      return ConnectivityStatus
          .disconnected; // Default to disconnected on any error
    }
  }

  /// Dispose resources
  void dispose() {
    stopMonitoring();
    _statusController.close();
  }
}

/// Extension to provide human-readable connectivity status
extension ConnectivityStatusExtension on ConnectivityStatus {
  String get displayName {
    switch (this) {
      case ConnectivityStatus.connected:
        return 'Online';
      case ConnectivityStatus.disconnected:
        return 'Offline';
      case ConnectivityStatus.unknown:
        return 'Unknown';
    }
  }

  String get icon {
    switch (this) {
      case ConnectivityStatus.connected:
        return '🌐';
      case ConnectivityStatus.disconnected:
        return '📵';
      case ConnectivityStatus.unknown:
        return '❓';
    }
  }
}
