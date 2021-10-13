import 'package:flutter/material.dart';
import 'package:lj_ishop/widgets/my_app_bar.dart';

class StoreAuditResultPage extends StatefulWidget {
  StoreAuditResultPage({Key? key}) : super(key: key);

  @override
  _StoreAuditResultPageState createState() => _StoreAuditResultPageState();
}

class _StoreAuditResultPageState extends State<StoreAuditResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        centerTitle: 'StoreAuditResultPage',
      ),
    );
  }
}
