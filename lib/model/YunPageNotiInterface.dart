//
// Created by yun on 2020-02-18.
//

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'YunPageBaseNotiModel.dart';

abstract class YunPageNotiInterface<T extends YunPageBaseNotiModel> {
  // todo 不起作用
  T pT([BuildContext context, bool listen = false]) {
    return Provider.of<T>(context, listen: listen);
  }
}
