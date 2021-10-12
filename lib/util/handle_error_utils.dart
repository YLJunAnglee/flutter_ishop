import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lj_ishop/res/constant.dart';

void handleError(void body) {
  /// 重写Flutter异常回调 Flutter.onError
  FlutterError.onError = (FlutterErrorDetails details) {
    if (!Constant.inProduction) {
      /// debug时，直接将异常信息打印
      FlutterError.dumpErrorToConsole(details);
    } else {
      /// release时，将异常交由zone统一处理
      Zone.current.handleUncaughtError(details.exception, details.stack!);
    }
  };
}
