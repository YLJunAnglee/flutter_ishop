import 'package:flutter/material.dart';
import 'package:lj_ishop/widgets/my_app_bar.dart';

class SMSLoginPage extends StatefulWidget {
  SMSLoginPage({Key? key}) : super(key: key);

  @override
  _SMSLoginPageState createState() => _SMSLoginPageState();
}

class _SMSLoginPageState extends State<SMSLoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        centerTitle: 'SMSLoginPage',
      ),
    );
  }
}
