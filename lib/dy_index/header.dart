/**
 * @discripe: app通用头部组件
 */
import 'dart:ui';

import 'package:flutter/material.dart';

import '../base.dart';

class DyHeader extends StatelessWidget with DYBase {
  final num height;
  final num opacity;
  final BoxDecoration decoration;
  final bool gray;
  DyHeader({ this.height, this.opacity = 1.0, this.decoration, this.gray = false });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: height != null ? height : DYBase.statusBarHeight + dp(55),
      width: screenWidth,
      decoration: decoration != null ? decoration : BoxDecoration(
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
                        gray ? 'images/head/history-gray.webp' : 'images/head/history.webp',
                        width: dp(25),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: dp(10)),
                      child: Image.asset(
                        gray ? 'images/head/game-gray.webp' : 'images/head/game.webp',
                        width: dp(25),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: dp(10)),
                      child: Image.asset(
                        gray ? 'images/head/chat-gray.webp' : 'images/head/chat.webp',
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