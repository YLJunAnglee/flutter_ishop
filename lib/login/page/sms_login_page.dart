import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lj_ishop/login/login_router.dart';
import 'package:lj_ishop/login/widgets/my_text_field.dart';
import 'package:lj_ishop/res/dimens.dart';
import 'package:lj_ishop/res/gaps.dart';
import 'package:lj_ishop/res/styles.dart';
import 'package:lj_ishop/routers/fluro_navigator.dart';
import 'package:lj_ishop/util/change_notifier_manager.dart';
import 'package:lj_ishop/util/other_utils.dart';
import 'package:lj_ishop/util/toast_utils.dart';
import 'package:lj_ishop/widgets/my_app_bar.dart';
import 'package:lj_ishop/widgets/my_button.dart';
import 'package:lj_ishop/widgets/my_scroll_view.dart';

/// 验证码登录
class SMSLoginPage extends StatefulWidget {
  SMSLoginPage({Key? key}) : super(key: key);

  @override
  _SMSLoginPageState createState() => _SMSLoginPageState();
}

class _SMSLoginPageState extends State<SMSLoginPage>
    with ChangeNotifierMixin<SMSLoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _vCodeController = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  bool _clickable = false;

  @override
  Map<ChangeNotifier?, List<VoidCallback>?>? changeNotifier() {
    final List<VoidCallback> callbacks = <VoidCallback>[_verify];
    return <ChangeNotifier, List<VoidCallback>?>{
      _phoneController: callbacks,
      _vCodeController: callbacks,
      _nodeText1: null,
      _nodeText2: null,
    };
  }

  void _verify() {
    final String name = _phoneController.text;
    final String vCode = _vCodeController.text;
    bool clickable = true;
    if (name.isEmpty || name.length < 11) {
      clickable = false;
    }
    if (vCode.isEmpty || vCode.length < 6) {
      clickable = false;
    }
    if (clickable != _clickable) {
      setState(() {
        _clickable = clickable;
      });
    }
  }

  void _login() {
    Toast.show('去登录......');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: MyScrollView(
        children: _buildBody(),
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
        keyboardConfig: Utils.getKeyboardActionsConfig(
            context, <FocusNode>[_nodeText1, _nodeText2]),
      ),
    );
  }

  List<Widget> _buildBody() {
    return <Widget>[
      Text(
        '验证码登录',
        style: TextStyles.textBold26,
      ),
      Gaps.vGap16,
      MyTextField(
        controller: _phoneController,
        focusNode: _nodeText1,
        maxLength: 11,
        keyboardType: TextInputType.phone,
        hintText: '请输入手机号',
      ),
      Gaps.vGap8,
      MyTextField(
        controller: _vCodeController,
        focusNode: _nodeText2,
        maxLength: 6,
        keyboardType: TextInputType.number,
        hintText: '请输入验证码',
        getVCode: () {
          Toast.show('获取验证码');
          return Future<bool>.value(true);
        },
      ),
      Gaps.vGap8,
      Container(
        alignment: Alignment.centerLeft,
        child: RichText(
            text: TextSpan(
          text: '提示：未注册账号的手机号，请先',
          style: Theme.of(context)
              .textTheme
              .subtitle2
              ?.copyWith(fontSize: Dimens.font_sp14),
          children: <TextSpan>[
            TextSpan(
                text: '注册',
                style: TextStyle(color: Theme.of(context).errorColor),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    NavigatorUtils.push(context, LoginRouter.registerPage);
                  }),
            TextSpan(text: Utils.getCurrLocale() == 'zh' ? '。' : '.'),
          ],
        )),
      ),
      Gaps.vGap24,
      MyButton(
        key: const Key('login'),
        onPressed: _clickable ? _login : null,
        text: '登录',
      ),
      Container(
        height: 40.0,
        alignment: Alignment.centerRight,
        child: GestureDetector(
          child: Text(
            '忘记密码',
            style: Theme.of(context).textTheme.subtitle2,
          ),
          onTap: () =>
              NavigatorUtils.push(context, LoginRouter.resetPasswordPage),
        ),
      ),
    ];
  }
}
