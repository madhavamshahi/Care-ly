import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter/material.dart';

showToast(
    {required String toast,
    required BuildContext context,
    required Color color}) {
  Navigator.pop(context);

  return Fluttertoast.showToast(
      msg: toast,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0);
}
