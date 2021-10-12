import 'package:common_utils/common_utils.dart';
import 'package:lj_ishop/res/constant.dart';

/// 输出Log工具类
class Log {
  static const String tag = 'DEER-LOG';

  static void init() {
    LogUtil.init(isDebug: !Constant.inProduction);
  }
}
