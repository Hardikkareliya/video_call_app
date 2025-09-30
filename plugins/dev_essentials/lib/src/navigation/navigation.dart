import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../dev_essentials.dart';

// Decoders
part 'src/decoders/path_decoded.dart';
// Transition
part 'src/transition/directionality_drag_gesure_recognizer.dart';
part 'src/transition/dev_essential_back_gesture.dart';
part 'src/transition/dev_essential_page_route_transition.dart';
part 'src/transition/custom_transitions.dart';
// Middleware

//Navigation Observer
part 'src/observer/dev_essential_navigation_observer.dart';

// Navigation Interface
part 'src/dev_essential_navigation_interface.dart';

//Router Outlet
part 'src/dev_essential_router_lisener.dart';

part 'src/dev_essential_routing.dart';
part 'src/dev_essential_bottomsheet_route.dart';
part 'src/dev_essential_dialog_route.dart';
part 'src/dev_essential_navigator.dart';

enum PopMode {
  history,
  page,
}

enum PreventDuplicateHandlingMode {
  popUntilOriginalRoute,

  doNothing,

  reorderRoutes,

  recreate,
}

String? _extractRouteName(Route? route) {
  if (route?.settings.name != null) {
    return route!.settings.name;
  }

  if (route is DevEssentialDialogRoute) {
    return 'DIALOG ${route.hashCode}';
  }

  if (route is DevEssentialModalBottomSheetRoute) {
    return 'BOTTOMSHEET ${route.hashCode}';
  }

  return null;
}
