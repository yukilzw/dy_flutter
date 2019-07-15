import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'base.dart' show DYBase;

class DyRoomPage extends StatefulWidget {
  final arguments;
  DyRoomPage({Key key, this.arguments}) : super(key: key);

  @override
  _DyRoomPageState createState() {
    return new _DyRoomPageState(arguments);
  }
}

class _DyRoomPageState extends State<DyRoomPage> with DYBase {
  final routeProp;
  _DyRoomPageState(this.routeProp);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: DYBase.dessignWidth)..init(context);

    return Scaffold(
      body: new Column(
        children: <Widget>[
          _livePlayer(),
          _chat(),
        ],
      ),
    );
  }

  Widget _livePlayer() {
    return new Container(
      width: MediaQuery.of(context).size.width,
      height: dp(206),
      color: Color(0xff333333),
      child: new Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          new Positioned(
            child: new Image.network(
              routeProp['roomSrc'],
              height: dp(206),
            ),
          ),
          new Positioned(
            child: new Image.asset(
              'lib/images/play.png',
              height: dp(60),
            ),
          ),
        ],
      )
    );
  }

  Widget _chat() {
    return new Expanded(
      flex: 1,
      child: new Container(

      ),
    );
  }

}