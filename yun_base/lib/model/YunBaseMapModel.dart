//
// Created by yun on 2020-02-18.
//

import 'YunBaseModel.dart';

/// 基础 map model
class YunBaseMapModel implements YunBaseModel {
  Map<String, dynamic> json;

  YunBaseMapModel({this.json});

  YunBaseMapModel fromJson(Map<String, dynamic> json) {
    return YunBaseMapModel(
      json: json,
    );
  }

  Map<String, dynamic> toJson() {
    return json;
  }
}
