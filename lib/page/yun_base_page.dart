//
// Created by yun on 2020-02-18.
//

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yun_base/model/yun_page_base_noti_model.dart';

typedef pageConfig = YunBasePageConfig Function();

typedef YunPageNavigatorOn = Function(String route, bool remove);

class YunBasePageConfig {
  static YunBasePageConfig _defConfig = new YunBasePageConfig();

  static YunBasePageConfig get defConfig => _defConfig;

  static set defConfig(YunBasePageConfig value) {
    if (value == null) {
      return;
    }

    _defConfig = value;
  }

  Color loadBgColor = Color.fromRGBO(100, 100, 100, 0.5);
  Widget loadStatusWidget = const CircularProgressIndicator();
}

class YunBasePage<T extends YunPageBaseNotiModel> extends StatelessWidget {
  final Widget body;

  T model;

  BuildContext context1;

  YunBasePageConfig config;

  YunBasePage({@required this.body, @required this.model, this.config}) {
    if (config == null) {
      config = YunBasePageConfig.defConfig;
    }
  }

  factory YunBasePage.page({
    @required Widget body,
    @required T model,
    YunBasePageConfig config,
  }) {
    return YunBasePage(
      body: body,
      model: model,
      config: config,
    );
  }

  @override
  Widget build(BuildContext context) {
    // 主动监听 model 改变
//    model = Provider.of<T>(context, listen: true);

    context1 = context;

    List<Widget> widgets = new List();

    // 载入 body
    widgets.add(this.body);

    // 载入 加载框
    widgets.add(Visibility(
      visible: model == null ? false : model.isLoading,
      child: loadingWidget(model),
    ));

    // 注册 nagOn
    model.nagOn = (String route, bool remove) {
      _nagOn(route, remove);
    };

    // TODO 载入其他控件

    return new Stack(children: widgets);
  }

  void _nagOn(String route, bool remove) async {
    await Future.delayed(Duration.zero);

    if (remove != null && remove) {
      Navigator.pushNamedAndRemoveUntil(context1, route, (Route<dynamic> route) => false);
    } else {
      Navigator.pushNamed(context1, route);
    }
  }

  Widget loadingWidget(T model) {
    return new Container(
//          width: MediaQuery.of(context).size.width,
//          height: MediaQuery.of(context).size.height,
      color: config.loadBgColor,
      child: Center(
        child: config.loadStatusWidget,
      ),
    );
  }
}
