import 'package:flutter/material.dart';
import 'package:lj_ishop/res/gaps.dart';
import 'package:lj_ishop/res/styles.dart';
import 'package:lj_ishop/routers/fluro_navigator.dart';
import 'package:lj_ishop/routers/routers.dart';
import 'package:lj_ishop/widgets/load_image.dart';
import 'package:lj_ishop/widgets/my_app_bar.dart';
import 'package:lj_ishop/widgets/my_button.dart';

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
        title: '审核结果',
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 0,
              width: double.infinity,
            ),
            Gaps.vGap50,
            LoadAssetImage(
              'store/icon_success',
              height: 80.0,
              width: 80.0,
            ),
            Gaps.vGap12,
            Text(
              '恭喜，店铺资料审核成功',
              style: TextStyles.textSize16,
            ),
            Gaps.vGap8,
            Text(
              '2021-02-21 15:20:10',
              style: Theme.of(context).textTheme.subtitle2,
            ),
            Gaps.vGap8,
            Text(
              '预计完成时间：02月28日',
              style: Theme.of(context).textTheme.subtitle2,
            ),
            Gaps.vGap24,
            MyButton(
              onPressed: () {
                NavigatorUtils.push(context, Routes.home, clearStack: true);
              },
              text: '进入',
            )
          ],
        ),
      ),
    );
  }
}
