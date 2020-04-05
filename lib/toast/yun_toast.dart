//
// Created by yun on 2020-02-18.
//

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// 封装 todo
class YunToast {
  static void showToast(
    String text, {
    gravity: ToastGravity.CENTER,
    toastLength: Toast.LENGTH_LONG,
  }) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: toastLength,
      gravity: gravity,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey[600],
      fontSize: 16.0,
    );
  }
}
