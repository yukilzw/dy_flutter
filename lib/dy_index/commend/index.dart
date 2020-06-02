/**
 * @discripe: 推荐
 */
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../bloc.dart';
import '../../base.dart';
import '../../service.dart';
import '../header.dart';
import 'swiper.dart';
import 'broadcast.dart';
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

  // 下拉刷新
  void _onRefresh() async {
    await dioManager.deleteByPrimaryKey(DYBase.baseUrl + API.liveData);

    final counterBloc = BlocProvider.of<CounterBloc>(context);
    final indexBloc = BlocProvider.of<IndexBloc>(context);

    counterBloc.dispatch(CounterEvent.reset);

    var liveList = await DYservice.getLiveData(context, 1);
    indexBloc.dispatch(UpdateLiveData(liveList));
    // setState(() => null);

    _refreshController.refreshCompleted();
  }

  // 上拉加载
  void _onLoading() async {
    final indexBloc = BlocProvider.of<IndexBloc>(context);

    List liveData = BlocObj.index.currentState['liveData'];
    var liveList = await DYservice.getLiveData(context);
    liveData.addAll(liveList);
    indexBloc.dispatch(UpdateLiveData(liveData));
    // setState(() => null);

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
                /// 使用[SliverAppBar]组件实现下拉收起头部的效果
                SliverAppBar(
                  backgroundColor: Colors.white,
                  brightness: Brightness.light,
                  pinned: true,
                  floating: true,
                  snap: true,
                  expandedHeight: dp(55) + 49,
                  actions: <Widget>[
                    DyHeader(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      gray: true,
                    ),
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
                children: navList.asMap().map((i, tab) => MapEntry(i, Builder(
                    builder: (context) => SmartRefresher(
                      enablePullDown: true,
                      enablePullUp: true,
                      header: DYrefreshHeader(),
                      footer: DYrefreshFooter(),
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
                                  BroadcastSwiper(),
                                  LiveListWidgets(indexState),
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