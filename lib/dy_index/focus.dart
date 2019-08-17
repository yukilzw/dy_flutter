/**
 * @discripe: 关注
 */
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../bloc.dart';
import '../base.dart';

class IndexPageFocus extends StatelessWidget with DYBase {

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: DYBase.dessignWidth)..init(context);
    return BlocBuilder<TabBloc, List>(
      builder: (context, navList) {
        return Scaffold(
          appBar: AppBar(
            title:Text('（功能测试页面）'),
            centerTitle: true,
            backgroundColor: DYBase.defaultColor,
            brightness: Brightness.dark,
            textTheme: TextTheme(
              title: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            )
          ),
          body: Padding(
            padding: EdgeInsets.all(dp(10)),
              child: Column(
              children: <Widget>[
                Text('TabBloc 全局状态同步：\n${navList.toString()}'),
              ],
            ),
          ),
        );
      }
    );
  }

}