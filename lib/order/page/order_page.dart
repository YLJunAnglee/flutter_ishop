import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lj_ishop/order/page/order_list_page.dart';
import 'package:lj_ishop/order/provider/order_page_provider.dart';
import 'package:lj_ishop/res/colors.dart';
import 'package:lj_ishop/res/dimens.dart';
import 'package:lj_ishop/res/gaps.dart';
import 'package:lj_ishop/res/styles.dart';
import 'package:lj_ishop/util/image_utils.dart';
import 'package:lj_ishop/util/theme_utils.dart';
import 'package:lj_ishop/widgets/load_image.dart';
import 'package:lj_ishop/widgets/my_card.dart';
import 'package:lj_ishop/widgets/my_flexible_space_bar.dart';
import 'package:provider/provider.dart';
import 'package:lj_ishop/util/screen_utils.dart';

/// 订单
class OrderPage extends StatefulWidget {
  OrderPage({Key? key}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage>
    with
        AutomaticKeepAliveClientMixin<OrderPage>,
        SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  TabController? _tabController;
  OrderPageProvider provider = OrderPageProvider();

  int _lastReportedPage = 0;

  bool isDark = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      /// 预先缓存剩余切换图片
      _preCacheImage();
    });
  }

  void _preCacheImage() {
    precacheImage(ImageUtils.getAssetImage('order/xdd_n'), context);
    precacheImage(ImageUtils.getAssetImage('order/dps_s'), context);
    precacheImage(ImageUtils.getAssetImage('order/dwc_s'), context);
    precacheImage(ImageUtils.getAssetImage('order/ywc_s'), context);
    precacheImage(ImageUtils.getAssetImage('order/yqx_s'), context);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    isDark = context.isDark;
    return ChangeNotifierProvider<OrderPageProvider>(
      create: (_) => provider,
      child: Scaffold(
        body: Stack(
          children: [
            /// 像素对齐问题的临时解决方法
            SafeArea(
                child: SizedBox(
              height: 105.0,
              width: double.infinity,
              child: isDark
                  ? null
                  : DecoratedBox(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                        Colours.gradient_blue,
                        Color(0xFF4647FA)
                      ])),
                    ),
            )),
            NestedScrollView(
                key: const Key('order_list'),
                physics: ClampingScrollPhysics(),
                headerSliverBuilder: (context, innerBoxIsScrolled) =>
                    _sliverBuilder(context),
                body: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification notification) {
                      if (notification.depth == 0 &&
                          notification is ScrollEndNotification) {
                        final PageMetrics metrics =
                            notification.metrics as PageMetrics;
                        final int currentPage = (metrics.page ?? 0).round();
                        if (currentPage != _lastReportedPage) {
                          _lastReportedPage = currentPage;
                          _onPageChange(currentPage);
                        }
                      }
                      return false;
                    },
                    child: PageView.builder(
                        key: Key('pageView'),
                        itemCount: 5,
                        controller: _pageController,
                        itemBuilder: (_, index) =>
                            OrderListPage(index: index)))),
          ],
        ),
      ),
    );
  }

  final PageController _pageController = PageController(initialPage: 0);
  Future<void> _onPageChange(int index) async {
    provider.setIndex(index);
    _tabController?.animateTo(index, duration: Duration.zero);
  }

  List<Widget> _sliverBuilder(BuildContext context) {
    return <Widget>[
      SliverOverlapAbsorber(
        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        sliver: SliverAppBar(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          actions: [
            IconButton(
              onPressed: () {},
              tooltip: '搜索',
              icon: LoadAssetImage(
                'order/icon_search',
                width: 22.0,
                height: 22.0,
                color: ThemeUtils.getIconColor(context),
              ),
            )
          ],
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          expandedHeight: 100.0,
          floating: false,
          pinned: true,
          flexibleSpace: MyFlexibleSpaceBar(
            background: isDark
                ? Container(height: 113.0, color: Colours.dark_bg_color)
                : LoadAssetImage(
                    'order/order_bg',
                    width: context.width,
                    height: 113.0,
                    fit: BoxFit.fill,
                  ),
            centerTitle: true,
            titlePadding: EdgeInsetsDirectional.only(start: 16.0, bottom: 14.0),
            collapseMode: CollapseMode.pin,
            title: Text(
              '订单',
              style: TextStyle(color: ThemeUtils.getIconColor(context)),
            ),
          ),
        ),
      ),
      SliverPersistentHeader(
          pinned: true,
          delegate: SliverAppBarDelegate(
              DecoratedBox(
                decoration: BoxDecoration(
                    color: isDark ? Colours.dark_bg_color : null,
                    image: isDark
                        ? null
                        : DecorationImage(
                            image: ImageUtils.getAssetImage('order/order_bg1'),
                            fit: BoxFit.fill)),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: MyCard(
                      child: Container(
                    height: 80.0,
                    padding: EdgeInsets.only(top: 8.0),
                    child: TabBar(
                      labelPadding: EdgeInsets.zero,
                      controller: _tabController,
                      labelColor:
                          context.isDark ? Colours.dark_text : Colours.text,
                      unselectedLabelColor: context.isDark
                          ? Colours.dark_text_gray
                          : Colours.text,
                      labelStyle: TextStyles.textBold14,
                      unselectedLabelStyle: TextStyle(
                        fontSize: Dimens.font_sp14,
                      ),
                      indicatorColor: Colors.transparent,
                      tabs: [
                        _TabView(0, '新订单'),
                        _TabView(1, '待配送'),
                        _TabView(2, '待完成'),
                        _TabView(3, '已完成'),
                        _TabView(4, '已取消'),
                      ],
                      onTap: (index) {
                        if (!mounted) {
                          return;
                        }
                        _pageController.jumpToPage(index);
                      },
                    ),
                  )),
                ),
              ),
              80.0)),
    ];
  }
}

