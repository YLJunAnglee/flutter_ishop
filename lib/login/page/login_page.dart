import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:lj_ishop/login/login_router.dart';
import 'package:lj_ishop/login/widgets/my_text_field.dart';
import 'package:lj_ishop/res/constant.dart';
import 'package:lj_ishop/res/gaps.dart';
import 'package:lj_ishop/res/styles.dart';
import 'package:lj_ishop/routers/fluro_navigator.dart';
import 'package:lj_ishop/store/store_router.dart';
import 'package:lj_ishop/util/change_notifier_manager.dart';
import 'package:lj_ishop/widgets/my_app_bar.dart';
import 'package:lj_ishop/widgets/my_button.dart';
import 'package:lj_ishop/widgets/my_scroll_view.dart';
import 'package:lj_ishop/util/other_utils.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with ChangeNotifierMixin<LoginPage> {
  /// controller
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  bool _clickable = false;

  /// 添加状态变化监控
  @override
  Map<ChangeNotifier?, List<VoidCallback>?>? changeNotifier() {
    final List<VoidCallback> callbacks = <VoidCallback>[_verify];
    return <ChangeNotifier, List<VoidCallback>?>{
      _nameController: callbacks,
      _passwordController: callbacks,
      _nodeText1: null,
      _nodeText2: null,
    };
  }

  void _login() {
    SpUtil.putString(Constant.phone, _nameController.text);
    NavigatorUtils.push(context, StoreRouter.auditPage);
  }

  void _verify() {
    final String name = _nameController.text;
    final String password = _passwordController.text;
    bool clickable = true;
    if (name.isEmpty || name.length < 11) {
      clickable = false;
    }
    if (password.isEmpty || password.length < 6) {
      clickable = false;
    }

    /// 状态不一样再刷新，避免不必要的setState
    if (clickable != _clickable) {
      setState(() {
        _clickable = clickable;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {});
    _nameController.text = SpUtil.getString(Constant.phone).nullSafe;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        isBack: false,
        actionName: '验证码登录',
        onPressed: () {
          NavigatorUtils.push(context, LoginRouter.smsLoginPage);
        },
      ),
      body: MyScrollView(
        keyboardConfig: Utils.getKeyboardActionsConfig(
            context, <FocusNode>[_nodeText1, _nodeText2]),
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
        children: _buildBody,
      ),
    );
  }

  List<Widget> get _buildBody => <Widget>[
        Text('密码登录', style: TextStyles.textBold26),
        Gaps.vGap16,
        MyTextField(
          key: const Key('phone'),
          controller: _nameController,
          focusNode: _nodeText1,
          maxLength: 11,
          keyboardType: TextInputType.phone,
          hintText: '请输入账号',
        ),
        Gaps.vGap8,
        MyTextField(
          key: const Key('password'),
          controller: _passwordController,
          keyName: 'password',
          focusNode: _nodeText2,
          isInputPwd: true,
          keyboardType: TextInputType.visiblePassword,
          maxLength: 16,
          hintText: '请输入密码',
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
              key: const Key('forgotPassword'),
              style: Theme.of(context).textTheme.subtitle2,
            ),
            onTap: () {
              NavigatorUtils.push(context, LoginRouter.resetPasswordPage);
            },
          ),
        ),
        Gaps.vGap16,
        Container(
          alignment: Alignment.center,
          child: GestureDetector(
            child: Text(
              '还没账号？快去注册',
              key: const Key('noAccountRegister'),
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            onTap: () {
              NavigatorUtils.push(context, LoginRouter.registerPage);
            },
          ),
        )
      ];
}
