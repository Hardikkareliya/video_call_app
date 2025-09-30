// part of '../apps.dart';
//
//
//
// class DevEssentialMaterialApp extends StatelessWidget {
//   const DevEssentialMaterialApp({
//     super.key,
//     required this.title,
//     this.routerConfig,
//     this.theme,
//     this.darkTheme,
//     this.themeMode = ThemeMode.system,
//     this.locale,
//     this.fallbackLocale,
//     this.supportedLocales = const <Locale>[Locale('en', 'US')],
//     this.localizationsDelegates,
//     this.builder,
//     this.debugShowCheckedModeBanner = true,
//     this.color,
//   });
//
//   final String title;
//   final RouterConfig<Object>? routerConfig;
//   final ThemeData? theme;
//   final ThemeData? darkTheme;
//   final ThemeMode themeMode;
//   final Locale? locale;
//   final Locale? fallbackLocale;
//   final Iterable<Locale> supportedLocales;
//   final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
//   final TransitionBuilder? builder;
//   final bool debugShowCheckedModeBanner;
//   final Color? color;
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp.router(
//       title: title,
//       routerConfig: routerConfig!,
//       theme: theme,
//       darkTheme: darkTheme,
//       themeMode: themeMode,
//       locale: locale,
//       supportedLocales: supportedLocales,
//       localizationsDelegates: localizationsDelegates,
//       builder: builder,
//       debugShowCheckedModeBanner: debugShowCheckedModeBanner,
//       color: color,
//     );
//   }
// }