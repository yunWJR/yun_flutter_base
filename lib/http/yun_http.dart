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

  /// rspObj
  static bool rspObj = true;

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

  YunRspData _rstData;
  bool _dIsList = false;

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
  Future<YunRspData<D>> post<D extends YunBaseModel>(
      D d, String path, dynamic data, Map<String, dynamic> queryParameters,
      {bool dIsList = false, YunRspDataWrapperType wrapperType}) async {
    return postOrg(d, path, data: data, queryParameters: queryParameters, dIsList: dIsList, wrapperType: wrapperType);
  }

  /// 原始 post
  Future<YunRspData<D>> postOrg<D extends YunBaseModel>(D d, String path,
      {dynamic data,
      Map<String, dynamic> queryParameters,
      Options options,
      CancelToken cancelToken,
      ProgressCallback onSendProgress,
      ProgressCallback onReceiveProgress,
      bool dIsList = false,
      YunRspDataWrapperType wrapperType}) async {
    Response<Map<String, dynamic>> rsp;
    _dIsList = dIsList;

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

    return _handleRsp(d, rsp, dIsList, wrapperType);
  }

  /// 封装 get
  Future<YunRspData<D>> get<D extends YunBaseModel>(D d, String path, Map<String, dynamic> queryParameters,
      {bool dIsList = false, YunRspDataWrapperType wrapperType}) async {
    return getOrg(d, path, queryParameters: queryParameters, dIsList: dIsList, wrapperType: wrapperType);
  }

  /// 原始 get
  Future<YunRspData<D>> getOrg<D extends YunBaseModel>(D d, String path,
      {Map<String, dynamic> queryParameters,
      Options options,
      CancelToken cancelToken,
      ProgressCallback onReceiveProgress,
      bool dIsList = false,
      YunRspDataWrapperType wrapperType}) async {
    Response<Map<String, dynamic>> rsp;
    _dIsList = dIsList;

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

    return _handleRsp(d, rsp, dIsList, wrapperType);
  }

  /// 封装 delete
  Future<YunRspData<D>> delete<D extends YunBaseModel>(D d, String path,
      {dynamic data,
      Map<String, dynamic> queryParameters,
      bool dIsList = false,
      YunRspDataWrapperType wrapperType}) async {
    return deleteOrg(d, path, data: data, queryParameters: queryParameters, dIsList: dIsList, wrapperType: wrapperType);
  }

  /// 原始 delete
  Future<YunRspData<D>> deleteOrg<D extends YunBaseModel>(D d, String path,
      {dynamic data,
      Map<String, dynamic> queryParameters,
      Options options,
      CancelToken cancelToken,
      bool dIsList = false,
      YunRspDataWrapperType wrapperType}) async {
    Response<Map<String, dynamic>> rsp;
    _dIsList = dIsList;

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

    return _handleRsp(d, rsp, dIsList, wrapperType);
  }

  /// 封装 put
  Future<YunRspData<D>> put<D extends YunBaseModel>(D d, String path,
      {dynamic data,
      Map<String, dynamic> queryParameters,
      bool dIsList = false,
      YunRspDataWrapperType wrapperType}) async {
    return putOrg(d, path, data: data, queryParameters: queryParameters, dIsList: dIsList, wrapperType: wrapperType);
  }

  /// 原始 put
  Future<YunRspData<D>> putOrg<D extends YunBaseModel>(D d, String path,
      {dynamic data,
      Map<String, dynamic> queryParameters,
      Options options,
      CancelToken cancelToken,
      bool dIsList = false,
      YunRspDataWrapperType wrapperType}) async {
    Response<Map<String, dynamic>> rsp;
    _dIsList = dIsList;

    try {
      rsp = await dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      return _handleRspError(e, path, queryParameters);
    }

    return _handleRsp(d, rsp, dIsList, wrapperType);
  }

  YunRspData<D> _handleRspError<D extends YunBaseModel>(e, String path, Map<String, dynamic> queryParameters) {
    // 日志 todo 更多详情
    YunLog.logRsp(e.toString(), path: path, headers: null, qParams: queryParameters);

    _rstData = YunRspData<D>.fromRspError(e);

    showRspError(_rstData);

    return handleState ? null : _rstData;
  }

  YunRspData<D> _handleRsp<D extends YunBaseModel>(
      D d, Response<Map<String, dynamic>> rsp, bool dIsList, YunRspDataWrapperType wrapperType) {
    if (rsp != null) {
      YunLog.logRspObj(rsp);
    }

    YunRspData<D> vo = dIsList
        ? YunRspData<D>.fromListJson(d, rsp.data, wrapperType)
        : YunRspData<D>.fromJson(d, rsp.data, wrapperType);
    _rstData = vo;

    if (_rstData.isSuc()) {
      hideLoading();
      return rspObj ? _rstData : rspData();
    }

    showRspError(_rstData);

    return handleState ? null : _rstData;
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

  dynamic rspData() {
    return _dIsList ? _rstData?.dataList : _rstData?.data;
  }

// endregion
}
