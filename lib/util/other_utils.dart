import 'dart:ui';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:lj_ishop/res/constant.dart';
import 'package:lj_ishop/util/theme_utils.dart';
import 'package:lj_ishop/util/toast_utils.dart';
import 'package:url_launcher/url_launcher.dart';

/// String 空安全处理
extension StringExtension on String? {
  String get nullSafe => this ?? '';
}

class Utils {
  /// 打开链接
  static Future<void> launchWebURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Toast.show('打开链接失败！！！');
    }
  }

  /// 调起拨号页
  static Future<void> launchTelURL(String phone) async {
    final String url = 'tel:$phone';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Toast.show('拨号失败！');
    }
  }

  static String formatPrice(String price,
      {MoneyFormat format = MoneyFormat.END_INTEGER}) {
    return MoneyUtil.changeYWithUnit(
        NumUtil.getDoubleByValueStr(price) ?? 0, MoneyUnit.YUAN,
        format: format);
  }

  static KeyboardActionsConfig getKeyboardActionsConfig(
      BuildContext context, List<FocusNode> list) {
    return KeyboardActionsConfig(
      keyboardBarColor: ThemeUtils.getKeyboardActionsColor(context),
      nextFocus: true,
      actions: List.generate(
          list.length,
          (i) => KeyboardActionsItem(
                focusNode: list[i],
                toolbarButtons: [
                  (node) {
                    return GestureDetector(
                      onTap: () => node.unfocus(),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Text(getCurrLocale() == 'zh' ? '关闭' : 'Close'),
                      ),
                    );
                  },
                ],
              )),
    );
  }

  static String? getCurrLocale() {
    final String locale = SpUtil.getString(Constant.locale)!;
    if (locale == '') {
      return window.locale.languageCode;
    }
    return locale;
  }
}
