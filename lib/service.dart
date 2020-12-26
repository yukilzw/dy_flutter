/*
 * @discripe: 业务层方法
 */
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:lottie/lottie.dart';

import 'bloc.dart';
import 'base.dart';
import './dy_dialog/login.dart';
import './dy_dialog/loading.dart';

abstract class DYservice {
  // 获取直播间列表
  static Future<List> getLiveData(context, [ pageIndex ]) async {
    final counterBloc = BlocProvider.of<CounterBloc>(context);
    int livePageIndex = BlocObj.counter.state;

    var res = await httpClient.get(
      API.liveData,
      queryParameters: {
        'page': pageIndex == null ? livePageIndex : pageIndex
      },
      options: livePageIndex == 1 ? buildCacheOptions(
        Duration(minutes: 30),
      ) : null,
    );

    counterBloc.add(CounterEvent.increment);
    return res.data['data']['list'];
  }

  // 格式化数值
  static String formatNum(int number) {
    if (number > 10000) {
      var str = DYservice._formatNum(number / 10000, 1);
      if (str.split('.')[1] == '0') {
        str = str.split('.')[0];
      }
      return str + '万';
    }
    return number.toString();
  }
  static String _formatNum(double number, int postion) {
    if((number.toString().length - number.toString().lastIndexOf(".") - 1) < postion) {
      // 小数点后有几位小数
      return ( number.toStringAsFixed(postion).substring(0, number.toString().lastIndexOf(".")+postion + 1).toString());
    } else {
      return ( number.toString().substring(0, number.toString().lastIndexOf(".") + postion + 1).toString());
    }
  }

  // 格式化时间
  static String formatTime(int timeSec) {
    var date = DateTime.fromMillisecondsSinceEpoch(timeSec * 1000);
    var now = DateTime.now();
    var yesterday = DateTime.fromMillisecondsSinceEpoch(now.millisecondsSinceEpoch - 24 * 60 * 60 * 1000);

    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return '今天${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day) {
      return '昨天${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }
    return '${date.year.toString()}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
  
  // 生成随机串
  static dynamic randomBit(int len, { String type }) {
    String character = type == 'num' ? '0123456789' : 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';
    String left = '';
    for (var i = 0; i < len; i++) {
      left = left + character[Random().nextInt(character.length)]; 
    }
    return type == 'num' ? int.parse(left) : left;
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
class DyBehaviorNull extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    if (Platform.isAndroid || Platform.isFuchsia) {
      return child;
    } else {
      return super.buildViewportChrome(context,child,axisDirection);
    }
  }
}

// 下拉刷新头部、底部组件                                                            
class DYrefreshHeader extends StatelessWidget with DYBase {
  @override
  Widget build(BuildContext context) {
    final refreshing = Lottie.network(
      '${DYBase.baseUrl}/static/if_refresh.json',
      height: dp(50)
    );

    return CustomHeader(
      refreshStyle: RefreshStyle.Follow,
      builder: (BuildContext context,RefreshStatus status) {
        bool swimming = (status == RefreshStatus.refreshing || status == RefreshStatus.completed);
        return Container(
          height: dp(50),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              swimming ? SizedBox() : Image.asset(
                'images/fun_home_pull_down.png',
                height: dp(50),
              ),
              Offstage(
                offstage: !swimming,
                child: refreshing,
              ),
            ]
          )
        );
      }
    );
  }
}

class DYrefreshFooter extends StatelessWidget with DYBase {
  final bgColor;
  DYrefreshFooter({this.bgColor});

  @override
  Widget build(BuildContext context) {
    final height = dp(50);

    return CustomFooter(
      height: height,
      builder: (BuildContext context,LoadStatus mode){
        final textStyle = TextStyle(
          color: Color(0xffA7A7A7),
          fontSize: dp(13),
        );
        Widget body;
        Widget loading = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.network(
              '${DYBase.baseUrl}/static/loading.json',
              height: dp(34)
            ),
            Text(
              '用力加载中...',
              style: textStyle,
            ),
          ],
        );
        if(mode==LoadStatus.idle){
          body = loading;
        }
        else if(mode==LoadStatus.loading){
          body = loading;
        }
        else if(mode == LoadStatus.failed){
          body = Text(
            '网络出错啦 😭',
            style: textStyle,
          );
        }
        else if(mode == LoadStatus.canLoading){
          body = loading;
        }
        else{
          body = Text(
            '我是有底线的 😭',
            style: textStyle,
          );
        }
        return Container(
          color: bgColor,
          height: height,
          child: Center(child:body),
        );
      },
    );
  }
}