import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'bloc.dart';
import 'base.dart' show DYBase, DYhttp;

class DyRoomPage extends StatefulWidget {
  final arguments;
  DyRoomPage({Key key, this.arguments}) : super(key: key);

  @override
  _DyRoomPageState createState() {
    return _DyRoomPageState(arguments);
  }
}

class _DyRoomPageState extends State<DyRoomPage> with DYBase, SingleTickerProviderStateMixin {
  final routeProp;
  _DyRoomPageState(this.routeProp);

  CounterBloc counterBloc;

  List msgData = [];

  Animation<double> animationGiftNum_1, animationGiftNum_2;
  AnimationController controllerGiftNum;

  void initState() {
    super.initState();
    DYhttp.post('/dy/flutter/msgData').then((res) {
      setState(() {
        msgData = res['data']; 
      });
    });

    controllerGiftNum = AnimationController(
        duration: Duration(milliseconds: 800),
        vsync: this
    );

    animationGiftNum_1 = Tween(
      begin: 0.0, end: 1.7,
    ).animate(
      CurvedAnimation(
        parent: controllerGiftNum,
        curve: Interval(
          0.0, 0.6,
          curve: Curves.easeOut
        ),
      )
    );

    animationGiftNum_2 = Tween(
      begin: 1.7, end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: controllerGiftNum,
        curve: Interval(
          0.6, 1.0,
          curve: Curves.easeIn
        ),
      )
    );

