/**
 * @discripe: 娱乐
 */
import 'package:flutter/material.dart';

import '../../base.dart';
import '../header.dart';
import 'lottery.dart';

class FunnyPage extends StatefulWidget {
  @override
  _FunnyPage createState() => _FunnyPage();
}

class _FunnyPage extends State<FunnyPage> with DYBase, SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  List tabs = ['抽奖', '竞猜', '答题', '充能', '太空探险', '幻神降临', '幸运水晶']; // 顶部导航栏

  TabController tabController;  // 导航栏切换Controller

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: 0, length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          bottom: buildTabBar(),
          centerTitle: true,
          // backgroundColor: Colors.white,
          actions: <Widget>[
            DyHeader(decoration: BoxDecoration(
              color: Colors.transparent,
            ),),
          ],
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Color(0xffff8633),
                  Color(0xffff6634)
                ],
              ),
            ),
          ),
          brightness: Brightness.dark,
          textTheme: TextTheme(
            title: TextStyle(
              color: Colors.white,
            ),
          )
        ),
        preferredSize: Size.fromHeight(49 + dp(55)),
      ),
      body: buildBodyView(),
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  buildBodyView() {
    Widget tabBarBodyView = TabBarView(
      controller: tabController,
      //创建Tab页
      children: tabs.asMap().map((i, e) {
        if (i == 0) { // 九宫格抽奖
          return MapEntry(i, Lottery());
        }
        return MapEntry(i, Container(
          alignment: Alignment.center,
          child: Text(e, textScaleFactor: 1),
        ));
      }).values.toList(),
    );
    return tabBarBodyView;
  }

  buildTabBar() {
    Widget tabBar = TabBar(
      //tabs 的长度超出屏幕宽度后，TabBar，是否可滚动
      //设置为false tab 将平分宽度，为true tab 将会自适应宽度
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
      indicatorColor: Colors.white,  // 设置指示器颜色
      indicatorWeight: 3,  // 设置指示器厚度
      //indicatorPadding
      //indicatorSize  设置指示器大小计算方式
      ///指示器大小计算方式，TabBarIndicatorSize.label跟文字等宽,TabBarIndicatorSize.tab跟每个tab等宽
      indicatorSize: TabBarIndicatorSize.label,
      //生成Tab菜单
      controller: tabController,
      //构造Tab集合
      tabs: tabs.map((e) => Tab(text: e)).toList(),
    );

    return tabBar;
  }

}