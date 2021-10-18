import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lj_ishop/util/theme_utils.dart';
import 'package:lj_ishop/util/toast_utils.dart';

/// 双击返回退出
class DoubleTapBackExitApp extends StatefulWidget {
  DoubleTapBackExitApp({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 2500),
  }) : super(key: key);

  final Widget child;
  final Duration duration;

  @override
  _DoubleTapBackExitAppState createState() => _DoubleTapBackExitAppState();
}

class _DoubleTapBackExitAppState extends State<DoubleTapBackExitApp> {
  DateTime? _lastTime;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: widget.child, onWillPop: _isExit);
  }

  Future<bool> _isExit() async {
    if (_lastTime == null ||
        DateTime.now().difference(_lastTime!) > widget.duration) {
      _lastTime = DateTime.now();
      Toast.show('再次点击退出应用');
      return Future.value(false);
    }
    Toast.cancelToast();

    /// 不推荐使用 `dart:io` 的 exit(0)
    await SystemNavigator.pop();
    return Future.value(true);
  }
}
