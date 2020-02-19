//
// Created by yun on 2020-02-18.
//

import 'package:yun_base/config/yun_config.dart';
import 'package:yun_base/model/yun_base_model.dart';
import 'package:yun_base/model/yun_rst_data.dart';


class YunLog {
  // region common

  static log(String tag, data) {
    if (_logOff()) {
      return;
    }

    print(DateTime.now().toString() + "--------------" + (tag ?? "未知错误") + "--------------");
    print(data ?? "无错误信息");
  }

  static logTag(String tag) {
    if (_logOff()) {
      return;
    }

    print(DateTime.now().toString() + "--------------" + (tag ?? "未知错误") + "--------------");
  }

  static logData(data) {
    if (_logOff()) {
      return;
    }

    print(data ?? "无错误信息");
  }

  static logDivide(String tag, bool isStart) {
    if (_logOff()) {
      return;
    }

    if (isStart) {
      print("START ▼▼▼▼▼▼▼▼▼▼▼▼▼▼ " + (tag ?? "未知错误") + " ▼▼▼▼▼▼▼▼▼▼▼▼▼▼ START");
    } else {
      print("END ▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲ " + (tag ?? "未知错误") + " ▲▲▲▲▲▲▲▲▲▲▲▲▲ END");
    }
  }

  // endregion

  // region model

  static logRsp(data, {String path, Map<String, dynamic> headers, Map<String, dynamic> qParams}) {
    if (_logOff()) {
      return;
    }

    logDivide("HTTP RQT:" + DateTime.now().toString(), true);

    log("path", path);
    log("headers", headers);
    log("params", qParams);
    log("rsp_data", data);

    logDivide("HTTP RQT:" + DateTime.now().toString(), false);
  }

  static logRstData<T extends YunBaseModel>(YunRspData<T> data) {
    if (_logOff()) {
      return;
    }

    logDivide("RSP_DATA:" + DateTime.now().toString(), true);

    log("data", data.toJson());

    logDivide("RSP_DATA:" + DateTime.now().toString(), false);
  }

  // endregion

  // region private

  static bool _logOff() {
    return YunConfig.logOn();
  }

  static bool _dtErr() {
    return YunConfig.detailsError();
  }

// endregion

}
