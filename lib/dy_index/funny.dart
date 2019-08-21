/**
 * @discripe: 娱乐
 */
import 'package:flutter/material.dart';

import '../base.dart';
import 'lottery.dart';

class IndexPageFunny extends StatefulWidget {
  IndexPageFunny({Key key}) : super(key: key);

  @override
  _IndexPageFunny createState() => _IndexPageFunny();
}

class _IndexPageFunny extends State<IndexPageFunny> with DYBase, SingleTickerProviderStateMixin {
  List tabs = ['抽奖', '竞猜', '答题', '充能', '太空探险', '幻神降临', '幸运水晶'];

  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: 0, length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('娱乐'),
        bottom: buildTabBar(),
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
      body: buildBodyView(),
    );
  }

  //当整个页面dispose时，记得把控制器也dispose掉，释放内存
  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  buildBodyView() {
    //构造 TabBarView
    Widget tabBarBodyView = TabBarView(
      controller: tabController,
      //创建Tab页
      children: tabs.asMap().map((i, e) {
        if (i == 0) {
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
    //构造 TabBar
    Widget tabBar = TabBar(
        //tabs 的长度超出屏幕宽度后，TabBar，是否可滚动
        //设置为false tab 将平分宽度，为true tab 将会自适应宽度
        isScrollable: true,
        //设置tab文字得类型
        labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        //设置tab选中得颜色
        labelColor: Colors.white,
        //设置tab未选中得颜色
        unselectedLabelColor: Colors.white70,
        //设置自定义tab的指示器，CustomUnderlineTabIndicator
        //若不需要自定义，可直接通过
        indicatorColor: Colors.white,  // 设置指示器颜色
        indicatorWeight: 3.0,  // 设置指示器厚度
        //indicatorPadding
        //indicatorSize  设置指示器大小计算方式
        ///指示器大小计算方式，TabBarIndicatorSize.label跟文字等宽,TabBarIndicatorSize.tab跟每个tab等宽
        indicatorSize: TabBarIndicatorSize.tab,
        //生成Tab菜单
        controller: tabController,
        //构造Tab集合
        tabs: tabs.map((e) => Tab(text: e)).toList());

    return tabBar;
  }

}