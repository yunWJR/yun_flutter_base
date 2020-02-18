//
// Created by yun on 2020-02-18.
//

import 'dart:io';

/// 主题模式：0-根据系统判断；1-全部 iOS；2-全部 Material
enum ThemeMode { AUTO, IOS, MATERIAL }

/// 开启模式：根据环境决定；一直开启；一直关闭
enum OnMode { PROP_MODEL, ON, OFF }

class YunConfig {
  // region 基础配置

  /// prop 正式环境
  static bool isProp = true;

  // endregion

  // region 功能模式配置

  static OnMode logOnMode = OnMode.PROP_MODEL;

  static bool logOn() {
    if (logOnMode == OnMode.PROP_MODEL) {
      return !isProp;
    }

    return logOnMode == OnMode.ON;
  }

  static OnMode detailsErrorMode = OnMode.PROP_MODEL;

  static bool detailsError() {
    if (detailsErrorMode == OnMode.PROP_MODEL) {
      return !isProp;
    }

    return detailsErrorMode == OnMode.ON;
  }

  static ThemeMode themeMode = ThemeMode.IOS;

  /// 使用 iOS 模式
  static bool iOSMode() {
    if (themeMode == ThemeMode.AUTO) {
      return Platform.isIOS;
    }

    return themeMode == ThemeMode.IOS;
  }

  /// 使用 MATERIAL 模式
  static bool materialMode() {
    if (themeMode == ThemeMode.AUTO) {
      return Platform.isAndroid;
    }

    return themeMode == ThemeMode.MATERIAL;
  }

// endregion
}
