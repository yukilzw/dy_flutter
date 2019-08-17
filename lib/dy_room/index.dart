/**
 * @discripe: 直播间弹幕
 */
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

import '../bloc.dart';
import '../base.dart';
import 'animate.dart' show Gift;

class DyRoomPage extends StatefulWidget {
  final arguments;
  DyRoomPage({Key key, this.arguments}) : super(key: key);

  @override
  _DyRoomPageState createState() => _DyRoomPageState(arguments);
}

class _DyRoomPageState extends State<DyRoomPage> with DYBase {
  final routeProp;
  _DyRoomPageState(this.routeProp);

  CounterBloc counterBloc;

  List msgData = [];
  List<Map> giftBannerView = [];

  Timer giftTimer, msgTimer;

  ScrollController _chatController = ScrollController();
  ChewieController _videoController;
  VideoPlayerController _videoPlayerController;

  void initState() {
    super.initState();

    _videoPlayerController = VideoPlayerController.network('${DYBase.scheme}://${DYBase.host}:${DYBase.port}/static/suen.mp4');
    _videoController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 960 / 540,
      autoPlay: true,
      looping: true,
    );

    DYhttp.post('/dy/flutter/msgData').then((res) {
      var msgDataSource = res['data'];
      var i = 0;
      msgTimer = Timer.periodic(Duration(milliseconds: 200), (timer) {
        if (i > 60) {
          _chatController.jumpTo(_chatController.position.maxScrollExtent);
          msgTimer.cancel();
          return;
        }
        setState(() {
          msgData.add(msgDataSource[Random().nextInt(msgDataSource.length)]);
        });
        _chatController.jumpTo(_chatController.position.maxScrollExtent);
        i++;
      });
    });

    DYhttp.get('/dy/flutter/giftData').then((res) {
      var giftData = res['data'];
      giftTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (giftTimer.tick > giftData.length) {
          giftTimer.cancel();
          return;
        }
        var now = DateTime.now();
        var json = {
          'stamp': now.millisecondsSinceEpoch,
          'config': giftData[giftTimer.tick - 1]
        };
        Gift.add(giftBannerView, json, 6500, (giftBannerViewNew) {
          setState(() {
            giftBannerView = giftBannerViewNew;
          });
        });
      });
    });
  }

  void dispose() {
    giftTimer?.cancel();
    msgTimer?.cancel();

    _videoPlayerController.dispose();
    _videoController.dispose();
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
    double screenWidth = MediaQuery.of(context).size.width;
    double playerHeight = screenWidth * 540 / 960;

    return Container(
      width: screenWidth,
      height: playerHeight,
      color: Color(0xff333333),
      child: _videoController != null ? Chewie(
        controller: _videoController,
      ) :
      Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          Positioned(
            child: Image.network(
              routeProp['roomSrc'],
              height: playerHeight,
            ),
          ),
          Positioned(
            child: Image.asset(
              'lib/images/play.png',
              height: dp(60),
            ),
          ),
        ],
      ),
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
            border: Border(bottom: BorderSide(color: DYBase.defaultColor, width: dp(3))),
          ),
          child: Text(
            '弹幕(${msgData.length})',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: DYBase.defaultColor,
            ),
          ),
        ),
        GestureDetector(
          onTap: () => alert(context, text: '正在建设中~'),
          child: Container(
            height: dp(40),
            padding: EdgeInsets.only(top: dp(12)),
            width: dp(60),
            child: Text(
              '主播',
              textAlign: TextAlign.center,
            ),
          ),
        ),
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
              controller: _chatController,
              padding: EdgeInsets.all(dp(10)),
              children: _chatMsg(),
            ),
            ..._setGiftBannerView()
          ],
        ),
      ),
    );
  }

  List<Widget> _setGiftBannerView() {
    List banner = <Widget>[];

    giftBannerView.forEach((item) {
      banner.add(item['widget']);
    });
    return banner;
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
                      cursorColor: DYBase.defaultColor,
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
                  GestureDetector(
                    onTap: () => alert(context, text: '正在建设中~'),
                    child: Container(
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
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => alert(context, text: '正在建设中~'),
            child: Image.asset(
              'lib/images/gift.png',
              height: dp(36),
            ),
          ),
          Padding(padding: EdgeInsets.only(right: dp(12)))
        ],
      ),
    );
  }
}