/**
 * @discripe: 底部导航 - 推荐
 */
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../bloc.dart';
import '../../base.dart';
import 'header.dart';
import 'swiper.dart';
import 'list.dart';

class CommendPage extends StatefulWidget {
  @override
  _CommendPage createState() => _CommendPage();
}

class _CommendPage extends State<CommendPage> with DYBase {
  int livePageIndex = 1;
  List liveData = []; // 推荐直播间列表
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _init();
  }

  // 获取正在直播推荐列表数据
  Future<List> _getLiveData() async {
    var res = await httpClient.post(
      '/dy/flutter/liveData',
      data: {
        'page': livePageIndex.toString()
      }
    );
    livePageIndex++;
    return res.data['data']['list'];
  }

  void _init() async {
    var liveList = await _getLiveData();
    setState(() {
      liveData = liveList;
    });
  }

  // 下拉刷新
  void _onRefresh() async {
    livePageIndex = 1;
    var liveList = await _getLiveData();
    if(mounted)
    setState(() {
      liveData = liveList;
    });
    _refreshController.refreshCompleted();
  }

  // 上拉加载
  void _onLoading() async {
    var liveList = await _getLiveData();
    if(mounted)
    setState(() {
      liveData.addAll(liveList);
    });
    _refreshController.loadComplete();
  }

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
                children: navList.asMap().map((i, tab) => MapEntry(i, Builder(
                    builder: (context) => SmartRefresher(
                      enablePullDown: true,
                      enablePullUp: true,
                      header: WaterDropHeader(),
                      controller: _refreshController,
                      onRefresh: _onRefresh,
                      onLoading: _onLoading,
                      child: CustomScrollView(
                        // physics: BouncingScrollPhysics(),
                        slivers: <Widget>[
                          SliverToBoxAdapter(
                            child: Container(
                              child: i == 0 ? Column(
                                children: [
                                  SWwiperWidgets(),
                                  LiveListWidgets(liveData),
                                ],
                              ) : null,
                            ),
                          )
                        ],
                      ),
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