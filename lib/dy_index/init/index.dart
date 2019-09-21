/**
 * @discripe: 载入APP启动页
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../base.dart';
import 'countdown.dart';
import 'wave.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);
  
  @override
  _SplashPageState createState() => _SplashPageState();
}
  
class _SplashPageState extends State<SplashPage> with DYBase, SingleTickerProviderStateMixin  {
  SharedPreferences prefs;
  
  @override
  void initState() {
    super.initState();
    _initAsync();
  }
  
  void _initAsync() async {
    // App启动时读取Sp数据，需要异步等待Sp初始化完成。
    prefs = await SharedPreferences.getInstance();
  }
  
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: DYBase.dessignWidth)..init(context);
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: <Widget>[
            Positioned(
              right: dp(25),
              top: dp(25),
              child: CountdownInit(),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: dp(70)),),
                Image.asset(
                  'images/init_logo.webp',
                  width: dp(300),
                ),
                Padding(padding: EdgeInsets.only(top: dp(70)),),
                Image.asset(
                  'images/init_icon.png',
                  width: dp(90),
                ),
                WaveBtoom(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
