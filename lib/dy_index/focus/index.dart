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
                ],
              ),
            )
          ),
        ],
      ),
    );
  }
}