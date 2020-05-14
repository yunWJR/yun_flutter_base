//
// Created by yun on 2020-02-18.
//

import 'package:yun_base/model/yun_base_model.dart';

/// 基础 map model
class YunBaseMapModel implements YunBaseModel {
  Map<String, dynamic> json;

  YunBaseMapModel({this.json});

  factory YunBaseMapModel.fromJson(Map<String, dynamic> json) {
    return YunBaseMapModel(json: json);
  }

  YunBaseMapModel fromJson(Map<String, dynamic> json) {
    return YunBaseMapModel(
      json: json,
    );
  }

  Map<String, dynamic> toJson() {
    return json;
  }
}
