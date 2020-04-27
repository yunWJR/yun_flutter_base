//
// Created by yun on 2020/3/13.
//

import 'yun_base_model.dart';

/// 数据类型：
/// BaseModel转换：对象实现YunBaseModel接口
/// Factory转换：ModelFromMapFactory定义转换
/// AUTO: 自动识别采用哪种，首先尝试BaseModel，再尝试Factory
enum YunModelConvertType { BaseModel, Factory, AUTO }

/// 工厂转换模式
typedef T ModelFromMapFactory<T extends YunBaseModel>(Map<String, dynamic> json);

class YunModelConvertDefine {
  /// 默认 AUTO
  static YunModelConvertType type = YunModelConvertType.AUTO;

  /// Factory需要实现
  static ModelFromMapFactory factory;

  static YunModelConvertType firstType = YunModelConvertType.Factory;
}

class YunModelConvert {
  static T modelFromMap<T extends YunBaseModel>(Map<String, dynamic> map, {T d, YunModelConvertType type}) {
    YunModelConvertType cType = YunModelConvertDefine.type;
    if (type != null) {
      cType = type;
    }

    if (cType == null) {
      throw "YunModelConvert：请指定转换模式";
    }

    if (cType == YunModelConvertType.BaseModel && d == null) {
      throw "YunModelConvert：BaseModel模式下，参数d不能为null";
    }

    /// BaseModel
    if (cType == YunModelConvertType.BaseModel) {
      return d.fromJson(map) as T;
    }

    /// Factory
    if (cType == YunModelConvertType.Factory) {
      return modelByFactory(map, true);
    }

    /// AUTO
    if (cType == YunModelConvertType.AUTO) {
      if (YunModelConvertDefine.firstType == YunModelConvertType.Factory) {
        var rst = modelByFactory(map, false);
        if (rst == null) {
          if (d != null) {
            return d.fromJson(map) as T;
          }
        }
      } else {
        if (d != null) {
          return d.fromJson(map) as T;
        }

        return modelByFactory(map, true);
      }
    }

    throw "YunModelConvert：转换类型不正确";
  }

  static T modelByFactory<T>(Map<String, dynamic> map, bool err) {
    T rst;
    if (YunModelConvertDefine.factory != null) {
      rst = YunModelConvertDefine.factory(map) as T;
    }

    if (rst == null && err) {
      // 异常
      throw "对象${T.toString()} 转换失败";
    }

    return rst;
  }
}
