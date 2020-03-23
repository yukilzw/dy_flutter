/**
 * @discripe: 关注
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../base.dart';
import '../header.dart';

class FocusPage extends StatefulWidget with DYBase {
  double headerHeightMax;
  FocusPage() {
    headerHeightMax =  DYBase.statusBarHeight + dp(55);
  }

  @override
  _FocusPage createState() => _FocusPage(headerHeightMax);
}

class _FocusPage extends State<FocusPage> with DYBase {
  double _headerHeight;
  double _headerOpacity = 1.0;

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

    if (nextHeight <= DYBase.statusBarHeight || nextHeight >= (DYBase.statusBarHeight + dp(55))) {
      return;
    }
    setState(() {
      _headerHeight = nextHeight;
      _headerOpacity = (nextHeight - DYBase.statusBarHeight) / dp(55);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Listener(
              onPointerMove: _onPointerMove,
              child: Container(
                color: Colors.transparent,
                child: Stack(
                  children: <Widget>[
                    ListView(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.all(0),
                      children: <Widget>[
                        Padding(padding: EdgeInsets.only(top: widget.headerHeightMax)),
                        ..._colorBlock(),
                      ],
                    ),
                    DyHeader(height: _headerHeight, opacity: _headerOpacity,),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}