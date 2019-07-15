library base;

import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract class DYBase {
  // 初始化设计稿尺寸
  static double dessignWidth = 375.0;
  static double dessignHeight = 1335.0;

  // flutter_screenutil px转dp
  num dp(double dessignValue) => ScreenUtil.getInstance().setWidth(dessignValue);
}