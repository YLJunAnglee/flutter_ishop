import 'dart:ffi';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:lj_ishop/routers/i_router.dart';

class Routes {
  static String home = '/home';
  static String webViewPage = '/webView';

  static final List<IRouterProvider> _listRouter = [];
  static final FluroRouter router = FluroRouter();

  static void initRoutes() {}
}
