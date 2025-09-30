// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html';

import 'package:intl/intl.dart';

String get localeName {
  final List<String>? languages = window.navigator.languages;
  return Intl.canonicalizedLocale(
    languages?.isNotEmpty == true
        ? languages!.first
        : window.navigator.language,
  );
}
