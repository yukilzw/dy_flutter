/*
 * @discripe: 鱼吧
 */
import 'dart:ui';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../base.dart';
import '../../service.dart';
import '../header.dart';
import 'myConcern.dart';

int _headerAnimationTime = 250;

// 头部动画组件
class AnimatedLogo extends AnimatedWidget with DYBase {
  Tween<double> _opacityTween, _heightTween;
  double height, opacity, beginH, beginO, endH, endO;
  final direction;
  AnimatedLogo({
    Key key, Animation<double> animation, this.direction,
  }) : super(key: key, listenable: animation) {
    beginH = direction == -1 ? DYBase.statusBarHeight : DYBase.statusBarHeight + dp(55);
    endH = direction == -1 ? DYBase.statusBarHeight + dp(55) : DYBase.statusBarHeight;
    beginO = direction == -1 ? 0 : 1;
    endO = direction == -1 ? 1 : 0;
    _heightTween = Tween(
      begin: beginH, end: endH,
    );
    _opacityTween = Tween(
      begin: beginO, end: endO,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return DyHeader(height: _heightTween.evaluate(animation), opacity: _opacityTween.evaluate(animation),);
  }
}

class LogoApp extends StatefulWidget {
  final direction;
  LogoApp(this.direction, {Key key}) : super(key: key);

  _LogoAppState createState() => new _LogoAppState(direction);
}

class _LogoAppState extends State<LogoApp> with DYBase, SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  final direction;

  _LogoAppState(this.direction);

  initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(milliseconds: _headerAnimationTime),
      vsync: this
    );

    animation = CurvedAnimation(parent: controller, curve: Curves.easeInOut);

    controller.forward();
  }

  dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return AnimatedLogo(animation: animation, direction: direction);
  }
}

class FishBarPage extends StatefulWidget {
  @override
  _FishBarPage createState() => _FishBarPage();
}

class _FishBarPage extends State<FishBarPage> with DYBase {
  int _navActIndex = 0;
  List<String> _navList = ['我的', '广场', '找吧'];
  bool _duringAnimation = false;
  AnimationController _controller;
  int _direction;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
    ));
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  List<Widget> _nav() {
    return _navList.asMap().map((i, name) {
      return MapEntry(i, GestureDetector(
        onTap: () => setState(() {
          _navActIndex = i;
        }),
        child: Container(
          width: dp(70),
          height: dp(55),
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
        return NotificationListener(
          onNotification: (notification) {
            switch (notification.runtimeType){
              case ScrollUpdateNotification:
                if (notification?.dragDetails != null) {
                  _onVerticalDragUpdate(notification.dragDetails);
                }
                break;
            }
            return true;
          },
          child: MyConcern(headerAnimated: _headerAnimated),
        );
      case 1:
        color = Colors.lightGreen;
        break;
      case 2:
        color = Colors.pink;
        break;
    }
    return ScrollConfiguration(
      behavior: DyBehaviorNull(),
      child: ListView(
        key: ObjectKey(_navActIndex),
        padding: EdgeInsets.all(0),
        physics: BouncingScrollPhysics(),
        children: [
          Container(
            height: 900,
            color: color,
          ),
        ],
      ),
    );
  }

  // 通过监听手势触发头部动画的下拉与收起
  void _onVerticalDragUpdate(DragUpdateDetails details) {
    if (details.delta.dy >= 1.0) {
      _headerAnimated(-1);  // 向下滑动 ↓
    } else if (details.delta.dy <= -1.0 && !_duringAnimation) {
      _headerAnimated(1);   // 向上滑动 ↑
    }
  }

  void _headerAnimated(direction) {
    if (_duringAnimation) {
      return;
    }
    _duringAnimation = true;

    setState(() {
      _direction = direction;
    });

    Timer(Duration(milliseconds: _headerAnimationTime), () {
      _duringAnimation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onVerticalDragUpdate: _onVerticalDragUpdate,
        child: Column(
          children: <Widget>[
            _direction == null ? DyHeader() : LogoApp(_direction, key: ObjectKey(_direction)),
            Container(
              color: Colors.transparent,
              child: Row(
                children: _nav(),
              ),
            ),
            Expanded(
              flex: 1,
              child: _view(),
            ),
          ],
        ),
      ),
    );
  }
}
