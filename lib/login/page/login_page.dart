import 'package:flutter/material.dart';
import 'package:lj_ishop/login/widgets/my_text_field.dart';
import 'package:lj_ishop/res/gaps.dart';
import 'package:lj_ishop/res/styles.dart';
import 'package:lj_ishop/widgets/my_app_bar.dart';
import 'package:lj_ishop/widgets/my_button.dart';
import 'package:lj_ishop/widgets/my_scroll_view.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  /// controller
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  bool _clickable = false;

  void _login() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        isBack: false,
        actionName: '验证码登录',
        onPressed: () {},
      ),
      body: MyScrollView(
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
            onTap: () {},
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
            onTap: () {},
          ),
        )
      ];
}
