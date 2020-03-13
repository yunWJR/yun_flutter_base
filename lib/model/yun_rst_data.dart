//
// Created by yun on 2020-02-18.
//

import 'package:yun_base/config/yun_config.dart';
import 'package:yun_base/model/yun_base_model.dart';
import 'package:yun_base/util/yun_value.dart';

import 'yun_model_convert.dart';

/// 返回结果包装类型：
/// Base:rsp即数据
/// Wrapper:包装数据
enum YunRspDataWrapperType { Base, Wrapper }

class YunRstDataDefine {
  static YunRspDataWrapperType wrapperType = YunRspDataWrapperType.Wrapper;

  static final codeName = 'code';
  static final dataName = 'data';
  static final msgName = 'errorMsg';

  static final int sucCode = 200;
  static final int commonErrorCode = -1;
}

class YunRspData<T extends YunBaseModel> {
  /// 数据类型
  YunRspDataWrapperType type;

  int code;
  dynamic orgData; // Map<String, dynamic> 或者 list
  String errorMsg;

  T data;
  List<T> dataList;

  YunRspData({this.type: YunRspDataWrapperType.Base});

  static YunRspDataWrapperType getWrapperType(YunRspDataWrapperType wrapperType) {
    YunRspDataWrapperType type = YunRstDataDefine.wrapperType;
    if (wrapperType != null) {
      type = wrapperType;
    }

    if (type == null) {
      throw "转换类型错误";
    }

    return type;
  }

  factory YunRspData.fromJson(T d, Map<String, dynamic> map, YunRspDataWrapperType wrapperType) {
    if (getWrapperType(wrapperType) == YunRspDataWrapperType.Base) {
      return YunRspData.fromJsonByBaseModel(d, map);
    } else {
      return YunRspData.fromJsonByRsp(d, map);
    }
  }

  factory YunRspData.fromListJson(T d, Map<String, dynamic> map, YunRspDataWrapperType wrapperType) {
    if (getWrapperType(wrapperType) == YunRspDataWrapperType.Base) {
      return YunRspData.fromListJsonByBaseModel(d, map);
    } else {
      return YunRspData.fromListJsonByRsp(d, map);
    }
  }

  factory YunRspData.fromJsonByRsp(T d, Map<String, dynamic> map) {
    var item = new YunRspData<T>(type: YunRspDataWrapperType.Base);

    try {
      if (map[YunRstDataDefine.codeName] == null) {
        return item._updateError(YunRstDataDefine.commonErrorCode, "数据格式不正确");
      }

      item.code = map[YunRstDataDefine.codeName];

      // 错误
      if (item.code != YunRstDataDefine.sucCode) {
        item.errorMsg = map[YunRstDataDefine.msgName];
        if (YunValue.isNullOrEmpty(item.errorMsg)) {
          item.errorMsg = '未知错误';
        }

        return item;
      }

      // 成功-解析 data
      item.orgData = map[YunRstDataDefine.dataName];

      item.data = YunModelConvert.modelFromMap(item.orgData);
    } catch (e) {
      return item._updateError(YunRstDataDefine.commonErrorCode, e.toString(), orgData: e);
    }

    return item;
  }

  factory YunRspData.fromJsonByBaseModel(T d, Map<String, dynamic> map) {
    var item = new YunRspData<T>(type: YunRspDataWrapperType.Base);

    try {
      item.data = YunModelConvert.modelFromMap(map);
      item.code = YunRstDataDefine.sucCode;
    } catch (e) {
      return item._updateError(YunRstDataDefine.commonErrorCode, e.toString(), orgData: e);
    }

    return item;
  }

  factory YunRspData.fromListJsonByRsp(T d, Map<String, dynamic> map) {
    var item = new YunRspData<T>(type: YunRspDataWrapperType.Base);

    try {
      if (map[YunRstDataDefine.codeName] == null) {
        return item._updateError(YunRstDataDefine.commonErrorCode, "数据格式不正确");
      }

      item.code = map[YunRstDataDefine.codeName];

      // 错误
      if (item.code != YunRstDataDefine.sucCode) {
        item.errorMsg = map[YunRstDataDefine.msgName];
        if (YunValue.isNullOrEmpty(item.errorMsg)) {
          item.errorMsg = '未知错误';
        }

        return item;
      }

      // 成功-解析 data
      List list = map[YunRstDataDefine.dataName];

      item.orgData = list;

      item.dataList = list.map<T>((e) => YunModelConvert.modelFromMap(e)).toList();
    } catch (e) {
      return item._updateError(YunRstDataDefine.commonErrorCode, e.toString(), orgData: e);
    }

    return item;
  }

  factory YunRspData.fromListJsonByBaseModel(T d, Map<String, dynamic> map) {
    var item = new YunRspData<T>(type: YunRspDataWrapperType.Base);

    try {
      List list = map as List;
      List<T> vo = list.map<T>((e) => YunModelConvert.modelFromMap(e)).toList();

      item.dataList = vo;
      item.code = YunRstDataDefine.sucCode;
    } catch (e) {
      return item._updateError(YunRstDataDefine.commonErrorCode, e.toString(), orgData: e);
    }

    return item;
  }

  factory YunRspData.fromRspError(e) {
    var item = new YunRspData<T>(type: YunRspDataWrapperType.Wrapper);
    item.orgData = e;

    if (e.response?.statusCode == 401) {
      item.code = 401;
      item.errorMsg = "登录已经过期，请重新登录";
    } else {
      item.code = -1;
      item.errorMsg = e.toString();
    }

    return item;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['errorMsg'] = this.errorMsg;
    data['data'] = this.data?.toJson(); // todo ?. 检查

    // 自定义字段
    data['type'] = this.type;
    data['orgData'] = this.orgData;

    return data;
  }

  bool isSuc() {
    return code == YunRstDataDefine.sucCode;
  }

  String getErrMsg() {
    if (YunConfig.detailsError()) {
      String typeStr = type == YunRspDataWrapperType.Base ? "业务错误" : "网络错误";

      String err = "${typeStr}:${errorMsg}.\n 源数据：${orgData}";
      return err;
    } else {
      return errorMsg;
    }
  }

  YunRspData<T> _updateError(int code, String errorMsg, {orgData}) {
    this.code = code;
    this.errorMsg = errorMsg;
    this.data = null;
    this.orgData = orgData;

    return this;
  }
}
