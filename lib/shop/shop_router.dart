import 'package:fluro/fluro.dart';
import 'package:lj_ishop/routers/i_router.dart';
import 'package:lj_ishop/shop/page/select_address_page.dart';

class ShopRouter implements IRouterProvider {
  static String shopPage = '/shop';
  static String shopSettingPage = '/shop/shopSetting';
  static String messagePage = '/shop/message';
  static String freightConfigPage = '/shop/freightConfig';
  static String addressSelectPage = '/shop/addressSelect';
  static String inputTextPage = '/shop/inputText';

  @override
  void initRouter(FluroRouter router) {
    router.define(addressSelectPage,
        handler: Handler(handlerFunc: (_, __) => AddressSelectPage()));
  }
}
