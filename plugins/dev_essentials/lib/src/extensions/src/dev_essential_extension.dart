part of '../extensions.dart';

extension DevEssentialExtension on DevEssential {
  void print(
    dynamic message, {
    String? name,
    DateTime? time,
    int? sequenceNumber,
    int level = 0,
    Zone? zone,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      defaultLogWriterCallback(
        message,
        name: name,
        time: time,
        sequenceNumber: sequenceNumber,
        level: level,
        zone: zone,
        error: error,
        stackTrace: stackTrace,
      );

  WidgetsBinding get engine => Engine.instance;

  SchedulerBinding get schedulerBinding => Engine.schedulerBinding;

  Future<String?> downloadFile(String url,
          {DownloadProgressCallback? progressCallback}) async =>
      await url.download(progressCallback: progressCallback);

  Future<void> forceAppUpdate() async => await engine.performReassemble();

  BuildContext get context {
    return GlobalKey<NavigatorState>().currentContext!;
  }


  BuildContext? get overlayContext {
    BuildContext? overlay;
    GlobalKey<NavigatorState>().currentState?.overlay?.context.visitChildElements((element) {
      overlay = element;
    });
    return overlay;
  }

  FocusNode? get focusScope => FocusManager.instance.primaryFocus;

  Color get randomColor => DevEssentialUtility.getRandomColor();

  String get randomString {
    final random = math.Random.secure();
    final values = List<int>.generate(16, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }

  int get randomInt => math.Random.secure().nextInt(99999999);

  TextDirection get textDirection =>
      intl.Bidi.isRtlLanguage(Localizations.localeOf(context).languageCode)
          ? TextDirection.rtl
          : TextDirection.ltr;

  List<String> getAllMonths({String? languageCode}) {
    List<String> months = [];
    for (int i = 1; i <= 12; i++) {
      DateTime month = DateTime(DateTime.now().year, i);
      String monthName =
          intl.DateFormat.MMMM(languageCode ?? locale?.languageCode)
              .format(month);
      months.add(monthName);
    }
    return months;
  }
}
