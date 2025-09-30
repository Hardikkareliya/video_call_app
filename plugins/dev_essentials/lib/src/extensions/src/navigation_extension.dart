part of '../extensions.dart';

// Only keep navigation helpers that use go_router or standard Flutter APIs.

extension NavigationExtension on DevEssential {
  /// Helper method to get the current BuildContext
  BuildContext? _getContext() {
    final ctx = context;
    return ctx;
  }

  /// Helper method to show navigation errors
  void _showNavigationError(BuildContext context, String route) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navigation to $route failed. Please try again.'),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Navigate to a widget page
  ///
  /// This is a compatibility method that creates a temporary route for the widget
  /// and navigates to it using go_router.
  Future<T?>? to<T extends Object?>(
    Widget page, {
    bool? opaque,
    DevEssentialTransition? transition,
    Curve? curve,
    Duration? duration,
    String? id,
    String? routeName,
    bool fullscreenDialog = false,
    dynamic arguments,
    bool preventDuplicates = true,
    bool? popGesture,
    bool showCupertinoParallax = true,
    double Function(BuildContext context)? gestureWidth,
    bool rebuildStack = true,
    PreventDuplicateHandlingMode preventDuplicateHandlingMode =
        PreventDuplicateHandlingMode.reorderRoutes,
  }) {
    final ctx = _getContext();
    if (ctx == null) return null;

    log('WARNING: Dev.to() is using a compatibility layer with go_router. Consider using named routes instead.');

    // Create a unique route name if not provided
    routeName ??= "/${page.runtimeType.toString()}";

    try {
      // Use push to add the page to the stack
      return Future.value(ctx.push<T>(
        routeName,
        extra: arguments,
      ));
    } catch (e) {
      log('Navigation error: $e');
      _showNavigationError(ctx, routeName);
      return null;
    }
  }

  /// Navigate to a named route
  ///
  /// Uses go_router's go() method to navigate to a named route
  // void toNamed(
  //   BuildContext context,
  //   String route, {
  //   Object? extra,
  // }) {
  //   try {
  //     context.push(
  //       route,
  //       extra: extra,
  //     );
  //   } catch (e) {
  //     log('Navigation error: $e');
  //     _showNavigationError(context, route);
  //   }
  // }
  Future<T?>? toNamed<T>(
    BuildContext context,
    String route, {
    Object? extra,
  }) async {
    try {
      return await context.push(
        route,
        extra: extra,
      );
    } catch (e) {
      log('Navigation error: $e');
      _showNavigationError(context, route);
      return null;
    }
  }

  /// Navigate to a named route and remove the current route
  ///
  /// Uses go_router's replace() method to replace the current route
  Future<T?>? offNamed<T>(
    BuildContext context,
    String route, {
    Object? extra,
  }) {
    try {
      context.go(
        route,
        extra: extra,
      );

      return Future.value(null);
    } catch (e) {
      log('Navigation error: $e');
      _showNavigationError(context, route);
      return null;
    }
  }

  /// Navigate back
  ///
  /// Uses go_router's pop() method
  void back<T>({
    T? result,
    bool canPop = true,
    int times = 1,
    String? id,
  }) {
    final ctx = _getContext();
    if (ctx == null) return;

    if (times < 1) {
      times = 1;
    }

    if (times > 1) {
      // Multiple pops with go_router
      for (var i = 0; i < times; i++) {
        if (canPop && ctx.canPop()) {
          ctx.pop(i == times - 1 ? result : null);
        } else {
          break;
        }
      }
    } else {
      // Single pop
      // if (canPop) {
      //   if (ctx.canPop()) {
      //     ctx.pop(result);
      //   }
      // } else {
      //   ctx.pop(result);
      // }
      GoRouter.of(context).pop(result);
    }
  }

  /// Navigate to a widget page and remove the current route
  ///
  /// This is a compatibility method that uses go_router's replace() method
  Future<T?>? off<T>(
    DevEssentialPageBuilder page, {
    bool? opaque,
    DevEssentialTransition? transition,
    Curve? curve,
    bool? popGesture,
    String? id,
    String? routeName,
    dynamic arguments,
    bool fullscreenDialog = false,
    bool preventDuplicates = true,
    Duration? duration,
    double Function(BuildContext context)? gestureWidth,
  }) {
    final ctx = _getContext();
    if (ctx == null) return null;

    log('WARNING: Dev.off() is using a compatibility layer with go_router. Consider using named routes instead.');

    routeName ??= "/${page.runtimeType.toString()}";

    try {
      ctx.replace(
        routeName,
        extra: arguments,
      );
      return Future.value(null);
    } catch (e) {
      log('Navigation error: $e');
      _showNavigationError(ctx, routeName);
      return null;
    }
  }

  /// Navigate to a named route and remove all routes until a predicate is satisfied
  ///
  /// Uses go_router's go() method which replaces the entire history
  // Future<T?>? offNamedUntil<T>(
  //     String route,
  //     DevEssentialPageRoutePredicate? predicate, {
  //       String? id,
  //       dynamic arguments,
  //       Map<String, String>? parameters,
  //     }) {
  //   final ctx = _getContext();
  //   if (ctx == null) return null;
  //
  //   log('WARNING: Dev.offNamedUntil() is using go() which replaces the entire history in go_router.');
  //
  //   try {
  //     ctx.go(
  //       route,
  //       extra: arguments,
  //     );
  //     return Future.value(null);
  //   } catch (e) {
  //     log('Navigation error: $e');
  //     _showNavigationError(ctx, route);
  //     return null;
  //   }
  // }

  /// Navigate to a named route after popping the current route
  ///
  /// Uses go_router's replace() method
  Future<T?>? offAndToNamed<T>(
    String route, {
    dynamic arguments,
    String? id,
    dynamic result,
    Map<String, String>? parameters,
  }) {
    final ctx = _getContext();
    if (ctx == null) return null;

    try {
      ctx.replace(
        route,
        extra: arguments,
      );
      return Future.value(null);
    } catch (e) {
      log('Navigation error: $e');
      _showNavigationError(ctx, route);
      return null;
    }
  }

  /// Remove a route by name
  ///
  /// This is a compatibility method with limited functionality in go_router
  void removeRoute(String name, {String? id}) {
    final ctx = _getContext();
    if (ctx == null) return;

    log('WARNING: Dev.removeRoute() has limited functionality with go_router. Consider redesigning your navigation flow.');

    // Best effort: just pop once
    if (ctx.canPop()) {
      ctx.pop();
    }
  }

  /// Navigate to a named route and remove all previous routes
  ///
  /// Uses go_router's go() method which replaces the entire history
  Future<T?>? offAllNamed<T>(
    String route, {
    dynamic arguments,
    String? id,
    Map<String, String>? parameters,
  }) {
    final ctx = _getContext();
    if (ctx == null) return null;

    try {
      ctx.go(
        route,
        extra: arguments,
      );
      return Future.value(null);
    } catch (e) {
      log('Navigation error: $e');
      _showNavigationError(ctx, route);
      return null;
    }
  }

  /// Helper method to search for a delegate by ID
  ///
  /// This is a compatibility method that returns a dummy delegate for go_router
// GoRouterDelegate searchDelegate(String? k) {
//   log('WARNING: Dev.searchDelegate() is deprecated with go_router. Use context-based navigation instead.');
//
//   // Return the root delegate as a fallback
//   return null;
// }
}
