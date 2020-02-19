//
// Created by yun on 2020-02-16.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yun_base/config/yun_config.dart';
import 'package:yun_base/log/yun_log.dart';
import 'package:yun_base/model/yun_rst_data.dart';

enum YunHandleRstType { Close }

typedef YunRspErrHandle = void Function(dynamic org, YunRspData data);

typedef YunHandleRst = void Function(YunHandleRstType rst);

class YunAlert {
  static YunRspErrHandle rspErrHandle;

  static void showRspErr(BuildContext context, YunRspData data, dynamic org) {
    String err = data.getErrMsg();

    showErr(context, err ?? "未知错误", handle: (rst) {
      if (rst == YunHandleRstType.Close) {
        if (rspErrHandle != null) {
          rspErrHandle(org, data);
        }
      }
    });
  }

  static void showErr(BuildContext context, String error, {YunHandleRst handle}) {
    if (YunConfig.iOSMode()) {
      return showIOSErr(context, error, handle: handle);
    } else {
      // todo 后期增加
      return showIOSErr(context, error, handle: handle);
    }
  }

  static void showIOSErr(BuildContext context, String error, {YunHandleRst handle}) {
    YunLog.log("SHOW ERROR", error);

    showDialog<bool>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text("提示"),
          content: Text(error),
          actions: <Widget>[
//            FlatButton(
//              child: Text("取消"),
//              onPressed: () => Navigator.of(context).pop(), // 关闭对话框
//            ),
            FlatButton(
              child: Text("确定"),
              onPressed: () {
                if (handle != null) {
                  handle(YunHandleRstType.Close);
                }

                //关闭对话框并返回true
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }
}
