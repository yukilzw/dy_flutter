/*
 * @discripe: 弹幕区礼物横幅动画队列
 */
import 'dart:async';

import 'package:flutter/material.dart';

import '../base.dart';

// 暴露给直播间调用的礼物横幅类
class Gift extends DYBase {
  // 在礼物横幅队列中增加
  Gift.add(giftBannerView, json, removeTime, cb) {
    json['widget'] = GiftBanner(
      giftInfo: json['config'],
      queueLength: giftBannerView.length,
    );
    giftBannerView.add(json);
    cb(giftBannerView); // 将重新生成的礼物横幅队列Widget返回给直播间setState

    // 给定时间后从队列中将礼物移除
    Timer(Duration(milliseconds: removeTime), () {
      for (int i = 0; i < giftBannerView.length; i++) {
        if (json['stamp'] == giftBannerView[i]['stamp']) {
          giftBannerView.removeAt(i);
          cb(giftBannerView);
        }
      }
    });
  }
}

class GiftBanner extends StatefulWidget with DYBase {
  final Map giftInfo;
  final int queueLength;
  GiftBanner({this.giftInfo, this.queueLength});

  @override
  _GiftBannerState createState() => _GiftBannerState();
}

// 单个礼物横幅的动画Widget
class _GiftBannerState extends State<GiftBanner> with DYBase, SingleTickerProviderStateMixin {
  Animation<double> animationGiftNum_1, animationGiftNum_2, animationGiftNum_3;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    if (widget.queueLength >= 4) return;

    controller = AnimationController(
        duration: Duration(milliseconds: 1800),
        vsync: this
    );

    // 礼物数量图片变大
    animationGiftNum_1 = Tween(
      begin: 0.0, end: 1.7,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.75, 0.85,
          curve: Curves.easeOut
        ),
      )
    );

    // 礼物数量图片变小
    animationGiftNum_2 = Tween(
      begin: 1.7, end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.85, 1.0,
          curve: Curves.easeIn
        ),
      )
    );

    // 横幅从屏幕外滑入
    double an3Begin = -dp(244);
    animationGiftNum_3 = Tween(
      begin: an3Begin, end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.65, 0.85,
          curve: Curves.easeIn
        ),
      )
    );

    controller.forward();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget child) {
          return Positioned(
            left: dp(animationGiftNum_3.value),
            top: dp(45) + dp(80) * widget.queueLength,
            child: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Container(
                  height: dp(48),
                  width: dp(244),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/gift-banner.png'),
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
                            image: NetworkImage(widget.giftInfo['avatar']),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: dp(48),
                        width: dp(105),
                        child: Padding(
                          padding: EdgeInsets.all(dp(3)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.giftInfo['nickName'],
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white
                                ),
                              ),
                              RichText(
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                  style: TextStyle(color: Colors.yellow),
                                  children: [
                                    TextSpan(
                                      text: '送出',
                                    ),
                                    TextSpan(
                                      text: widget.giftInfo['giftName'],
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
                        child: Transform.scale(
                          scale: animationGiftNum_1.value >= 1.7 ? animationGiftNum_2.value : animationGiftNum_1.value,
                          child: Image.asset(
                            'images/gift-x.png',
                            height: dp(10),
                          ),
                        ),
                      ),
                      Transform.scale(
                        scale: animationGiftNum_1.value >= 1.7 ? animationGiftNum_2.value : animationGiftNum_1.value,
                        child: Image.asset(
                          'images/gift-1.png',
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
                    widget.giftInfo['giftImg'],
                    height: dp(50),
                  ),
                ),
              ],
            ),
          );
        },
        child: null,
      );
  }
}