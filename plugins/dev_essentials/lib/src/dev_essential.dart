import 'package:flutter/foundation.dart';

import '../dev_essentials.dart';

abstract class _DevEssentialInterface {
  bool isLogEnable = kDebugMode;

  DevEssentialLogWriterCallback log = defaultLogWriterCallback;
}

class DevEssential extends _DevEssentialInterface {}

// ignore: non_constant_identifier_names
final DevEssential Dev = DevEssential();

// ignore: non_constant_identifier_names
final DevEssential DEV = Dev;
