/**
 * @discripe: 业务层方法
 */
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

import 'bloc.dart';
import 'base.dart';
import './dialog/login.dart';
import './dialog/loading.dart';

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
    print(res.data is String);
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
