//
// Created by yun on 2020-02-18.
//

/// 基础模块接口
abstract class YunBaseModel {
  Map<String, dynamic> toJson();

  /// 可以不实现，但必须实现 ModelFromMapFactory 转换定义
  fromJson(Map<String, dynamic> json) {}
}
