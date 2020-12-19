library base;
/*
 * @discripe: 全局公共类管理
 */
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

export 'bloc.dart';
export 'rx.dart';
export 'httpUrl.dart';
export 'io.dart';

// 所有Widget继承的抽象类
abstract class DYBase {
  static final baseSchema = 'http';
  static final baseHost = '192.168.97.142';
  static final basePort = '1236';
  static final baseUrl = '${DYBase.baseSchema}://${DYBase.baseHost}:${DYBase.basePort}';
  // 默认斗鱼主题色
  static final defaultColor = Color(0xffff5d23);
  // 初始化设计稿尺寸
  static final double dessignWidth = 375.0;
  static final double dessignHeight = 1335.0;

  static final double statusBarHeight = MediaQueryData.fromWindow(window).padding.top;

  // flutter_screenutil px转dp
  num dp(double dessignValue) => ScreenUtil.getInstance().setWidth(dessignValue);
}