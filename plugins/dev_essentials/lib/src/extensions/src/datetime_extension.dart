part of '../extensions.dart';

extension FormateDateTimeExtension on DateTime {
  String toEEEdMMMy([String? locale]) {
    return intl.DateFormat('EEE, d MMM y', locale).format(this);
  }

  String toEEEdMMM([String? locale]) {
    return intl.DateFormat('EEE, d MMM', locale).format(this);
  }

  String toEEEdMMMyyyy([String? locale]) {
    return intl.DateFormat('EEE, d MMM yyyy', locale).format(this);
  }

  String yyyyMMdd([String? locale]) {
    return intl.DateFormat('yyyy-MM-dd', locale).format(this);
  }

  String toddMMyyyy([String? locale]) {
    return intl.DateFormat('dd-MM-yyyy', locale).format(this);
  }

  String toddMMM([String? locale]) {
    return intl.DateFormat('dd MMM', locale).format(this);
  }

  String tod([String? locale]) {
    return intl.DateFormat('d', locale).format(this);
  }

  String tom([String? locale]) {
    return intl.DateFormat('MMM', locale).format(this);
  }

  String toEEE([String? locale]) {
    return intl.DateFormat('EEE', locale).format(this);
  }

  String todMMM([String? locale]) {
    return intl.DateFormat('d MMM', locale).format(this);
  }

  String time12HourFormat([String? locale]) {
    return intl.DateFormat('hh:mm a', locale).format(this);
  }

  String time24HourFormat([String? locale]) {
    return intl.DateFormat('HH:mm', locale).format(this);
  }

  String custom(String? pattern, [String? locale]) {
    if (pattern == null) {
      return toIso8601String();
    }
    return intl.DateFormat(pattern, locale).format(this);
  }

  String toddMMMyyyy([String? locale]) {
    return intl.DateFormat('dd MMM, yyyy', locale).format(this);
  }

  String tohm([String? locale]) {
    return intl.DateFormat.jm(locale).format(this);
  }

  String toyyyyMMdd([String? locale]) {
    return intl.DateFormat('yyyy-MM-dd', locale).format(this);
  }

  bool isLeapYear() =>
      (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));

  int getAge() {
    final today = DateTime.now();

    if (isAfter(today)) {
      return 0;
    }
    int age = today.year - year;
    final m = today.month - month;
    if (m < 0 || (m == 0 && today.day < day)) {
      /// if month difference is less than zero if not month difference is zero and today is  before  dob day, decrement age by one

      age--;
    }
    return age;
  }

  bool isToday() {
    final DateTime now = DateTime.now();
    return now.day == day && now.month == month && now.year == year;
  }

  bool isYesterday() {
    final DateTime yesterday =
        DateTime.now().subtract(const Duration(hours: 24));
    return yesterday.day == day &&
        yesterday.month == month &&
        yesterday.year == year;
  }

  bool isTomorrow() {
    final DateTime yesterday = DateTime.now().add(const Duration(hours: 24));
    return yesterday.day == day &&
        yesterday.month == month &&
        yesterday.year == year;
  }

  bool isCurrentMonth(int month) {
    final DateTime now = DateTime.now();
    return now.month == month;
  }

  bool isNextMonth(int month) {
    final DateTime now = DateTime.now();
    final DateTime nextMonth = DateTime(now.year, now.month + 1);
    return nextMonth.month == month;
  }

  bool isPreviousMonth(int month) {
    final DateTime now = DateTime.now();
    final DateTime previousMonth = DateTime(now.year, now.month - 1);
    return previousMonth.month == month;
  }

  String firstDayOfThisWeek(String? pattern) {
    final value = subtract(weekday.days);
    if (pattern == null) {
      return value.toIso8601String();
    }

    return value.custom(pattern);
  }

  String lastDayOfThisWeek(String? pattern) {
    final value = add((DateTime.daysPerWeek - (weekday + 1)).days);
    if (pattern == null) {
      return value.toIso8601String();
    }

    return value.custom(pattern);
  }

  String firstDayOfLastWeek(String? pattern) {
    final value = subtract((weekday + 7).days);
    if (pattern == null) {
      return value.toIso8601String();
    }

    return value.custom(pattern);
  }

  String lastDayOfLastWeek(String? pattern) {
    final value = subtract((weekday + 1).days);
    if (pattern == null) {
      return value.toIso8601String();
    }

    return value.custom(pattern);
  }

  String firstDayOfMonth(String? pattern) {
    final value = DateTime(year, month, 1);
    if (pattern == null) {
      return value.toIso8601String();
    }

    return value.custom(pattern);
  }

  String lastDayOfMonth(String? pattern) {
    final value = DateTime(year, month, DateUtils.getDaysInMonth(year, month));
    if (pattern == null) {
      return value.toIso8601String();
    }
    return value.custom(pattern);
  }

  String firstDayOfLastMonth(String? pattern) {
    final value = DateTime(year, month - 1, 1);
    if (pattern == null) {
      return value.toIso8601String();
    }

    return value.custom(pattern);
  }

  String lastDayOfLastMonth(String? pattern) {
    final value =
        DateTime(year, month - 1, DateUtils.getDaysInMonth(year, month - 1));
    if (pattern == null) {
      return value.toIso8601String();
    }

    return value.custom(pattern);
  }
}
