//
// Created by yun on 2020-02-18.
//

import 'package:dio/dio.dart';
import 'package:yun_base/log/yun_log.dart';
import 'package:yun_base/model/yun_base_model.dart';
import 'package:yun_base/model/yun_page_base_noti_model.dart';
import 'package:yun_base/model/yun_rst_data.dart';

class YunHttp<N extends YunPageBaseNotiModel> {
  // region config

  /// base url
  static String baseUrl;

  /// 返回数据是否为YunBaseModel。
  /// true:rsp数据为BaseModel; false：rsp数据为YunRspData；
  /// 全句设置；每个方法可以单独覆盖
  static bool rspIsYunBaseModel = false;

  /// 基于N（PageBaseNotiModel）：主动处理状态和信息显示
  static bool handleState = true;

  /// 默认header；可以通过方法添加
  static Map<String, dynamic> defHeaders;

  static addHeader(String key, dynamic value) {
    if (key == null) {
      return;
    }

    if (value == null) {
      removeHeader(key);
      return defHeaders;
    }

    if (defHeaders == null) {
      defHeaders = {};
    }

    defHeaders[key] = value;

    return defHeaders;
  }

  static removeHeader(String key) {
    if (key == null || defHeaders == null) {
      return;
    }

    return defHeaders.remove(key);
  }

  // endregion

  Dio dio;
  N _noti;

  YunRspData rstData;

  YunHttp(N noti) {
    this._noti = noti;

    if (defHeaders == null) {
      defHeaders = {};
    }

    dio = new Dio(BaseOptions(
      baseUrl: baseUrl,
      headers: defHeaders,
    ));
  }

  // region rqt

  /// 封装 post
  Future post<D extends YunBaseModel>(D d, String path, dynamic data, Map<String, dynamic> queryParameters,
      {bool dIsList = false, bool rspIsYunBaseModel}) async {
    return postOrg(d, path,
        data: data, queryParameters: queryParameters, dIsList: dIsList, rspIsYunBaseModel: rspIsYunBaseModel);
  }

  /// 原始 post
  Future postOrg<D extends YunBaseModel>(D d, String path,
      {dynamic data,
      Map<String, dynamic> queryParameters,
      Options options,
      CancelToken cancelToken,
      ProgressCallback onSendProgress,
      ProgressCallback onReceiveProgress,
      bool dIsList = false,
      bool rspIsYunBaseModel}) async {
    Response<Map<String, dynamic>> rsp;

    try {
      rsp = await dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } catch (e) {
      return _handleRspError(e, path, queryParameters);
    }

    return _handleRsp(d, rsp, dIsList, rspIsYunBaseModel);
  }

  /// 封装 get
  Future get<D extends YunBaseModel>(D d, String path, Map<String, dynamic> queryParameters,
      {bool dIsList = false, bool rspIsYunBaseModel}) async {
    return getOrg(d, path, queryParameters: queryParameters, dIsList: dIsList, rspIsYunBaseModel: rspIsYunBaseModel);
  }

  /// 原始 get
  Future getOrg<D extends YunBaseModel>(D d, String path,
      {Map<String, dynamic> queryParameters,
      Options options,
      CancelToken cancelToken,
      ProgressCallback onReceiveProgress,
      bool dIsList = false,
      bool rspIsYunBaseModel}) async {
    Response<Map<String, dynamic>> rsp;

    try {
      rsp = await dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    } catch (e) {
      return _handleRspError(e, path, queryParameters);
    }

    return _handleRsp(d, rsp, dIsList, rspIsYunBaseModel);
  }

  /// 封装 delete
  Future delete<D extends YunBaseModel>(D d, String path,
      {dynamic data, Map<String, dynamic> queryParameters, bool dIsList = false, bool rspIsYunBaseModel}) async {
    return deleteOrg(d, path,
        data: data, queryParameters: queryParameters, dIsList: dIsList, rspIsYunBaseModel: rspIsYunBaseModel);
  }

  /// 原始 delete
  Future deleteOrg<D extends YunBaseModel>(D d, String path,
      {dynamic data,
      Map<String, dynamic> queryParameters,
      Options options,
      CancelToken cancelToken,
      bool dIsList = false,
      bool rspIsYunBaseModel}) async {
    Response<Map<String, dynamic>> rsp;

    try {
      rsp = await dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      return _handleRspError(e, path, queryParameters);
    }

    return _handleRsp(d, rsp, dIsList, rspIsYunBaseModel);
  }

  dynamic _handleRspError(e, String path, Map<String, dynamic> queryParameters) {
    // 日志
    YunLog.logRsp(e.toString(), path: path, headers: null, qParams: queryParameters);

    rstData = YunRspData.fromRspError(e);

    showRspError(rstData);

    return handleState ? null : rstData;
  }

  dynamic _handleRsp<D extends YunBaseModel>(
      D d, Response<Map<String, dynamic>> rsp, bool dIsList, bool rspIsYunBaseModel) {
    if (rsp != null) {
      YunLog.logRsp(rsp.data,
          path: rsp.request.path, headers: rsp.request.headers, qParams: rsp.request.queryParameters);
    }

    YunRspData<D> vo = dIsList
        ? YunRspData.fromListJson(d, rsp.data, rspIsYunBaseModel ?? YunHttp.rspIsYunBaseModel)
        : YunRspData.fromJson(d, rsp.data, rspIsYunBaseModel ?? YunHttp.rspIsYunBaseModel);
    rstData = vo;

    if (rstData.isSuc()) {
      hideLoading();
      return dIsList ? rstData.dataList : rstData.data;
    }

    showRspError(rstData);

    return handleState ? null : rstData;
  }

  // endregion

  // region handleState

  void showRspError(YunRspData rst) {
    if (!handleState) {
      return;
    }

    YunLog.logRstData(rst);

    if (_noti != null) {
      _noti.showRspErr(rst);
    }
  }

  void showError(String err) {
    if (!handleState) {
      return;
    }

    hideLoading();

    if (_noti != null) {
      _noti.showErr(err);
    }
  }

  void hideLoading() {
    if (!handleState) {
      return;
    }

    if (_noti != null) {
      _noti.finishLoading();
    }
  }

// endregion

}
