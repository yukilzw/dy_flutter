/**
 * @discripe: 通用弹窗
 */
import 'package:flutter/material.dart';

import 'base.dart';

class LoadingDialog extends Dialog with DYBase {
  final String text;

  LoadingDialog({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: SizedBox(
          width: dp(120),
          height: dp(120),
          child: Container(
            decoration: ShapeDecoration(
              color: Color(0xffffffff),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                Padding(
                  padding: EdgeInsets.only(
                    top: dp(20),
                  ),
                  child: Text(
                    text,
                    style: TextStyle(fontSize: 12.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginDialog extends Dialog with DYBase {
  LoginDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: dp(320),
            height: dp(400),
            color: Colors.white,
            child: OverflowBox(
              alignment: Alignment.bottomCenter,
              maxHeight: dp(500),
              child: Stack(
                alignment: AlignmentDirectional.topCenter,
                children: <Widget>[
                  Positioned(
                    child: Image.asset(
                      'images/syn.webp',
                      width: dp(220),
                    ),
                  ),
                  Column(
                    children: <Widget>[

                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}