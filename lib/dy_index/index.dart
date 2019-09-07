/**
 * @discripe: 首页轮播图、视频列表、底部导航更多功能
 */
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../bloc.dart';
import '../base.dart';
import 'funny/index.dart';
import 'focus/index.dart';
import 'commend/index.dart';

class DyIndexPage extends StatefulWidget {
  final arguments;
  DyIndexPage({Key key, this.arguments}) : super(key: key);

  @override
  _DyIndexPageState createState() => _DyIndexPageState();
}

class _DyIndexPageState extends State<DyIndexPage> with DYBase, SingleTickerProviderStateMixin {
  final _bottomNavList = ["推荐", "娱乐", "关注", "鱼吧", "发现"]; // 底部导航
  int _currentIndex = 0;  // 底部导航当前页面

  @override
  void initState() {
    super.initState();
    // 优先从缓存中拿navList
    DYio.getTempFile('navList').then((dynamic data) {
      if (data == null) return;
      setState(() {
        var navList = data['data'];
        _setNavInBloc(navList);
      });
    });
    _getNav();
  }

  // 获取导航列表
  void _getNav() {
    httpClient.get(
      '/dy/flutter/nav',
    ).then((res) {
      DYio.setTempFile('navList', res.data.toString());
      var navList = res.data['data'];
      _setNavInBloc(navList);
    });
  }

  void _setNavInBloc(navList) {
    final tabBloc = BlocProvider.of<TabBloc>(context);
    tabBloc.dispatch(UpdateTab(navList));
  }

  // 点击悬浮标
  void _incrementCounter() {
    final counterBloc = BlocProvider.of<CounterBloc>(context);
    counterBloc.dispatch(CounterEvent.increment);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: DYBase.dessignWidth)..init(context);

    return Scaffold(
      // 底部导航栏
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: DYBase.defaultColor,
        unselectedItemColor: Colors.black38,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              title: Text(_bottomNavList[0]),
              icon: _currentIndex == 0
                  ? Icon(Icons.done_all)
                  : Icon(Icons.done)),
          BottomNavigationBarItem(
              title: Text(_bottomNavList[1]),
              icon: _currentIndex == 1
                  ? Icon(Icons.flight_takeoff)
                  : Icon(Icons.flight_land)),
          BottomNavigationBarItem(
              title: Text(_bottomNavList[2]),
              icon: _currentIndex == 2
                  ? Icon(Icons.hourglass_full)
                  : Icon(Icons.hourglass_empty)),
          BottomNavigationBarItem(
              title: Text(_bottomNavList[3]),
              icon: _currentIndex == 3
                  ? Icon(Icons.trending_up)
                  : Icon(Icons.trending_down)),
          BottomNavigationBarItem(
              title: Text(_bottomNavList[4]),
              icon: _currentIndex == 4
                  ? Icon(Icons.thumb_up)
                  : Icon(Icons.thumb_down)),
        ]
      ),
      body: _currentPage(),
      floatingActionButton: _currentIndex != 0 ? null : FloatingActionButton(
        onPressed: _incrementCounter,
        foregroundColor: DYBase.defaultColor,
        backgroundColor: Colors.white,
        tooltip: 'Increment',
        child: Icon(Icons.favorite),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  // 底部导航对应的页面
  Widget _currentPage() {
    Widget page;
    switch (_currentIndex) {
      case 0:
        page = CommendPage();
        break;
      case 1:
        page = FunnyPage();
        break;
      case 2:
        page = FocusPage();
        break;
      default:
        page = Scaffold(
          appBar: AppBar(
            title:Text(_bottomNavList[_currentIndex]),
            backgroundColor: DYBase.defaultColor,
            brightness: Brightness.dark,
            textTheme: TextTheme(
              title: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            )
          ),
          body: Center(child: Text(
              '正在建设中...',
              style: TextStyle(fontSize: 20, color: Colors.black45),
            ),
          ),
        );
        break;
    }
    return page;
  }

}
