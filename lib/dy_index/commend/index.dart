/*
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
import 'cate.dart';

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

    counterBloc.add(CounterEvent.reset);

    var liveList = await DYservice.getLiveData(context, 1);
    indexBloc.add(UpdateLiveData(liveList));
    // setState(() => null);

    _refreshController.refreshCompleted();
  }

  // 上拉加载
  void _onLoading() async {
    final indexBloc = BlocProvider.of<IndexBloc>(context);

    List liveData = BlocObj.index.state['liveData'];
    var liveList = await DYservice.getLiveData(context);
    liveData.addAll(liveList);
    indexBloc.add(UpdateLiveData(liveData));
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
                  backgroundColor: Color(0xffff6634),
                  brightness: Brightness.dark,
                  pinned: true,
                  floating: true,
                  snap: true,
                  expandedHeight: dp(55) + 49,
                  actions: <Widget>[
                    DyHeader(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(  // 下拉渐入背景
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: FractionalOffset.centerLeft,
                          end: FractionalOffset.centerRight,
                          colors: <Color>[
                            Color(0xffff8633),
                            Color(0xffff6634)
                          ],
                        ),
                      ),
                    ),
                  ),
                  bottom: TabBar(
                    indicator: BoxDecoration(),
                    isScrollable: true,
                    //设置tab文字得类型
                    unselectedLabelStyle: TextStyle(
                      fontSize: 15,
                    ),
                    labelStyle: TextStyle(
                      fontSize: 18,
                    ),
                    //设置tab选中得颜色
                    labelColor: Colors.white,
                    //设置tab未选中得颜色
                    unselectedLabelColor: Colors.white70,
                    //设置自定义tab的指示器，CustomUnderlineTabIndicator
                    //若不需要自定义，可直接通过
                    // indicatorColor: Colors.white,  // 设置指示器颜色
                    indicatorWeight: 3,  // 设置指示器厚度
                    //indicatorPadding
                    //indicatorSize  设置指示器大小计算方式
                    ///指示器大小计算方式，TabBarIndicatorSize.label跟文字等宽,TabBarIndicatorSize.tab跟每个tab等宽
                    // indicatorSize: TabBarIndicatorSize.label,
                    tabs: navList.map((e) => Tab(text: e)).toList(),
                  ),
                  forceElevated: innerScrolled,
                ),
              ],
              body: TabBarView(
                children: navList.asMap().map((i, tab) => MapEntry(i, Builder(
                    builder: (context) => Container(
                      color: Colors.white,
                      child: ScrollConfiguration(
                        behavior: DyBehaviorNull(),
                        child: RefreshConfiguration(
                          headerTriggerDistance: dp(80),
                          maxOverScrollExtent : dp(100),
                          footerTriggerDistance: dp(50),
                          maxUnderScrollExtent: 0,
                          headerBuilder: () => DYrefreshHeader(),
                          footerBuilder: () => DYrefreshFooter(),
                          child: SmartRefresher(
                            enablePullDown: true,
                            enablePullUp: true,
                            footer: DYrefreshFooter(bgColor: Color(0xfff1f5f6),),
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
                                        SwiperList(),
                                        CateList(),
                                        BroadcastSwiper(),
                                        LiveList(),
                                      ],
                                    ) : null,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
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