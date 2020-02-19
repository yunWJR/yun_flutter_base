//
// Created by yun on 2020-02-18.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yun_base/alert/yun_alert.dart';
import 'package:yun_base/model/yun_rst_data.dart';
import 'package:yun_base/page/yun_base_page.dart';

/// 页面状态：
enum PageStatus { none, loading, loaded, error }

abstract class YunPageBaseNotiModel with ChangeNotifier {
  /// 初始化时，加载数据
  bool _initLoadData = true;

  PageStatus _status;

  String loadText;

  BuildContext _context;

  YunPageNavigatorOn nagOn;

  YunPageBaseNotiModel(BuildContext context, {bool initLoadData = true}) {
    this._context = context;

    _initLoadData = initLoadData;

    if (_initLoadData) {
      loadData(context);
    }
  }

  // region abstract

  Future loadData([BuildContext context]);

  Future refreshData() => loadData();

  // endregion

  bool get isLoading => _status == PageStatus.loading;

  bool get loadingFailed => _status == PageStatus.error;

  void startLoading() {
    if (_status != PageStatus.loading) {
      _status = PageStatus.loading;

      notifyListeners();
    }
  }

  void finishLoading() {
    if (_status != PageStatus.loaded) {
      _status = PageStatus.loaded;

      notifyListeners();
    }
  }

  void receivedError() {
    _status = PageStatus.error;
    notifyListeners();
  }

  void showRspErr(YunRspData rst) {
    // 隐藏加载
    finishLoading();

    YunAlert.showRspErr(_context, rst, this);
  }

  void showErr(String error) {
    // 隐藏加载
    finishLoading();

    YunAlert.showErr(_context, error);
  }

  bool canLoadData() {
    // 网络判断-暂时不加
//    var connectivityResult = await (Connectivity().checkConnectivity());
//    connectivityResult == ConnectivityResult.none ? receivedError() : startLoading();

    bool can = !isLoading;

    // 可以可以加载，显示加载框
    if (can) {
      startLoading();
    }

    return can;
  }

  bool pageNagOn(String route, bool remove) {
    if (nagOn != null) {
      nagOn(route, remove);

      return true;
    }

    return false;
  }
}
