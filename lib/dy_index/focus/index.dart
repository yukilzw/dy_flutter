/*
 * @discripe: 关注
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../service.dart';
import '../../base.dart';
import '../header.dart';

/// 该页头部为自定义手势实现的与斗鱼安卓APP相同效果，而不是像首页那样直接调用Flutter封装好的[AppBar]的交互。

/// 头部[AnimatedBuilder]动画封装
class AnimatedHeader extends StatefulWidget {
  final Key key;
  final Tween<double> opacityTween, heightTween;
  final Function cb;
  AnimatedHeader({
    this.key,
    this.opacityTween,
    this.heightTween,
    this.cb,
  });

  @override
  _AnimatedHeader createState() => _AnimatedHeader();
}

class _AnimatedHeader extends State<AnimatedHeader> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;

  @override
  initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(milliseconds: 250),
      vsync: this
    );
    animation = CurvedAnimation(parent: controller, curve: Curves.easeOut);
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.cb();
      }
    });
    controller.forward();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext ctx, Widget child) {
        return DyHeader(height: widget.heightTween.evaluate(animation), opacity: widget.opacityTween.evaluate(animation),);
      },
    );
  }
}

// 页面总结构
class FocusPage extends StatefulWidget with DYBase {
  double headerHeightMax;
  FocusPage() {
    headerHeightMax =  DYBase.statusBarHeight + dp(55);
  }

  @override
  _FocusPage createState() => _FocusPage(headerHeightMax);
}

class _FocusPage extends State<FocusPage> with DYBase, TickerProviderStateMixin {
  double _headerHeight;
  double _headerOpacity = 1.0;
  Tween<double> _opacityTween, _heightTween;
  bool _isAnimating = false;
  PointerDownEvent _pointDownEvent;

  _FocusPage(this._headerHeight);

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
    ));
  }

  List<Widget> _colorBlock() {
    var res = <Widget>[];
    for (var i = 0; i < 8; i++) {
      res.add(Container(
        margin: EdgeInsets.only(top: dp(20), left: dp(20), right: dp(20)),
        height: dp(120),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          border: Border.all(width: dp(2), color: DYBase.defaultColor),
        ),
        child: Center(
          child: Text(
            (i + 1).toString(),
            style: TextStyle(
              color: DYBase.defaultColor,
              fontSize: dp(38),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ));
    }

    return res;
  }

  void _onPointerMove(PointerMoveEvent e) {
    var nextHeight = _headerHeight + e.delta.dy;

    if (nextHeight <= DYBase.statusBarHeight || nextHeight >= widget.headerHeightMax) {
      return;
    }
    setState(() {
      _headerHeight = nextHeight;
      _headerOpacity = (nextHeight - DYBase.statusBarHeight) / dp(55);
    });
  }

  void _onPointerDown(PointerDownEvent e) {
    _pointDownEvent = e;
  }

  void _onPointerUp(PointerUpEvent e) {
    double headerHeightNow = _headerHeight,
          headerOpacityNow = _headerOpacity,
          direction;  // header动画方向，1-展开；0-收起

    // 快速滚动捕获，触摸松开间隔小于300ms直接根据滚动方向伸缩header
    if (
      (_pointDownEvent != null) && 
      (e.timeStamp.inMilliseconds - _pointDownEvent.timeStamp.inMilliseconds < 300)
    ) {
      if (e.position.dy > _pointDownEvent.position.dy) {
        direction = 1;
      } else {
        direction = 0;
      }
    }
    // 滚动松开时header高度一半以下收起
    else if (_headerHeight < (widget.headerHeightMax / 2 + dp(15))) {
      direction = 0;
    }
    // 超过一半就完展开
    else {
      direction = 1;
    }

    setState(() {
      if (direction == 0) {
        _headerHeight = DYBase.statusBarHeight;
        _headerOpacity = 0;
      } else {
        _headerHeight = widget.headerHeightMax;
        _headerOpacity = 1;
      }
      _heightTween = Tween(
        begin: headerHeightNow, end: _headerHeight,
      );
      _opacityTween = Tween(
        begin: headerOpacityNow, end: _headerOpacity,
      );
      _isAnimating = true;
    });
  }

  void _animateEndCallBack() {
    setState(() {
      _isAnimating = false;
    });
  }

  /// 在[ListView]之上无法通过[GestureDetector]进行手势捕获，因为部分手势（如上下滑）会提前被[ListView]所命中。
  /// 所以在整个页面的最外层使用底层[Listener]监听原始触摸事件，判断手势需要自己取坐标计算。
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Listener(
        onPointerDown: _onPointerDown,
        onPointerUp: _onPointerUp,
        onPointerMove: _onPointerMove,
        child:Column(
          children: <Widget>[
            _isAnimating ? AnimatedHeader(
              key: ObjectKey(_isAnimating),
              opacityTween: _opacityTween,
              heightTween: _heightTween,
              cb: _animateEndCallBack,
            ) : DyHeader(height: _headerHeight, opacity: _headerOpacity,),
            Expanded(
              flex: 1,
              child: ScrollConfiguration(
                behavior: DyBehaviorNull(),
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.all(0),
                  children: _colorBlock(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}