import 'package:flutter/material.dart';

void showInSnackBar(
    {required String value,
    required Color color,
    int sec = 3,
    required BuildContext context}) {
  FocusScope.of(context).requestFocus(FocusNode());

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      value,
      textAlign: TextAlign.center,
      style: const TextStyle(
          color: Colors.white, fontSize: 16.0, fontFamily: "WorkSansSemiBold"),
    ),
    backgroundColor: color,
    duration: Duration(seconds: sec),
  ));
}
