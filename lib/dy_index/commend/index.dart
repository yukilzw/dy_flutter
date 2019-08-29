/**
 * @discripe: 底部导航 - 推荐
 */
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../bloc.dart';
import '../../base.dart';
import 'header.dart';
import 'swiper.dart';
import 'list.dart';

class CommendPage extends StatelessWidget with DYBase {

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: DYBase.dessignWidth)..init(context);

    return BlocBuilder<TabBloc, List>(
      builder: (context, navList) {
        return Scaffold(
          body: navList.length == 0 ? null : DefaultTabController(
            length: navList.length,
            child: NestedScrollView(  // 嵌套式滚动视图
              headerSliverBuilder: (context, innerScrolled) => <Widget>[
                SliverAppBar(
                    backgroundColor: Colors.white,
                    brightness: Brightness.light,
                    pinned: true,
                    floating: true,
                    snap: true,
                    actions: <Widget>[
                      HeaderWidgets()
                    ],
                    // expandedHeight: dp(130),
                    flexibleSpace: FlexibleSpaceBar(  // 下拉渐入背景
                      background: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(0.0, 1),
                            end: Alignment(0.0, -0.7),
                            colors: <Color>[
                              Color(0xffffffff),
                              Color(0xffff9b7a)
                            ],
                          ),
                        ),
                      ),
                    ),
                    bottom: TabBar(
                      isScrollable: true,
                      labelStyle: TextStyle(
                        fontSize: 15,
                      ),
                      labelColor: DYBase.defaultColor,
                      indicatorColor: DYBase.defaultColor,
                      indicatorPadding: EdgeInsets.only(bottom: dp(7)),
                      unselectedLabelColor: Color(0xff333333),
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: navList.map((e) => Tab(text: e)).toList(),
                    ),
                    forceElevated: innerScrolled,
                  ),
              ],
              body: TabBarView(
                // 这边需要通过 Builder 来创建 TabBarView 的内容，否则会报错
                // NestedScrollView.sliverOverlapAbsorberHandleFor必须在NestedScrollView中调用
                children: navList.asMap().map((i, tab) => MapEntry(i, Builder(
                    builder: (context) => CustomScrollView(
                      physics: BouncingScrollPhysics(),
                      key: PageStorageKey<String>(tab),
                      slivers: <Widget>[
                        // 将子部件同 `SliverAppBar` 重叠部分顶出来，否则会被遮挡
                        /* SliverOverlapInjector(
                          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context)),*/
                        SliverToBoxAdapter(
                          child: Container(
                            child: i == 0 ? Column(
                              children: [
                                SWwiperWidgets(),
                                LiveListWidgets(),
                              ],
                            ) : null,
                          ),
                        )
                      ],
                    ),
                  ),),
                ).values.toList(),
              ),
            ),
          ),
        );
      },
    );
  }

}