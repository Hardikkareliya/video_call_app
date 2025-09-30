import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

extension StringExt on String {
  void showToast({
    Color backgroundColor = Colors.transparent,
    Color contentColor = Colors.black54,
  }) => Fluttertoast.showToast(
    msg: this,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: contentColor,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
