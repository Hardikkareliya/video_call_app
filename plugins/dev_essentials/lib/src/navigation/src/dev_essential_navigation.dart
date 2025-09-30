import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../dev_essentials.dart';

/// Navigation extension methods for Dev class
extension DevEssentialNavigation on DevEssential {
  /// Navigate to a named route
  static Future<T?> toNamed<T>(
      String routeName, {
        Map<String, String>? pathParameters,
        Map<String, dynamic>? queryParameters,
        Object? extra,
      }) {
    final context = Dev.context;

    // Only include parameters when they are non-null
    if (pathParameters != null && queryParameters != null) {
      return context.pushNamed<T>(
        routeName,
        pathParameters: pathParameters,
        queryParameters: queryParameters,
        extra: extra,
      );
    } else if (pathParameters != null) {
      return context.pushNamed<T>(
        routeName,
        pathParameters: pathParameters,
        extra: extra,
      );
    } else if (queryParameters != null) {
      return context.pushNamed<T>(
        routeName,
        queryParameters: queryParameters,
        extra: extra,
      );
    } else {
      return context.pushNamed<T>(
        routeName,
        extra: extra,
      );
    }
  }

  /// Navigate to a named route and remove the current route
  static Future<T?> offNamed<T>(
      String routeName, {
        Map<String, String>? pathParameters,
        Map<String, dynamic>? queryParameters,
        Object? extra,
      }) {
    final context = Dev.context;

    // In go_router 13.2.0, pushReplacementNamed returns void, so we need to wrap it
    context.pushReplacementNamed(
      routeName,
      pathParameters: pathParameters ?? const {},
      queryParameters: queryParameters ?? const {},
      extra: extra,
    );

    // Return a completed future with null value to match the Future<T?> return type
    return Future.value(null);
  }

  static Future<T?> offAllNamed<T>(
      String routeName, {
        Map<String, String>? pathParameters,
        Map<String, dynamic>? queryParameters,
        Object? extra,
      }) {
    final context = Dev.context;

    // context.goNamed returns void in go_router 13.2.0, so we need to wrap it
    context.goNamed(
      routeName,
      pathParameters: pathParameters ?? const {},
      queryParameters: queryParameters ?? const {},
      extra: extra,
    );

    // Return a completed future with null value to match the Future<T?> return type
    return Future.value(null);
  }

  /// Navigate back
  static void back<T>([T? result]) {
    final context = Dev.context;

    if (context.canPop()) {
      context.pop(result);
    }
  }

  /// Navigate to a widget (creates a dynamic route)
  static Future<T?> to<T>(
      Widget page, {
        String? name,
        bool fullscreenDialog = false,
        DevEssentialTransition? transition,
        Duration? duration,
        Curve? curve,
        Object? arguments,
      }) {
    final context = Dev.context;

    // Create a unique route name if not provided
    final routeName = name ?? '/${page.runtimeType}';

    // Handle transitions using CustomTransitionPage if transition is specified
    if (transition != null) {
      return _navigateWithTransition<T>(
        context,
        routeName,
        page,
        transition,
        duration ?? const Duration(milliseconds: 300),
        curve ?? Curves.easeInOut,
        fullscreenDialog,
        arguments,
      );
    }

    // Use go_router's push method for standard navigation
    return context.push<T>(
      routeName,
      extra: arguments,
    );
  }

  /// Helper method to navigate with custom transitions
  static Future<T?> _navigateWithTransition<T>(
      BuildContext context,
      String routeName,
      Widget page,
      DevEssentialTransition transition,
      Duration duration,
      Curve curve,
      bool fullscreenDialog,
      Object? arguments,
      ) {
    // Create a custom page builder that applies the specified transition
    pageBuilder(BuildContext context, GoRouterState state) {
      return page;
    }

    // Apply the transition based on the specified type
    Page<dynamic> Function(BuildContext, GoRouterState) transitionPageBuilder;

    switch (transition) {
      case DevEssentialTransition.fade:
        transitionPageBuilder = (context, state) => CustomTransitionPage<T>(
          key: state.pageKey,
          child: page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(parent: animation, curve: curve),
              child: child,
            );
          },
          transitionDuration: duration,
          fullscreenDialog: fullscreenDialog,
        );
        break;

      case DevEssentialTransition.rightToLeft:
        transitionPageBuilder = (context, state) => CustomTransitionPage<T>(
          key: state.pageKey,
          child: page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: animation, curve: curve)),
              child: child,
            );
          },
          transitionDuration: duration,
          fullscreenDialog: fullscreenDialog,
        );
        break;

      case DevEssentialTransition.leftToRight:
        transitionPageBuilder = (context, state) => CustomTransitionPage<T>(
          key: state.pageKey,
          child: page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-1.0, 0.0),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: animation, curve: curve)),
              child: child,
            );
          },
          transitionDuration: duration,
          fullscreenDialog: fullscreenDialog,
        );
        break;

      case DevEssentialTransition.downToUp:
        transitionPageBuilder = (context, state) => CustomTransitionPage<T>(
          key: state.pageKey,
          child: page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 1.0),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: animation, curve: curve)),
              child: child,
            );
          },
          transitionDuration: duration,
          fullscreenDialog: fullscreenDialog,
        );
        break;

      case DevEssentialTransition.upToDown:
        transitionPageBuilder = (context, state) => CustomTransitionPage<T>(
          key: state.pageKey,
          child: page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, -1.0),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: animation, curve: curve)),
              child: child,
            );
          },
          transitionDuration: duration,
          fullscreenDialog: fullscreenDialog,
        );
        break;

      case DevEssentialTransition.downToUp:
        transitionPageBuilder = (context, state) => CustomTransitionPage<T>(
          key: state.pageKey,
          child: page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return ScaleTransition(
              scale: CurvedAnimation(parent: animation, curve: curve),
              child: child,
            );
          },
          transitionDuration: duration,
          fullscreenDialog: fullscreenDialog,
        );
        break;

      case DevEssentialTransition.size:
      case DevEssentialTransition.cupertino:
      case DevEssentialTransition.cupertinoDialog:
      case DevEssentialTransition.native:
      default:
      // For other transitions, use the default go_router push
        return context.push<T>(
          routeName,
          extra: arguments,
        );
    }

    // Use go_router's push method with the custom transition page builder
    return context.push<T>(
      routeName,
      extra: arguments,
    );
  }
}