    controllerGiftNum.forward();
  }

  void dispose() {
    //路由销毁时需要释放动画资源
    controllerGiftNum.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: DYBase.dessignWidth)..init(context);
    counterBloc = BlocProvider.of<CounterBloc>(context);

    return Scaffold(
       body: BlocBuilder<CounterEvent, int>(
        bloc: counterBloc,
        builder: (BuildContext context, int count) {
          return Column(
            children: <Widget>[
              _livePlayer(),
              _nav(count),
              _chat(),
              _bottom(),
            ],
          );
        },
      ),
    );
  }

  Widget _livePlayer() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: dp(206),
      color: Color(0xff333333),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          Positioned(
            child: Image.network(
              routeProp['roomSrc'],
              height: dp(206),
            ),
          ),
          Positioned(
            child: Image.asset(
              'lib/images/play.png',
              height: dp(60),
            ),
          ),
        ],
      )
    );
  }

  Widget _nav(count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Container(
          height: dp(40),
          padding: EdgeInsets.only(top: dp(12)),
          width: dp(60),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xffff5d23), width: dp(3))),
          ),
          child: Text(
            '弹幕($count)',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xffff5d23),
            ),
          ),
        ),
        Container(
          height: dp(40),
          padding: EdgeInsets.only(top: dp(12)),
          width: dp(60),
          child: Text(
            '主播',
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }

  Widget _chat() {
    return Expanded(
      flex: 1,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0xffeeeeee), width: dp(1)),
            bottom: BorderSide(color: Color(0xffeeeeee), width: dp(1))
          ),
        ),
        child: Stack(
          children: <Widget>[
            ListView(
              padding: EdgeInsets.all(dp(10)),
              children: _chatMsg(),
            ),
            Positioned(
              left: dp(0),
              top: dp(45),
              child: Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Container(
                    height: dp(48),
                    width: dp(244),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('lib/images/gift-banner.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: dp(40),
                          height: dp(40),
                          margin: EdgeInsets.only(left: dp(4)),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: NetworkImage(routeProp['avatar']),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: dp(48),
                          width: dp(105),
                          child: Padding(
                            padding: EdgeInsets.all(dp(5)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  routeProp['nickname'],
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(color: Colors.yellow),
                                    children: [
                                      TextSpan(
                                        text: '送出',
                                      ),
                                      TextSpan(
                                        text: '飞机',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic
                                        ),
                                      ),
                                    ]
                                  ),       
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(right: dp(50))),
                        Padding(
                          padding: EdgeInsets.only(top: dp(10)),
                          child: GiftNumTransition(
                            animationList: [animationGiftNum_1, animationGiftNum_2],
                            controller: controllerGiftNum,
                            child: Image.asset(
                              'lib/images/gift-x.png',
                              height: dp(10),
                            ),
                          ),
                          ),
                        GiftNumTransition(
                          animationList: [animationGiftNum_1, animationGiftNum_2],
                          controller: controllerGiftNum,
                          child: Image.asset(
                            'lib/images/gift-1.png',
                            height: dp(30),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: dp(145),
                    top: dp(-15),
                    child: Image.network(
                      'http://m.qpic.cn/psb?/V14dALyK4PrHuj/8WI1OXFOx1HnUQccFLNhp5lrP9pt.TMI0McJ9HJniKM!/b/dL8AAAAAAAAA',
                      height: dp(50),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _chatMsg() {
    var msgList = List<Widget>();

    msgData.forEach((item) {
      var isAdmin = item['lv'] > 0;
      var msgBoart = <Widget>[
        RichText(
          text: TextSpan(
            style: TextStyle(color: Color(0xff666666), fontSize: 16.0),
            children: [
              TextSpan(
                text: '''${isAdmin ? '''          ''' : ''}${item['name']}: ''',
                style: TextStyle(
                  color: !isAdmin ? Colors.red : Color(0xff999999)
                ),
              ),
              TextSpan(
                text: item['text'],
              ),
            ]
          ),       
        ),
      ];

      if (item['lv'] > 0) {
        msgBoart.insert(0, Positioned(
          child: Image.asset(
            'lib/images/lv/${item['lv']}.png',
            height: dp(18),
          ),
        ));
      }

      msgList.addAll([
        Stack(
          children: msgBoart,
        ),
        Padding(padding: EdgeInsets.only(bottom: dp(5)))
      ]);
    });

    return msgList;
  }

  Widget _bottom() {
    return SizedBox(
      height: dp(50),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.only(left: dp(12), right: dp(12)),
              padding: EdgeInsets.only(left: dp(10), right: dp(10)),
              height: dp(36),
              decoration: BoxDecoration(
                color: Color(0xfff7f7f7),
                borderRadius: BorderRadius.all(
                  Radius.circular(dp(8)),
                ),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: TextField(
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
                  Container(
                    width: dp(40),
                    height: dp(26),
                    padding: EdgeInsets.only(top: dp(5)),
                    margin: EdgeInsets.only(left: dp(10)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(dp(4))),
                      gradient: LinearGradient(
                        begin: Alignment(-1.2, 0.0),
                        end: Alignment(0.2, 0.0),
                        colors: <Color>[
                          Color(0xffff4e00),
                          Color(0xffff8b00),
                        ],
                      ),
                    ),
                    child: Text(
                      '发送',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Image.asset(
            'lib/images/gift.png',
            height: dp(36),
          ),
          Padding(padding: EdgeInsets.only(right: dp(12)))
        ],
      ),
    );
  }
}

class AnimatedImage extends AnimatedWidget {
  AnimatedImage({Key key, Animation animation, this.child})
      : super(key: key, listenable: animation);

  final Widget child;

  Widget build(BuildContext context) {
    final Animation animation = listenable;
    return Transform.translate(
      offset: Offset(animation.value, 0),
      child: child,
    );
  }
}

class GiftNumTransition extends StatelessWidget with DYBase {
  GiftNumTransition({this.child, this.animationList, this.controller});

  final Widget child;
  final List<Animation<double>> animationList;
  final AnimationController controller;

  Widget build(BuildContext context) {
    return new Center(
      child: new AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget child) {
          return Transform.scale(
            scale: animationList[0].value >= 1.7 ? animationList[1].value : animationList[0].value,
            child: child,
          );
        },
        child: child,
      ),
    );
  }
}