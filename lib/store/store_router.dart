import 'package:fluro/fluro.dart';
import 'package:fluro/src/fluro_router.dart';
import 'package:lj_ishop/routers/i_router.dart';
import 'package:lj_ishop/store/page/store_audit_page.dart';
import 'package:lj_ishop/store/page/store_audit_result_page.dart';

class StoreRouter implements IRouterProvider {
  static String auditPage = '/store/audit';
  static String auditResultPage = '/store/auditResult';

  @override
  void initRouter(FluroRouter router) {
    router.define(auditPage,
        handler: Handler(handlerFunc: (_, __) => StoreAuditPage()));
    router.define(auditResultPage,
        handler: Handler(handlerFunc: (_, __) => StoreAuditResultPage()));
  }
}
