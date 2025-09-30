part of 'app_router.dart';

abstract class Routes {
  static const String splash = _Paths.splash;
  static const String login = _Paths.login;
  static const String home = _Paths.home;
  static const String users = _Paths.users;
  static const String videoCall = _Paths.videoCall;

}

abstract class _Paths {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/home';
  static const String videoCall = '/videoCall';
  static const String users = '/users';

}
