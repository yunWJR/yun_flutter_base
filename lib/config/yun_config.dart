//
// Created by yun on 2020-02-18.
//

import 'package:universal_platform/universal_platform.dart';

/// 主题模式：0-根据系统判断；1-全部 iOS；2-全部 Material
enum YunThemeMode { AUTO, IOS, MATERIAL }

/// 开启模式：根据环境决定；一直开启；一直关闭
enum YunOnMode { PROP_MODEL, ON, OFF }

class YunConfig {
  // region 基础配置

  /// prop 正式环境
  static bool isProp = true;

  // endregion

  // region 功能模式配置

  static YunOnMode logOnMode = YunOnMode.PROP_MODEL;

  static bool logOn() {
    if (logOnMode == YunOnMode.PROP_MODEL) {
      return !isProp;
    }

    return logOnMode == YunOnMode.ON;
  }

  static YunOnMode detailsErrorMode = YunOnMode.PROP_MODEL;

  static bool detailsError() {
    if (detailsErrorMode == YunOnMode.PROP_MODEL) {
      return !isProp;
    }

    return detailsErrorMode == YunOnMode.ON;
  }

  static YunThemeMode themeMode = YunThemeMode.IOS;

  /// 使用 iOS 模式
  static bool iOSMode() {
    if (themeMode == YunThemeMode.AUTO) {
      return UniversalPlatform.isIOS;
    }

    return themeMode == YunThemeMode.IOS;
  }

  /// 使用 MATERIAL 模式
  static bool materialMode() {
    if (themeMode == YunThemeMode.AUTO) {
      return UniversalPlatform.isAndroid;
    }

    return themeMode == YunThemeMode.MATERIAL;
  }

// endregion
}
