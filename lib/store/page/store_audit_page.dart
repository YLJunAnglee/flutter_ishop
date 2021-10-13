import 'package:flutter/material.dart';
import 'package:lj_ishop/widgets/my_app_bar.dart';

class StoreAuditPage extends StatefulWidget {
  StoreAuditPage({Key? key}) : super(key: key);

  @override
  _StoreAuditPageState createState() => _StoreAuditPageState();
}

class _StoreAuditPageState extends State<StoreAuditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        centerTitle: 'StoreAuditPage',
      ),
    );
  }
}
