//
// Created by yun on 2020-02-18.
//

/// 基础模块接口
abstract class YunBaseModel {
  Map<String, dynamic> toJson();

  fromJson(Map<String, dynamic> json);
}
