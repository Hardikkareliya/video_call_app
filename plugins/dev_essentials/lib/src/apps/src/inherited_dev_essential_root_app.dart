part of '../apps.dart';

typedef InheritedDevEssentialRootApp = _InheritedDevEssentialRootApp;

class _InheritedDevEssentialRootApp extends InheritedWidget {
  const _InheritedDevEssentialRootApp({
    required super.child,
    // required this.devEssentialHook,
  });

  // final DevEssentialHookState devEssentialHook;

  @override
  bool updateShouldNotify(covariant _InheritedDevEssentialRootApp oldWidget) =>
      true;
}
