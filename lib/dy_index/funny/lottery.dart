/*
 * @discripe: 九宫格抽奖
 */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../base.dart';
import '../../service.dart';

class Lottery extends StatefulWidget {
  static final List lotteryInOrder = <int>[0, 1, 2, 5, 8, 7, 6, 3];   // 九宫格奖品顺序对应Widget索引
  static final int roundBase = 2;   // 九宫格匀速转动的基础圈数
  static final int slowStep = 7;    // 在转到奖品前缓速的步数
  static final double slowMultiple = 1.7;   // 每次缓速间隔时间的倍率

  @override
  _Lottery createState() => _Lottery();
}

class _Lottery extends State<Lottery> with DYBase {
  Map lotteryConfig;    // 从服务端获取的抽奖UI配置信息
  int runCount;    // 九宫格转动时的次数累计
  Timer timer;     // 转动时的计时器
  Map lotteryResult;    // 服务端返回的抽奖结果
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    // 请求抽奖UI配置渲染
    httpClient.get(
      API.lotteryConfig,
    ).then((res) {
      if (mounted)
      setState(() {
        lotteryConfig = res.data['data']; 
      });
    });
  }

  // 点击开始抽奖
  void _startLottery() {
    // 防止重复点击
    if (timer != null) {
      return;
    }
    // 初始化九宫格抽奖
    if (mounted)
    setState(() {
      runCount = 0;
      lotteryResult = null;
    });
    // 开始计时器转动
    _lotteryTimer();
    // 同时请求抽奖结果
    httpClient.post(
      API.lotteryResult,
    ).then((res) {
      if (mounted)
      setState(() {
        lotteryResult = res.data['data']; 
      });
    });
  }

  // 九宫格匀速计时器
  void _lotteryTimer() {
    timer = Timer(Duration(milliseconds: 100), () {
      if (mounted)
      setState(() {
        runCount++;
      });
      if (runCount <= 8 * Lottery.roundBase) {  // 首先转动基础圈数，这个时候顺便等待抽奖接口异步结果
        _lotteryTimer();
      } else if (
        runCount <= 8 * (Lottery.roundBase + 1) + lotteryResult['giftIndex'] - Lottery.slowStep
      ) { // 转满基础圈数后，计算出多转一圈 + 结果索引 - 缓速步数，进行最后几步的匀速转动
        _lotteryTimer();
      } else {  // 匀速结果，进入开奖前缓速转动
        _slowLotteryTimer(100);
      }
    });
  }

  // 九宫格缓速计时器
  void _slowLotteryTimer(ms) {
    timer = Timer(Duration(milliseconds: ms), () {
      if (mounted)
      setState(() {
        runCount++;
      });
      if (runCount < 8 * (Lottery.roundBase + 1) + lotteryResult['giftIndex'])
      { // 如果当前步数没有达到结果位置，继续缓速转动，并在下一步增长缓速时间，实现越来越慢的开奖效果
        _slowLotteryTimer((ms * Lottery.slowMultiple).ceil());
      } else {  // 已转到开奖位置，弹窗提醒
        if (lotteryResult['giftIndex'] == 3) {
          DYdialog.alert(context, title: '很遗憾~', text: '谢谢参与',
            yesCallBack: () => {
              if (mounted)
              setState(() {
                runCount = null;
              })
            },
          );
        } else {
          var title = '中奖了！',
              body = '恭喜您获得 ${lotteryResult['giftName']}';
          DYdialog.alert(context, title: title, text: body,
            yesCallBack: () => {
              if (mounted)
              setState(() {
                runCount = null;
              })
            },
          );
          _showNotification(title, body);
        }
        timer?.cancel();
        timer = null;
      }
    });
  }

  // 系统通知栏消息推送
  void _showNotification(String title, String body) async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/dy');
    var initializationSettingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: (int id, String title, String body, String payload) async => null);
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (String payload) async {
      if (payload != null) {
        print('notification payload: ' + payload);
      }
      // 点击通知栏跳转的页面(暂为空白)
      // await Navigator.push(
      //   context,
      //   new MaterialPageRoute(builder: (context) => Container(color: Colors.white,)),
      // );
    });

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '0', title, body,
      importance: Importance.max, priority: Priority.high, ticker: 'ticker',
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      DYservice.randomBit(8, type: 'num'), title, body, platformChannelSpecifics,
      payload: body
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: DYBase.dessignWidth)..init(context);
    return Container(
      child: lotteryConfig == null ? null : Card(
        elevation: 5,
        margin: EdgeInsets.all(dp(20)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(dp(25)),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        color: Color(0xffff9434),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Container(
              height: dp(lotteryConfig['pageH']),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(lotteryConfig['pageBg']),
                  fit: BoxFit.fill,
                ),
              ),
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: <Widget>[
                  Positioned(
                    bottom: 0,
                    child:  Transform.scale(
                      scale: 0.9,
                      child: Container(
                        width: dp(lotteryConfig['lotteryW']),
                        height: dp(lotteryConfig['lotteryH']),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(lotteryConfig['lotteryBg']),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Wrap(
                          children: _renderLotteryItem(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () => DYdialog.alert(context, text: '正在建设中~'),
                  child: Container(
                    width: dp(lotteryConfig['myRewardW']),
                    height: dp(lotteryConfig['myRewardH']),
                    margin: EdgeInsets.only(bottom: dp(10)),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(lotteryConfig['myRewardBg']),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _renderLotteryItem() {
    var inOrder = Lottery.lotteryInOrder,
        height = dp(lotteryConfig['lotteryH'] / 3),
        width = dp(lotteryConfig['lotteryW'] / 3);
    return List(9).asMap().map((i, item) {
      if (i == 4) {
        return MapEntry(i, GestureDetector(
            onTap: _startLottery,
            child: Container(
              width: width, height: height,
              color: Colors.transparent,
            ),
          ),
        );
      }
      return MapEntry(i, Container(
        width: width, height: height,
        decoration: runCount != null && i == inOrder[runCount % inOrder.length] ? BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(lotteryConfig['highLightBg']),
            fit: BoxFit.fill,
          ),
        ) : null,
      ));
    }).values.toList();
  }
}