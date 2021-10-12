import 'package:fluro/fluro.dart';

/// Abstract被用于定义一个抽象类，用Abstract修饰的class是无法被实例化的
abstract class IRouterProvider {
  void initRouter(FluroRouter router);
}
