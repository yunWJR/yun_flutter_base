//
// Created by yun on 2020-02-18.
//

import 'package:yun_base/model/yun_base_model.dart';

/// 基础 map model
class YunBaseObjModel implements YunBaseModel {
  dynamic json;

  YunBaseObjModel({this.json});

  factory YunBaseObjModel.fromJson(dynamic json) {
    return YunBaseObjModel(json: json);
  }

  YunBaseObjModel fromJson(dynamic json) {
    return YunBaseObjModel(
      json: json,
    );
  }

  Map<String, dynamic> toJson() {
    return json;
  }
}
