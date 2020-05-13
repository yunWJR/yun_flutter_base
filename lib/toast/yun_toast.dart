//
// Created by yun on 2020-02-18.
//

import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

typedef ShowToastHandle = bool Function(
  String text,
  BuildContext context, {
  int duration,
  int gravity,
});

class YunToastConfig {
  static ShowToastHandle showToastHandle;
}

// 封装 todo
class YunToast {
  static void showToast(
    String msg,
    BuildContext context, {
    duration: 1,
    gravity: 0,
  }) {
    if (YunToastConfig.showToastHandle != null) {
      bool handle = YunToastConfig.showToastHandle(msg, context, duration: duration, gravity: gravity);
      if (handle) {
        return;
      }
    }

    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
}
