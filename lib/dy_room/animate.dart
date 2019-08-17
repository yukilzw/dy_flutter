/**
 * @discripe: 弹幕区礼物横幅动画队列
 */
import 'dart:async';

import 'package:flutter/material.dart';

import '../base.dart';

class Gift extends DYBase {
  Gift.add(giftBannerView, json, removeTime, cb) {
    json['widget'] = Positioned(
      left: dp(0),
      top: dp(45) + dp(80) * giftBannerView.length,
      child: GiftBanner(
        giftInfo: json['config'],
        queueLength: giftBannerView.length,
      ),
    );
    giftBannerView.add(json);
    cb(giftBannerView);

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
  final Widget child;
  final int queueLength;
  GiftBanner({this.giftInfo, this.child, this.queueLength});

  @override
  _GiftBannerState createState() => _GiftBannerState(
    giftInfo: giftInfo, child: child, queueLength: queueLength
  );
}

class _GiftBannerState extends State<GiftBanner> with DYBase, SingleTickerProviderStateMixin {
  Animation<double> animationGiftNum_1, animationGiftNum_2, animationGiftNum_3;
  AnimationController controller;

  final Widget child;
  final Map giftInfo;

  int queueLength;

  _GiftBannerState({
    this.child,
    @required this.giftInfo,
    @required this.queueLength,
  }) {
    if (queueLength >= 4) return;

    controller = AnimationController(
        duration: Duration(milliseconds: 1800),
        vsync: this
    );

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

  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget child) {
        return Transform.translate(
          offset: Offset(animationGiftNum_3.value, 0),
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
                          image: NetworkImage(giftInfo['avatar']),
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
                              giftInfo['nickName'],
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
                                    text: giftInfo['giftName'],
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
                          'lib/images/gift-x.png',
                          height: dp(10),
                        ),
                      ),
                    ),
                    Transform.scale(
                      scale: animationGiftNum_1.value >= 1.7 ? animationGiftNum_2.value : animationGiftNum_1.value,
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
                  giftInfo['giftImg'],
                  height: dp(50),
                ),
              ),
            ],
          ),
        );
      },
      child: child,
    ),
    );
  }
}