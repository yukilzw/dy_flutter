import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'base.dart' show DYBase;
import 'config.dart' as config;

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
          _nav(),
          _chat(),
          _bottom(),
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

  Widget _nav() {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        new Container(
          height: dp(40),
          padding: EdgeInsets.only(top: dp(12)),
          width: dp(60),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xffff5d23), width: dp(3))),
          ),
          child: new Text(
            '弹幕',
            textAlign: TextAlign.center,
            style: new TextStyle(
              color: Color(0xffff5d23),
            ),
          ),
        ),
        new Container(
          height: dp(40),
          padding: EdgeInsets.only(top: dp(12)),
          width: dp(60),
          child: new Text(
            '主播',
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }

  Widget _chat() {
    return new Expanded(
      flex: 1,
      child: new Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0xffeeeeee), width: dp(1)),
            bottom: BorderSide(color: Color(0xffeeeeee), width: dp(1))
          ),
        ),
        child: new ListView(
          padding: EdgeInsets.all(dp(10)),
          children: _chatMsg(),
        ),
      ),
    );
  }

  _chatMsg () {
    var msgList = new List<Widget>();

    config.msgData.forEach((item) {
      var isAdmin = item['lv'] > 0;
      var msgBoart = <Widget>[
        RichText(
          text: TextSpan(
            style: TextStyle(color: Color(0xff666666), fontSize: 16.0),
            children: [
              new TextSpan(
                text: '''${isAdmin ? '''          ''' : ''}${item['name']}: ''',
                style: TextStyle(
                  color: !isAdmin ? Colors.red : Color(0xff999999)
                ),
              ),
              new TextSpan(
                text: item['text'],
              ),
            ]
          ),       
        ),
      ];

      if (item['lv'] > 0) {
        msgBoart.insert(0, new Positioned(
          child: new Image.asset(
            'lib/images/lv/${item['lv']}.png',
            height: dp(18),
          ),
        ));
      }

      msgList.addAll([
        new Stack(
          children: msgBoart,
        ),
        Padding(padding: EdgeInsets.only(bottom: dp(5)))
      ]);
    });

    return msgList;
  }

  Widget _bottom() {
    return new SizedBox(
      height: dp(50),
      child: new Row(
        children: <Widget>[
          new Expanded(
            flex: 1,
            child: new Container(
              margin: EdgeInsets.only(left: dp(12), right: dp(12)),
              padding: EdgeInsets.only(left: dp(10), right: dp(10)),
              height: dp(36),
              decoration: BoxDecoration(
                color: Color(0xfff7f7f7),
                borderRadius: BorderRadius.all(
                  Radius.circular(dp(8)),
                ),
              ),
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    flex: 1,
                    child: new TextField(
                      cursorColor: Color(0xffff5d23),
                      cursorWidth: 1.5,
                      style: TextStyle(
                        color: Color(0xff333333),
                        fontSize: 14.0,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(0),
                        hintText: '吐个槽呗~',
                      ),
                    ),
                  ),
                  new Container(
                    width: dp(40),
                    height: dp(26),
                    padding: EdgeInsets.only(top: dp(5)),
                    margin: EdgeInsets.only(left: dp(10)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(dp(4))),
                      gradient: LinearGradient(
                        begin: const Alignment(-1.2, 0.0),
                        end: const Alignment(0.2, 0.0),
                        colors: <Color>[
                          const Color(0xffff4e00),
                          const Color(0xffff8b00),
                        ],
                      ),
                    ),
                    child: new Text(
                      '发送',
                      style: new TextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          new Image.asset(
            'lib/images/gift.png',
            height: dp(36),
          ),
          Padding(padding: EdgeInsets.only(right: dp(12)))
        ],
      ),
    );
  }
}