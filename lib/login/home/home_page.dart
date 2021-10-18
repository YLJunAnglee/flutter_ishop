import 'package:flutter/material.dart';
import 'package:lj_ishop/goods/page/goods_page.dart';
import 'package:lj_ishop/login/home/provider/home_provider.dart';
import 'package:lj_ishop/order/page/order_page.dart';
import 'package:lj_ishop/res/colors.dart';
import 'package:lj_ishop/res/dimens.dart';
import 'package:lj_ishop/shop/page/shop_page.dart';
import 'package:lj_ishop/statistics/page/statistics_page.dart';
import 'package:lj_ishop/widgets/double_tap_back_exit_app.dart';
import 'package:lj_ishop/widgets/load_image.dart';
import 'package:lj_ishop/widgets/my_app_bar.dart';
import 'package:lj_ishop/util/theme_utils.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with RestorationMixin {
  static const double _imageSize = 25.0;

  late List<Widget> _pageList;
  final List<String> _appBarTitles = ['订单', '商品', '统计', '店铺'];
  final PageController _pageController = PageController();

  HomeProvider provider = HomeProvider();

  List<BottomNavigationBarItem>? _list;
  List<BottomNavigationBarItem>? _listDark;

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() {
    _pageList = [
      OrderPage(),
      GoodsPage(),
      StatisticsPage(),
      ShopPage(),
    ];
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();
    super.dispose();
  }

  List<BottomNavigationBarItem> _buildBottomNavigationBarItem() {
    if (_list == null) {
      const _tabImages = [
        [
          LoadAssetImage(
            'home/icon_order',
            width: _imageSize,
            color: Colours.unselected_item_color,
          ),
          LoadAssetImage(
            'home/icon_order',
            width: _imageSize,
            color: Colours.app_main,
          ),
        ],
        [
          LoadAssetImage(
            'home/icon_commodity',
            width: _imageSize,
            color: Colours.unselected_item_color,
          ),
          LoadAssetImage(
            'home/icon_commodity',
            width: _imageSize,
            color: Colours.app_main,
          ),
        ],
        [
          LoadAssetImage(
            'home/icon_statistics',
            width: _imageSize,
            color: Colours.unselected_item_color,
          ),
          LoadAssetImage(
            'home/icon_statistics',
            width: _imageSize,
            color: Colours.app_main,
          ),
        ],
        [
          LoadAssetImage(
            'home/icon_shop',
            width: _imageSize,
            color: Colours.unselected_item_color,
          ),
          LoadAssetImage(
            'home/icon_shop',
            width: _imageSize,
            color: Colours.app_main,
          ),
        ]
      ];
      _list = List.generate(_tabImages.length, (i) {
        return BottomNavigationBarItem(
            icon: _tabImages[i][0],
            activeIcon: _tabImages[i][1],
            label: _appBarTitles[i]);
      });
    }
    return _list!;
  }

  List<BottomNavigationBarItem> _buildDarkBottomNavigationBarItem() {
    if (_listDark == null) {
      const _tabImagesDark = [
        [
          LoadAssetImage('home/icon_order', width: _imageSize),
          LoadAssetImage(
            'home/icon_order',
            width: _imageSize,
            color: Colours.dark_app_main,
          ),
        ],
        [
          LoadAssetImage('home/icon_commodity', width: _imageSize),
          LoadAssetImage(
            'home/icon_commodity',
            width: _imageSize,
            color: Colours.dark_app_main,
          ),
        ],
        [
          LoadAssetImage('home/icon_statistics', width: _imageSize),
          LoadAssetImage(
            'home/icon_statistics',
            width: _imageSize,
            color: Colours.dark_app_main,
          ),
        ],
        [
          LoadAssetImage('home/icon_shop', width: _imageSize),
          LoadAssetImage(
            'home/icon_shop',
            width: _imageSize,
            color: Colours.dark_app_main,
          ),
        ]
      ];

      _listDark = List.generate(_tabImagesDark.length, (i) {
        return BottomNavigationBarItem(
          icon: _tabImagesDark[i][0],
          activeIcon: _tabImagesDark[i][1],
          label: _appBarTitles[i],
        );
      });
    }
    return _listDark!;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDark;
    return ChangeNotifierProvider<HomeProvider>(
      create: (_) => provider,
      child: DoubleTapBackExitApp(
        child: Scaffold(
          bottomNavigationBar: Consumer<HomeProvider>(
            builder: (_, provider, __) {
              return BottomNavigationBar(
                items: isDark
                    ? _buildDarkBottomNavigationBarItem()
                    : _buildBottomNavigationBarItem(),
                backgroundColor: context.backgroundColor,
                type: BottomNavigationBarType.fixed,
                currentIndex: provider.value,
                elevation: 5.0,
                iconSize: 21.0,
                selectedFontSize: Dimens.font_sp10,
                unselectedFontSize: Dimens.font_sp10,
                selectedItemColor: Theme.of(context).primaryColor,
                unselectedItemColor: isDark
                    ? Colours.dark_unselected_item_color
                    : Colours.unselected_item_color,
                onTap: (index) => _pageController.jumpToPage(index),
              );
            },
          ),
          body: PageView(
            physics: NeverScrollableScrollPhysics(),

            /// 禁止滑动
            controller: _pageController,
            onPageChanged: (int index) => provider.value = index,
            children: _pageList,
          ),
        ),
      ),
    );
  }

  @override
  String? get restorationId => 'home';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(provider, 'BottomNavigationBarCurrentIndex');
  }
}
