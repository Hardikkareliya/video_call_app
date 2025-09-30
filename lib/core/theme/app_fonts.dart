part of './app_theme.dart';

class AppFonts {
  static String get defaultFontFamily => 'DMSans';

  static TextTheme get textTheme => const TextTheme(
        displayLarge: TextStyle(
          fontSize: 112.0,
          fontWeight: FontWeight.w100,
          textBaseline: TextBaseline.alphabetic,
          decoration: TextDecoration.none,
        ),
        displayMedium: TextStyle(
          fontSize: 55.0,
          fontWeight: FontWeight.w400,
          textBaseline: TextBaseline.alphabetic,
          decoration: TextDecoration.none,
        ),
        displaySmall: TextStyle(
          fontSize: 45.0,
          fontWeight: FontWeight.w400,
          textBaseline: TextBaseline.alphabetic,
          decoration: TextDecoration.none,
        ),
        headlineLarge: TextStyle(
          fontSize: 40.0,
          fontWeight: FontWeight.w400,
          textBaseline: TextBaseline.alphabetic,
          decoration: TextDecoration.none,
        ),
        headlineMedium: TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.w400,
          textBaseline: TextBaseline.alphabetic,
          decoration: TextDecoration.none,
        ),
        headlineSmall: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w400,
          textBaseline: TextBaseline.alphabetic,
          decoration: TextDecoration.none,
        ),
        titleLarge: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w500,
          textBaseline: TextBaseline.alphabetic,
          decoration: TextDecoration.none,
        ),
        titleMedium: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          textBaseline: TextBaseline.alphabetic,
          decoration: TextDecoration.none,
        ),
        titleSmall: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          textBaseline: TextBaseline.alphabetic,
          decoration: TextDecoration.none,
        ),
        bodyLarge: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          textBaseline: TextBaseline.alphabetic,
          decoration: TextDecoration.none,
        ),
        bodyMedium: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
          textBaseline: TextBaseline.alphabetic,
          decoration: TextDecoration.none,
        ),
        bodySmall: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w400,
          textBaseline: TextBaseline.alphabetic,
          decoration: TextDecoration.none,
        ),
        labelLarge: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          textBaseline: TextBaseline.alphabetic,
          decoration: TextDecoration.none,
        ),
        labelMedium: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w400,
          textBaseline: TextBaseline.alphabetic,
          decoration: TextDecoration.none,
        ),
        labelSmall: TextStyle(
          fontSize: 10.0,
          fontWeight: FontWeight.w400,
          textBaseline: TextBaseline.alphabetic,
          decoration: TextDecoration.none,
          letterSpacing: 0.8,
        ),
      );

  static TextTheme defaultTextTheme(ThemeData themeData) =>
      textTheme.merge(themeData.textTheme).apply(fontFamily: defaultFontFamily);
}
