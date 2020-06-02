/**
 * @discripe: 鱼吧贴子推荐页(tab - 我的)
 */
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../base.dart';
import '../../service.dart';
import 'cardList.dart';

class MyConcern extends StatefulWidget {
  final headerAnimated;
  MyConcern({ this.headerAnimated });

  @override
  _MyConcern createState() => _MyConcern();
}

class _MyConcern extends State<MyConcern> with DYBase {
  List<String> _myActive = ['鱼吧签到', '我的车队', '狼人杀'];
  GlobalKey _hourTitleKey = GlobalKey();
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  // double _scrollTop = 0;
  // ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    /// 原先通过[ListView]内重新对[_scrollController]监听手势来触发头部展开，因为手势会被当前组件捕获，不会触发外层容器的事件
    /// 经过优化后已不再需要在此注释代码，将[ListView]的滚动事件利用[NotificationListener]通知到父级widget，详情请见fishbar/index.dart统一处理
    /* _scrollController.addListener(() {
      var scrollTop = _scrollController.position.pixels;

      if (scrollTop < 0 || scrollTop >= _scrollController.position.maxScrollExtent) {
        return;
      }
      if (_scrollTop - scrollTop > 20) { // 向下滑动 ↓
        widget.headerAnimated(-1);
        _scrollTop = scrollTop;
      } else if (scrollTop - _scrollTop > 20) {  // 向上滑动 ↑
        widget.headerAnimated(1);
        _scrollTop = scrollTop;
      }
    }); */
  }

  @override
  void dispose() {
    // _scrollController?.dispose();
    super.dispose();
  }

  // 下拉刷新
  void _onRefresh() async {
    rx.push('yubaList', data: 'refresh');
  }

  // 上拉加载
  void _onLoading() async {
    rx.push('yubaList', data: 'more');
  }

  // 渲染我的活动功能
  Widget _renderMyActive() {
    return Wrap(
      children: _myActive.asMap().map((i, item) {
        return MapEntry(
          i, Container(
            width: (MediaQuery.of(context).size.width - 20) / 4,
            color: Colors.transparent,
            child: Column(
              children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      top: dp(16),
                    ),
                    child: Image.asset(
                      'images/bar/tab-$i.png',
                      width: dp(70),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: dp(8),
                    ),
                    child: Text(
                      item,
                      style: TextStyle(
                        color: Color(0xff333333)
                      ),
                    ),
                  ),
                ],
              ),
          ),
        );
      }).values.toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          child: SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            header: DYrefreshHeader(),
            footer: DYrefreshFooter(),
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: ListView(
              // controller: _scrollController,
              padding: EdgeInsets.all(0),
              physics: BouncingScrollPhysics(),
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: dp(15), left: dp(10), right: dp(10)),
                  child: _renderMyActive()
                ),
                Padding(
                  key: _hourTitleKey,
                  padding: EdgeInsets.only(
                    left: dp(15), right: dp(15), top: dp(5), bottom: dp(10),
                  ),
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        'images/bar/day-title.png',
                        height: dp(16),
                      ),
                      Padding(padding: EdgeInsets.only(left: dp(6)),),
                      Expanded(
                        flex: 1,
                        child: Text(
                          '每日斗鱼',
                          style: TextStyle(
                            color: Color(0xff333333),
                            fontWeight: FontWeight.bold,
                            fontSize: 15
                          ),
                        ),
                      ),
                      Image.asset(
                        'images/bar/usefulSelect.webp',
                        height: dp(25),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Color(0xfff3f3f3),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(dp(15)),
                        child: FishBarCardList(
                          hourTitleKey: _hourTitleKey,
                          refreshController: _refreshController,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            padding: EdgeInsets.only( left: dp(10), right: dp(8), top: dp(6), bottom: dp(6) ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(dp(20)),
                bottomLeft: Radius.circular(dp(20)),
              ),
              boxShadow: [
                BoxShadow(color: Color.fromARGB(50, 92, 92, 92), offset: Offset(dp(-1), dp(5)), blurRadius: dp(4), spreadRadius: dp(-2)),
              ],
            ),
            child: Row(
              children: <Widget>[
                Image.asset(
                  'images/bar/hot-title.png',
                  height: dp(16),
                ),
                Padding(
                  padding: EdgeInsets.only(right: dp(5)),
                ),
                Text(
                  '斗鱼24小时精彩'
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}