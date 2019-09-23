/**
 * @discripe: 底部导航 - 推荐
 */
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

import '../../bloc.dart';
import '../../base.dart';
import 'header.dart';
import 'swiper.dart';
import 'list.dart';

class CommendPage extends StatefulWidget {
  final _scrollController;
  CommendPage(this._scrollController);

  @override
  _CommendPage createState() => _CommendPage(this._scrollController);
}

class _CommendPage extends State<CommendPage> with DYBase, AutomaticKeepAliveClientMixin  {
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  final _scrollController;

  _CommendPage(this._scrollController);

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _refreshController?.dispose();
    super.dispose();
  }

  // 获取直播间列表
  Future<List> _getLiveData([ pageIndex ]) async {
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

  // 下拉刷新
  void _onRefresh() async {
    await dioManager.deleteByPrimaryKey(DYBase.baseUrl + API.liveData);

    final counterBloc = BlocProvider.of<CounterBloc>(context);
    final indexBloc = BlocProvider.of<IndexBloc>(context);

    counterBloc.dispatch(CounterEvent.reset);

    var liveList = await _getLiveData(1);
    indexBloc.dispatch(UpdateLiveData(liveList));

    _refreshController.refreshCompleted();
  }

  // 上拉加载
  void _onLoading() async {
    final indexBloc = BlocProvider.of<IndexBloc>(context);

    List liveData = BlocObj.index.currentState['liveData'];
    var liveList = await _getLiveData();
    liveData.addAll(liveList);
    indexBloc.dispatch(UpdateLiveData(liveData));

    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ScreenUtil.instance = ScreenUtil(width: DYBase.dessignWidth)..init(context);

    return BlocBuilder<IndexBloc, Map>(
      builder: (context, indexState) {
        List navList = indexState['nav'];
        return Scaffold(
          body: navList.length == 0 ? null : DefaultTabController(
            length: navList.length,
            child: NestedScrollView(  // 嵌套式滚动视图
              controller: _scrollController,
              headerSliverBuilder: (context, innerScrolled) => <Widget>[
                SliverAppBar(
                  backgroundColor: Colors.white,
                  brightness: Brightness.light,
                  pinned: true,
                  floating: true,
                  snap: true,
                  expandedHeight: dp(100),
                  actions: <Widget>[
                    HeaderWidgets()
                  ],
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
                                  LiveListWidgets(),
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