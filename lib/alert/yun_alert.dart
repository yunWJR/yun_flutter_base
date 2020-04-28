//
// Created by yun on 2020-02-16.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yun_base/config/yun_config.dart';
import 'package:yun_base/log/yun_log.dart';
import 'package:yun_base/model/yun_rst_data.dart';

enum YunHandleRstType { Close, Yes, No, Sure, Cancel }

typedef YunRspErrHandle = void Function(dynamic org, YunRspData data);

typedef YunHandleRst = void Function(YunHandleRstType rst);

class YunAlert {
  static YunRspErrHandle rspErrHandle;

  // region showRspErr

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

  // endregion

  // region showErr

  static void showErr(BuildContext context, String error, {YunHandleRst handle}) {
    YunLog.log("SHOW ERROR:", error);

    if (YunConfig.iOSMode()) {
      return showIOSErr(context, error, handle: handle);
    } else {
      // todo 后期增加
      return showIOSErr(context, error, handle: handle);
    }
  }

  static void showIOSErr(BuildContext context, String error, {YunHandleRst handle}) {
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

  // endregion

  // region showYesNo

  static void showYesNo(BuildContext context, String title, String msg, {YunHandleRst handle}) {
    YunLog.log("SHOW YESNO:", title + ":" + msg);

    if (YunConfig.iOSMode()) {
      return showIOSYesNo(context, title, msg, handle: handle);
    } else {
      // todo 后期增加
      return showIOSYesNo(context, title, msg, handle: handle);
    }
  }

  static void showIOSYesNo(BuildContext context, String title, String msg, {YunHandleRst handle}) {
    showDialog<bool>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(msg),
          actions: <Widget>[
            FlatButton(
              child: Text("是"),
              onPressed: () {
                if (handle != null) {
                  handle(YunHandleRstType.Yes);
                }

                //关闭对话框并返回true
                Navigator.of(context).pop(true);
              },
            ),
            FlatButton(
              child: Text("否"),
              onPressed: () {
                if (handle != null) {
                  handle(YunHandleRstType.No);
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

// endregion

// region showSureCancel

  static void showSureCancel(BuildContext context, String title, String msg, {YunHandleRst handle}) {
    YunLog.log("SHOW SureCancel:", title + ":" + msg);

    if (YunConfig.iOSMode()) {
      return showIOSSureCancel(context, title, msg, handle: handle);
    } else {
      // todo 后期增加
      return showIOSSureCancel(context, title, msg, handle: handle);
    }
  }

  static void showIOSSureCancel(BuildContext context, String title, String msg, {YunHandleRst handle}) {
    showDialog<bool>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(msg),
          actions: <Widget>[
            FlatButton(
              child: Text("确认"),
              onPressed: () {
                if (handle != null) {
                  handle(YunHandleRstType.Sure);
                }

                //关闭对话框并返回true
                Navigator.of(context).pop(true);
              },
            ),
            FlatButton(
              child: Text("取消"),
              onPressed: () {
                if (handle != null) {
                  handle(YunHandleRstType.Cancel);
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

// endregion
}
