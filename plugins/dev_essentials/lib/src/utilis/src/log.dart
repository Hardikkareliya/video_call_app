part of '../utils.dart';

typedef DevEssentialLogWriterCallback = void Function(dynamic message,
    {String? name});

void defaultLogWriterCallback(
  dynamic message, {
  String? name,
  DateTime? time,
  int? sequenceNumber,
  int level = 0,
  Zone? zone,
  Object? error,
  StackTrace? stackTrace,
}) {
  if (Dev.isLogEnable) {
    developer.log(
      message.toString(),
      name: name ?? 'DevEssential',
      time: time,
      sequenceNumber: sequenceNumber,
      level: level,
      zone: zone,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
