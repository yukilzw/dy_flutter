/**
 * @discripe: 登录注册页
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../base.dart';

class DyLoginPage extends StatefulWidget {
  final arguments;
  DyLoginPage({Key key, this.arguments}) : super(key: key);
  
  @override
  _DyLoginPage createState() => _DyLoginPage(arguments);
}
  
class _DyLoginPage extends State<DyLoginPage> with DYBase {
  final _routeProp;
  _DyLoginPage(this._routeProp);
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: DYBase.dessignWidth)..init(context);
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          title:Text('手机登录'),
          titleSpacing: 0,
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          leading: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              color: Colors.white,
              child: Icon(
                Icons.arrow_back_ios,
                color: Color(0xff939393),
              ),
            ),
          ),
          elevation: 0,
          iconTheme: IconThemeData(size: dp(20)),
          textTheme: TextTheme(
            title: TextStyle(
              color: Color(0xff333333),
              fontSize: 18,
            ),
          ),
          actions: <Widget>[
            Row(
              children: <Widget>[
                Text('昵称登录'),
                Padding(padding: EdgeInsets.only(left: dp(20)),)
              ],
            ),
          ],
        ),
        preferredSize: Size.fromHeight(dp(55)),
      ),
      backgroundColor: Color(0xffeeeeee),
      body: Padding(
        padding: EdgeInsets.all(18),
        child: Column(
          children: <Widget>[
            Container(
              height: dp(46),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: dp(20), right: dp(20)),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Text('国家与地区',
                        style: TextStyle(
                          color: Color(0xff9b9b9b),
                        ),
                      ),
                    ),
                    Text('中国大陆'),
                    Padding(padding: EdgeInsets.only(left: dp(10)),),
                    Image.asset('images/show-area.webp',
                      height: dp(16),
                    ),
                  ],
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: dp(18)),),
            Container(
              height: dp(46),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: Padding(
                padding: EdgeInsets.only(right: dp(20)),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Text('+86',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xffff7701)),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(left: BorderSide(color: Color(0xff999999), width: dp(1))),
                        ),
                        child: TextField(
                          inputFormatters:  [
                            WhitelistingTextInputFormatter(RegExp('[0-9]')),
                          ],
                          keyboardType: TextInputType.number,
                          cursorColor: DYBase.defaultColor,
                          cursorWidth: 1.5,
                          style: TextStyle(
                            color: Color(0xff333333),
                            fontSize: 14.0,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: dp(15), top: dp(3), bottom: dp(3)),
                            hintText: '请输入手机号',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: dp(18)),),
            Container(
              height: dp(46),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: dp(20), right: dp(20)),
                child: Row(
                  children: <Widget>[
                    Image.asset('images/lock.webp',
                      height: dp(20),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: TextField(
                          inputFormatters:  [
                            WhitelistingTextInputFormatter(RegExp('[^\u4e00-\u9fa5]')),
                          ],
                          obscureText: true,
                          cursorColor: DYBase.defaultColor,
                          cursorWidth: 1.5,
                          style: TextStyle(
                            color: Color(0xff333333),
                            fontSize: 14.0,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: dp(15), top: dp(3), bottom: dp(3)),
                            hintText: '请输入密码',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: dp(40)),),
            RawMaterialButton (
              fillColor: Color(0xffff7701),
              elevation: 0,
              highlightElevation: 0,
              highlightColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              onPressed: () {},
              child: Container(
                height: dp(50),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(dp(5))),
                ),
                child: Center(
                  child: Text('登录',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: dp(10)),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('忘记密码？',
                  style: TextStyle(
                    color: Color(0xff999999),
                  ),
                ),
                Text('手机验证码快捷登录',
                  style: TextStyle(
                    color: Color(0xffff7701),
                  ),
                ),
                Text('快速注册',
                  style: TextStyle(
                    color: Color(0xffff7701),
                    decorationStyle: TextDecorationStyle.solid,
                    decorationColor: Color(0xffff7701),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
