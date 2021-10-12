import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:lj_ishop/demo/demo_page.dart';
import 'package:lj_ishop/home/splash_page.dart';
import 'package:lj_ishop/login/page/login_page.dart';
import 'package:lj_ishop/net/dio_utils.dart';
import 'package:lj_ishop/net/intercept.dart';
import 'package:lj_ishop/res/constant.dart';
import 'package:lj_ishop/routers/not_found_page.dart';
import 'package:lj_ishop/routers/routers.dart';
import 'package:lj_ishop/setting/locale_provider.dart';
import 'package:lj_ishop/setting/theme_provider.dart';
import 'package:lj_ishop/util/device_utils.dart';
import 'package:lj_ishop/util/handle_error_utils.dart';
import 'package:lj_ishop/util/log_utils.dart';
import 'package:lj_ishop/util/theme_utils.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:url_strategy/url_strategy.dart';

Future<void> main() async {
  /// 确保初始化完成
  WidgetsFlutterBinding.ensureInitialized();

  /// 去除URL中的“#”(hash)，仅针对Web。默认为setHashUrlStrategy
  /// 注意本地部署和远程部署时`web/index.html`中的base标签，https://github.com/flutter/flutter/issues/69760
  setPathUrlStrategy();

  /// sp初始化
  SpUtil.getInstance();

  /// 异常处理
  handleError(runApp(MyApp(
    home: LoginPage(),
  )));
}

class MyApp extends StatelessWidget {
  final Widget? home;
  final ThemeData? theme;
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  MyApp({Key? key, this.home, this.theme}) : super(key: key) {
    Log.init();
    initDio();
    Routes.initRoutes();
    initQuickActions();
  }

  /// 初始化网络请求
  void initDio() {
    final List<Interceptor> interceptors = <Interceptor>[];

    /// 统一添加身份验证请求头
    interceptors.add(AuthInterceptor());

    /// 刷新token
    interceptors.add(TokenInterceptor());

    /// 打印Log(生产模式去除)
    if (!Constant.inProduction) {
      interceptors.add(LoggingInterceptor());
    }

    /// 适配数据（根据自己的数据结构，可自行选择添加）
    interceptors.add(AdapterInterceptor());
    configDio(baseUrl: 'https://api.github.com/', interceptors: interceptors);
  }

  void initQuickActions() {
    if (Device.isMobile) {
      const QuickActions quickActions = QuickActions();
      if (Device.isIOS) {
        quickActions.initialize((String shortcutType) {
          if (shortcutType == 'demo') {
            navigatorKey.currentState?.push<dynamic>(MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => DemoPage(),
            ));
          }
        });
      }

      quickActions.setShortcutItems(<ShortcutItem>[
        const ShortcutItem(
            type: 'demo', localizedTitle: 'Demo', icon: 'flutter_dash_black')
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget app = MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider())
      ],
      child: Consumer2<ThemeProvider, LocaleProvider>(builder:
          (_, ThemeProvider provider, LocaleProvider localeProvider, __) {
        return _buildMaterialApp(provider, localeProvider);
      }),
    );

    /// Toast配置
    return OKToast(
      child: app,
      backgroundColor: Colors.black54,
      textPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      radius: 20.0,
      position: ToastPosition.bottom,
    );
  }

  Widget _buildMaterialApp(
      ThemeProvider provider, LocaleProvider localeProvider) {
    return MaterialApp(
      title: 'Flutter Deer',
      theme: theme ?? provider.getTheme(),
      darkTheme: provider.getTheme(isDarkMode: true),
      themeMode: provider.getThemeMode(),
      home: home ?? SplashPage(),
      onGenerateRoute: Routes.router.generator,
      locale: localeProvider.locale,
      navigatorKey: navigatorKey,
      builder: (BuildContext context, Widget? child) {
        /// 仅针对安卓
        if (Device.isAndroid) {
          /// 切换深色模式会触发此方法，这里设置导航栏颜色
          ThemeUtils.setSystemNavigationBar(provider.getThemeMode());
        }
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child!);
      },

      /// 因为使用了fluro，这里设置主要针对Web
      onUnknownRoute: (_) {
        return MaterialPageRoute<void>(
          builder: (BuildContext context) => const NotFoundPage(),
        );
      },
      restorationScopeId: 'app',
    );
  }
}
