//
// Created by yun on 2020-02-18.
//

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:yun_base/model/yun_page_base_noti_model.dart';

abstract class YunPageNotiInterface<T extends YunPageBaseNotiModel> {
  // todo 不起作用
  T pT([BuildContext context, bool listen = false]) {
    return Provider.of<T>(context, listen: listen);
  }
}
