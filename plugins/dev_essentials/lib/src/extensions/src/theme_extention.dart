part of '../extensions.dart';

extension ThemeExtension on DevEssential {
  ThemeData get theme => Theme.of(context);

  TextTheme get textTheme => theme.textTheme;

  DrawerThemeData get drawerTheme => theme.drawerTheme;

  BottomAppBarThemeData get bottomAppBarTheme => theme.bottomAppBarTheme;

  AppBarThemeData get appBarTheme => theme.appBarTheme;

  CardThemeData get cardTheme => theme.cardTheme;

  BottomNavigationBarThemeData get bottomNavigationBarTheme =>
      theme.bottomNavigationBarTheme;

  BadgeThemeData get badgeTheme => theme.badgeTheme;

  IconThemeData get iconTheme => theme.iconTheme;

  Color? get iconColor => iconTheme.color;

  // void setTheme(ThemeData themeData) => _hookState.setTheme(themeData);
  //
  // void setThemeMode(ThemeMode themeMode) => _hookState.setThemeMode(themeMode);

  bool get isDarkMode => theme.brightness == Brightness.dark;
}
