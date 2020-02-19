//
// Created by yun on 2020-02-16.
//

import 'package:flutter/cupertino.dart';
import 'package:yun_base/config/yun_config.dart';

class YunAction {
  static Future<int> showAction(
    BuildContext context,
    List<String> actions, {
    String title,
    String message,
  }) async {
    if (YunConfig.iOSMode()) {
      return showIOSAction(context, actions, title: title, message: message);
    } else {
      // todo 后期增加
      return showIOSAction(context, actions, title: title, message: message);
    }
  }

  static Future<int> showIOSAction(
    BuildContext context,
    List<String> actions, {
    String title,
    String message,
  }) async {
    int i = await showCupertinoModalPopup<int>(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: title == null ? null : Text(title ?? "选择"),
            message: message == null ? null : Text(message ?? "选择"),
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context, null);
              },
              child: new Text("取消"),
            ),
            actions: actions.asMap().keys.map((index) {
              return CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context, index);
                },
                child: new Text(actions[index]),
              );
            }).toList(),
          );
        });

    return i;
  }
}
