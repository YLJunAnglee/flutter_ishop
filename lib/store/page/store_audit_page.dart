import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_2d_amap/flutter_2d_amap.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';
import 'package:lj_ishop/res/dimens.dart';
import 'package:lj_ishop/res/gaps.dart';
import 'package:lj_ishop/res/styles.dart';
import 'package:lj_ishop/routers/fluro_navigator.dart';
import 'package:lj_ishop/shop/shop_router.dart';
import 'package:lj_ishop/store/store_router.dart';
import 'package:lj_ishop/util/other_utils.dart';
import 'package:lj_ishop/util/theme_utils.dart';
import 'package:lj_ishop/widgets/my_app_bar.dart';
import 'package:lj_ishop/widgets/my_button.dart';
import 'package:lj_ishop/widgets/my_scroll_view.dart';
import 'package:lj_ishop/widgets/selected_image.dart';
import 'package:lj_ishop/widgets/selected_item.dart';
import 'package:lj_ishop/widgets/text_field_item.dart';

class StoreAuditPage extends StatefulWidget {
  StoreAuditPage({Key? key}) : super(key: key);

  @override
  _StoreAuditPageState createState() => _StoreAuditPageState();
}

class _StoreAuditPageState extends State<StoreAuditPage> {
  final GlobalKey<SelectedImageState> _imageGlobalKey =
      GlobalKey<SelectedImageState>();
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  final FocusNode _nodeText3 = FocusNode();
  String _address = '河南省 信阳市 固始县 黎集镇 李贩村';

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
      keyboardBarColor: ThemeUtils.getKeyboardActionsColor(context),
      nextFocus: true,
      actions: [
        KeyboardActionsItem(
          focusNode: _nodeText1,
          displayDoneButton: false,
        ),
        KeyboardActionsItem(
          focusNode: _nodeText2,
          displayDoneButton: false,
        ),
        KeyboardActionsItem(
          focusNode: _nodeText3,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Text(Utils.getCurrLocale() == 'zh' ? '关闭' : 'Close'),
                ),
              );
            },
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        centerTitle: '店铺审核资料',
      ),
      body: MyScrollView(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        keyboardConfig: _buildConfig(context),
        tapOutsideToDismiss: true,
        children: _buildBody(),
        bottomButton: Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
          child: MyButton(
            onPressed: () {
              debugPrint(
                  '文件路径：${_imageGlobalKey.currentState?.pickedFile?.path}');
              NavigatorUtils.push(context, StoreRouter.auditResultPage);
            },
            text: '提交',
          ),
        ),
      ),

      /// 同时存在底部按钮与keyboardConfig配置时，为保证Android与iOS平台软键盘弹出高度正常，添加下面的代码
      resizeToAvoidBottomInset: defaultTargetPlatform != TargetPlatform.iOS,
    );
  }

  List<Widget> _buildBody() {
    return [
      Gaps.vGap5,
      Padding(
        padding: EdgeInsets.only(left: 16.0),
        child: Text(
          '店铺资料',
          style: TextStyles.textBold18,
        ),
      ),
      Gaps.vGap16,
      Center(
        child: SelectedImage(
          key: _imageGlobalKey,
        ),
      ),
      Gaps.vGap10,
      Center(
        child: Text(
          '店主手持身份证或营业执照',
          style: Theme.of(context)
              .textTheme
              .subtitle2
              ?.copyWith(fontSize: Dimens.font_sp14),
        ),
      ),
      Gaps.vGap16,
      TextFieldItem(
        title: '店铺名称',
        focusNode: _nodeText1,
        hintText: '填写店铺名称',
      ),
      SelectedItem(
        title: '主营范围',
        content: _sortName,
        onTap: () => _showBottomSheet(),
      ),
      SelectedItem(
        title: '店铺地址',
        content: _address,
        onTap: () {
          NavigatorUtils.pushResult(context, ShopRouter.addressSelectPage,
              (result) {
            setState(() {
              final PoiSearch model = result as PoiSearch;
              _address =
                  '${model.provinceName.nullSafe} ${model.cityName.nullSafe} ${model.adName.nullSafe} ${model.title.nullSafe}';
            });
          });
        },
      ),
      Gaps.vGap32,
      Padding(
        padding: EdgeInsets.only(left: 16.0),
        child: Text('店主信息', style: TextStyles.textBold18),
      ),
      Gaps.vGap16,
      TextFieldItem(
        title: '店主姓名',
        focusNode: _nodeText2,
        hintText: '填写店主姓名',
      ),
      TextFieldItem(
        title: '联系电话',
        focusNode: _nodeText3,
        hintText: '填写店主联系电话',
        keyboardType: TextInputType.phone,
      ),
    ];
  }

  String _sortName = '';
  final List<String> _list = [
    '水果生鲜',
    '家用电器',
    '休闲食品',
    '茶酒饮料',
    '美妆个护',
    '粮油调味',
    '家庭清洁',
    '厨具用品',
    '儿童玩具',
    '床上用品'
  ];
  void _showBottomSheet() {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
              key: Key('goods_sort'),
              initialChildSize: 0.7,
              maxChildSize: 1,
              minChildSize: 0.65,
              expand: false,
              builder: (_, scrollController) {
                return ListView.builder(
                  controller: scrollController,
                  itemExtent: 48.0,
                  itemBuilder: (_, index) {
                    return InkWell(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        alignment: Alignment.centerLeft,
                        child: Text(_list[index]),
                      ),
                      onTap: () {
                        setState(() {
                          _sortName = _list[index];
                        });
                        NavigatorUtils.goBack(context);
                      },
                    );
                  },
                  itemCount: _list.length,
                );
              });
        });
  }
}
