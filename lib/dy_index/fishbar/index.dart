/**
 * @discripe: 鱼吧
 */
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../base.dart';

class FishBarPage extends StatefulWidget {
  @override
  _FishBarPage createState() => _FishBarPage();
}

class _FishBarPage extends State<FishBarPage> with DYBase, SingleTickerProviderStateMixin {
  double statusBarHight = MediaQueryData.fromWindow(window).padding.top;
  int _navActIndex = 0;
  // PageController _pageController = PageController();
  List<String> _navList = ['我的', '广场', '找吧'];
  bool isDone = false;
  AnimationController controller;
  Animation<double> animationGiftNum_1;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
    ));
  }

  List<Widget> _nav() {
    return _navList.asMap().map((i, name) {
      return MapEntry(i, GestureDetector(
        onTap: () => setState(() {
          _navActIndex = i;
        }),
        child: Container(
          width: dp(70),
          height: dp(50),
          color: Colors.transparent,
          child: Stack(
            children: <Widget>[
              Center(
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: _navActIndex == i ? 20 : 16,
                    fontWeight: FontWeight.bold,
                    color: _navActIndex == i ? DYBase.defaultColor : Color(0xff333333)
                  ),
                ),
              ),
              _navActIndex == i ? Positioned(
                bottom: 0,
                left: dp(35.0 - 4),
                child: Container(
                  width: dp(8),
                  height: dp(4),
                  decoration: BoxDecoration(
                    color: DYBase.defaultColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(dp(2)),
                    ),
                  ),
                ),
              ) : SizedBox(),
            ],
          ),
        ),
      ),);
    }).values.toList();
  }

  Widget _view() {
    var color;
    switch (_navActIndex) {
      case 0:
        color = Colors.lightBlue;
        break;
      case 1:
        color = Colors.lightGreen;
        break;
      case 2:
        color = Colors.pink;
        break;
    }
    return Container(
      height: 900,
      color: color,
    );
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {

    if (details.delta.dy >= 1.0) {
      print('down');
    } else if (details.delta.dy <= -1.0 && !isDone) {
      print('up');
      isDone = true;

      controller = AnimationController(
        duration: Duration(milliseconds: 180),
        vsync: this
      );

      animationGiftNum_1 = Tween(
        begin: statusBarHight + dp(50), end: statusBarHight,
      ).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeInOut,
        )
      );
      controller.addListener(() {
        if (mounted)
        setState(() {});
      });

      controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onVerticalDragUpdate: _onVerticalDragUpdate,
        child: Column(
          children: <Widget>[
            Container(
              height: animationGiftNum_1 == null ? statusBarHight + dp(50) : animationGiftNum_1.value,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Color(0xffff8633),
                    Color(0xffff6634),
                  ],
                ),
              ),
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: <Widget>[
                  Positioned(
                    bottom: 10,
                    child: Container(
                      width: 300,
                      height: 40,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            ),
            Container(
              color: Colors.transparent,
              child: Row(
                children: _nav(),
              ),
            ),
            Expanded(
              flex: 1,
              child: ScrollConfiguration(
                behavior: DyBehavior(),
                child: ListView(
                  key: ObjectKey(_navActIndex),
                  padding: EdgeInsets.all(0),
                  physics: BouncingScrollPhysics(),
                  children: [
                    _view(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
