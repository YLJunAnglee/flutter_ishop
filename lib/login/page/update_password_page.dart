import 'package:flutter/material.dart';
import 'package:lj_ishop/widgets/my_app_bar.dart';

class UpdatePasswordPage extends StatefulWidget {
  UpdatePasswordPage({Key? key}) : super(key: key);

  @override
  _UpdatePasswordPageState createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        centerTitle: 'UpdatePasswordPage',
      ),
    );
  }
}
