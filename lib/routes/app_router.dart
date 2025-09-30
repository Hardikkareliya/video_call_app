import 'package:flutter/material.dart';
import 'package:dev_essentials/dev_essentials.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hipster_assignment_task/feature/Home/cubit/home_cubit.dart';
import 'package:hipster_assignment_task/feature/Home/views/home_views.dart';
import 'package:hipster_assignment_task/feature/users/cubit/users_cubit.dart';
import 'package:hipster_assignment_task/feature/users/views/users_views.dart';
import 'package:hipster_assignment_task/feature/video_call/cubit/video_call_cubit.dart';
import 'package:hipster_assignment_task/feature/video_call/views/video_call_views.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/custom_widgets/error_404_view.dart';
import '../feature/splashscreen/splash_screen.dart';
import '../feature/auth/login/cubit/login_cubit.dart';
import '../feature/auth/login/views/login_views.dart';

part 'app_routes.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: Routes.splash,
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: Routes.splash,
        name: 'splash',
        pageBuilder: (context, state) => CustomTransitions.fadeTransition(
          context: context,
          state: state,
          child: const SplashScreen(),
        ),
      ),
      GoRoute(
        path: Routes.login,
        name: 'login',
        pageBuilder: (context, state) => CustomTransitions.fadeTransition(
          context: context,
          state: state,
          child: BlocProvider(
            create: (context) => LoginCubit(),
            child: const LoginView(),
          ),
        ),
      ),
      GoRoute(
        path: Routes.home,
        name: 'home',
        pageBuilder: (context, state) => CustomTransitions.fadeTransition(
          context: context,
          state: state,
          child: BlocProvider(
            create: (context) => HomeCubit(),
            child: const HomeView(),
          ),
        ),
      ),
      GoRoute(
        path: Routes.videoCall,
        name: 'videoCall',
        pageBuilder: (context, state) => CustomTransitions.fadeTransition(
          context: context,
          state: state,
          child: BlocProvider(
            create: (context) => VideoCallCubit(),
            child: const VideoCallView(),
          ),
        ),
      ),
      GoRoute(
        path: Routes.users,
        name: 'users',
        pageBuilder: (context, state) => CustomTransitions.fadeTransition(
          context: context,
          state: state,
          child: BlocProvider(
            create: (context) {
              UsersCubit usersCubit = UsersCubit();
              usersCubit.onInit();
              return usersCubit;
            },
            child: const UsersView(),
          ),
        ),
      ),
    ],
    redirect: (context, state) async {
      // Don't redirect if we're on the splash screen
      if (state.uri.path == Routes.splash) {
        return null;
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isAuthenticated = prefs.getBool('isAuthenticated') ?? false;

      // Only redirect to home if user is authenticated and trying to access login
      if (isAuthenticated && state.uri.path == Routes.login) {
        return Routes.home;
      }

      // Redirect to login if user is not authenticated and not already on login page
      if (!isAuthenticated && state.uri.path != Routes.login) {
        return Routes.login;
      }

      return null;
    },
    errorBuilder: (context, state) => const Error404View(),
  );
}
