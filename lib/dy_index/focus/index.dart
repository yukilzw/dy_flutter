/**
 * @discripe: 关注
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../base.dart';
import '../header.dart';

class FocusPage extends StatefulWidget {
  @override
  _FocusPage createState() => _FocusPage();
}

class _FocusPage extends State<FocusPage> with DYBase {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
    ));
  }

  _colorBlock() {
    List<Widget> res = [];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.transparent,
              child: Column(
                children: <Widget>[
                  DyHeader(),
                  Expanded(
                    flex: 1,
                    child: ListView(
                      padding: EdgeInsets.all(0),
                      children: <Widget>[
                        ..._colorBlock(),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ),
        ],
      ),
    );
  }
}