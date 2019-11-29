/**
 * @discripe: 业务层方法
 */
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

import 'bloc.dart';
import 'base.dart';
import './dy_dialog/login.dart';
import './dy_dialog/loading.dart';

abstract class DYservice {
  // 获取直播间列表
  static Future<List> getLiveData(context, [ pageIndex ]) async {
    final counterBloc = BlocProvider.of<CounterBloc>(context);
    int livePageIndex = BlocObj.counter.currentState;

    var res = await httpClient.get(
      API.liveData,
      queryParameters: {
        'page': pageIndex == null ? livePageIndex : pageIndex
      },
      options: livePageIndex == 1 ? buildCacheOptions(
        Duration(minutes: 30),
      ) : null,
    );

    counterBloc.dispatch(CounterEvent.increment);
    return res.data['data']['list'];
  }
}

abstract class DYdialog {
    // 默认弹窗alert
  static void alert(context, {
    @required String text, String title = '提示', String yes = '确定',
    Function yesCallBack
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(text),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(yes),
              onPressed: () {
                if (yesCallBack != null) yesCallBack();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    ).then((val) {});
  }

  // loadingDialog
  static void showLoading(context, {
    String title = '正在加载...'
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return LoadingDialog(
          text: title,
        );
      }
    );
  }

  // login
  static void showLogin(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return LoginDialog();
      }
    );
  }
}

// 禁用点击水波纹
class NoSplashFactory extends InteractiveInkFeatureFactory {
  @override
  InteractiveInkFeature create({
    MaterialInkController controller,
    RenderBox referenceBox,
    Offset position,
    Color color,
    TextDirection textDirection,
    bool containedInkWell = false,
    rectCallback,
    BorderRadius borderRadius,
    ShapeBorder customBorder,
    double radius,
    onRemoved
  }) {
    return NoSplash(
      controller: controller,
      referenceBox: referenceBox,
    );
  }
}

class NoSplash extends InteractiveInkFeature {
  NoSplash({
    @required MaterialInkController controller,
    @required RenderBox referenceBox,
  }) : super(
    controller: controller,
    referenceBox: referenceBox,
  );

  @override
  void paintFeature(Canvas canvas, Matrix4 transform) {}
}

// 去除安卓滚动视图水波纹
class DyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    if (Platform.isAndroid || Platform.isFuchsia) {
      return child;
    } else {
      return super.buildViewportChrome(context,child,axisDirection);
    }
  }
}