List<List<String>> img = [
  ['order/xdd_s', 'order/xdd_n'],
  ['order/dps_s', 'order/dps_n'],
  ['order/dwc_s', 'order/dwc_n'],
  ['order/ywc_s', 'order/ywc_n'],
  ['order/yqx_s', 'order/yqx_n']
];

List<List<String>> darkImg = [
  ['order/dark/icon_xdd_s', 'order/dark/icon_xdd_n'],
  ['order/dark/icon_dps_s', 'order/dark/icon_dps_n'],
  ['order/dark/icon_dwc_s', 'order/dark/icon_dwc_n'],
  ['order/dark/icon_ywc_s', 'order/dark/icon_ywc_n'],
  ['order/dark/icon_yqx_s', 'order/dark/icon_yqx_n']
];

class _TabView extends StatelessWidget {
  const _TabView(this.index, this.text);

  final int index;
  final String text;

  @override
  Widget build(BuildContext context) {
    final List<List<String>> imgList = context.isDark ? darkImg : img;
    return Stack(
      children: [
        Container(
          width: 46.0,
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            children: [
              LoadAssetImage(
                context.select<OrderPageProvider, int>(
                            (value) => value.index) ==
                        index
                    ? imgList[index][0]
                    : imgList[index][1],
                width: 24.0,
                height: 24.0,
              ),
              Gaps.vGap4,
              Text(text)
            ],
          ),
        ),
        Positioned(
          right: 0,
          child: index < 3
              ? DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context).errorColor,
                    borderRadius: BorderRadius.circular(11.0),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.5, vertical: 2.0),
                    child: Text(
                      '10',
                      style: TextStyle(
                          color: Colors.white, fontSize: Dimens.font_sp12),
                    ),
                  ),
                )
              : Gaps.empty,
        )
      ],
    );
  }
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate(this.widget, this.height);

  final Widget widget;
  final double height;

  // minHeight 和 maxHeight 的值设置为相同时，header就不会收缩了
  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return widget;
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return true;
  }
}
