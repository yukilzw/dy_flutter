/**
 * @discripe: 鱼吧
 */
import 'dart:ui';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../base.dart';
import 'myConcern.dart';

class FishBarHeader extends StatelessWidget with DYBase {
  final height;
  FishBarHeader({ this.height });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
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
    );
  }
}
class AnimatedLogo extends AnimatedWidget {
  AnimatedLogo({
    Key key, Animation<double> animation
  }) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return FishBarHeader(height: animation.value,);
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
      duration: Duration(milliseconds: 180),
      vsync: this
    );

    double begin = direction == -1 ? DYBase.statusBarHeight : DYBase.statusBarHeight + dp(50);
    double end = direction == -1 ? DYBase.statusBarHeight + dp(50) : DYBase.statusBarHeight;
    animation = Tween(
      begin: begin, end: end,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      )
    );

    controller.forward();
  }

  Widget build(BuildContext context) {
    return new AnimatedLogo(animation: animation);
  }

  dispose() {
    controller.dispose();
    super.dispose();
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
  int _anmiationTime = 180;
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
        return MyConcern(headerAnimated: _headerAnimated);
      case 1:
        color = Colors.lightGreen;
        break;
      case 2:
        color = Colors.pink;
        break;
    }
    return ScrollConfiguration(
      behavior: DyBehavior(),
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

    Timer(Duration(milliseconds: _anmiationTime), () {
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
            _direction == null ? FishBarHeader(height: DYBase.statusBarHeight + dp(50),) :
            LogoApp(_direction, key: ObjectKey(_direction)),
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
