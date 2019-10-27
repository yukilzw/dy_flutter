/**
 * @discripe: 鱼吧
 */
import 'dart:ui';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../base.dart';
import 'myConcern.dart';

int _headerAnimationTime = 250;

class FishBarHeader extends StatelessWidget with DYBase {
  final height, opacity;
  FishBarHeader({ this.height, this.opacity = 1.0 });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: height != null ? height : DYBase.statusBarHeight + dp(55),
      width: screenWidth,
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
            bottom: dp(10),
            child: Opacity(
              opacity: opacity,
              child: SizedBox(
                width: screenWidth - dp(30),
                height: dp(40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(dp(20)),
                      ),
                      child: Image.asset(
                        'images/default-avatar.webp',
                        width: dp(40),
                        height: dp(40),
                        fit: BoxFit.fill,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: dp(35),
                        margin: EdgeInsets.only(left: dp(15)),
                        padding: EdgeInsets.only(left: dp(5), right: dp(5)),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(dp(35 / 2)),
                          ), 
                        ),
                        child: Row(
                          children: <Widget>[
                            // 搜索ICON
                            Image.asset(
                              'images/head/search.webp',
                              width: dp(25),
                              height: dp(15),
                            ),
                            // 搜索输入框
                            Expanded(
                              flex: 1,
                              child: TextField(
                                cursorColor: DYBase.defaultColor,
                                cursorWidth: 1.5,
                                style: TextStyle(
                                  color: DYBase.defaultColor,
                                  fontSize: 14.0,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(0),
                                  hintText: '金咕咕doinb',
                                ),
                              ),
                            ),
                            Image.asset(
                              'images/head/camera.webp',
                              width: dp(20),
                              height: dp(15),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: dp(10)),
                      child: Image.asset(
                        'images/head/history.webp',
                        width: dp(25),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: dp(10)),
                      child: Image.asset(
                        'images/head/game.webp',
                        width: dp(25),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: dp(10)),
                      child: Image.asset(
                        'images/head/chat.webp',
                        width: dp(25),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
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
    _heightTween= Tween(
      begin: beginH, end: endH,
    );
    _opacityTween= Tween(
      begin: beginO, end: endO,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return FishBarHeader(height: _heightTween.evaluate(animation), opacity: _opacityTween.evaluate(animation),);
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

  Widget build(BuildContext context) {
    return AnimatedLogo(animation: animation, direction: direction);
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
            _direction == null ? FishBarHeader() :
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
