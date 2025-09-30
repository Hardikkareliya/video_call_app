part of '../navigation.dart';

class InheritedNavigator extends InheritedWidget {
  const InheritedNavigator({
    super.key,
    required super.child,
    required this.navigatorKey,
  });
  final GlobalKey<NavigatorState> navigatorKey;

  static InheritedNavigator? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<InheritedNavigator>();

  @override
  bool updateShouldNotify(InheritedNavigator oldWidget) => true;
}

// DevEssentialNavigator removed: DevEssentialPage is no longer supported.
