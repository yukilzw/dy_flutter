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

  TextEditingController _nickNameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _codeController = TextEditingController();
  TextEditingController _passWordController = TextEditingController();
  int type = 2; // 1：手机号码+密码登录；2：手机号码+验证码登录；3：昵称登录
  
  @override
  void initState() {
    super.initState();
  }

  void _changePhoneLogin() {
    setState(() {
      type = type == 2 ? 1 : 2;
    });
  }

  void _changeNickNameLogin() {
    setState(() {
      type = type == 3 ? 1 : 3;
    });
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
              child: Center(
                child: Image.asset('images/back.webp',
                  width: dp(8),
                ),
              ),
            ),
          ),
          elevation: 0,
          actions: <Widget>[
            GestureDetector(
              onTap: _changeNickNameLogin,
              child: Row(
                children: <Widget>[
                  Text(type == 3 ? '手机登录' : '昵称登录'),
                  Padding(padding: EdgeInsets.only(left: dp(20)),)
                ],
              ),
            )
          ],
        ),
        preferredSize: Size.fromHeight(dp(55)),
      ),
      backgroundColor: Color(0xffeeeeee),
      body: Padding(
        padding: EdgeInsets.all(18),
        child: Column(
          children: <Widget>[
            type != 3 ? Container(
              height: dp(40),
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
            ) : SizedBox(),
            type != 3 ? Padding(padding: EdgeInsets.only(top: dp(18)),) : SizedBox(),
            type != 3 ? Container(
              height: dp(40),
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
                          controller: _mobileController,
                          inputFormatters:  [
                            WhitelistingTextInputFormatter(RegExp(r'[0-9]')),
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
            ) : Container(
              height: dp(40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: dp(20), right: dp(20)),
                child: Row(
                  children: <Widget>[
                    Image.asset('images/login/member.webp',
                      height: dp(20),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: TextField(
                          controller: _nickNameController,
                          inputFormatters:  [
                            WhitelistingTextInputFormatter(RegExp(r'[0-9]')),
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
                            hintText: '昵称/用户名（5-30位字符）',
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
              height: dp(40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: type == 2 ? Padding(
                padding: EdgeInsets.only(left: dp(20), right: dp(5)),
                child: Row(
                  children: <Widget>[
                    Image.asset('images/login/safe.webp',
                      height: dp(20),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: TextField(
                          controller: _codeController,
                          inputFormatters:  [
                            LengthLimitingTextInputFormatter(6),
                            WhitelistingTextInputFormatter(RegExp(r'[0-9]')),
                          ],
                          cursorColor: DYBase.defaultColor,
                          cursorWidth: 1.5,
                          style: TextStyle(
                            color: Color(0xff333333),
                            fontSize: 14.0,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: dp(15), top: dp(3), bottom: dp(3)),
                            hintText: '请输入验证码',
                          ),
                        ),
                      ),
                    ),
                    RawMaterialButton(
                      constraints: BoxConstraints(maxHeight: dp(30), minWidth: dp(100)),
                      fillColor: Color(0xffff7701),
                      elevation: 0,
                      highlightElevation: 0,
                      highlightColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      onPressed: () {},
                      child: Center(
                        child: Text('短信验证',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ) : Padding(
                padding: EdgeInsets.only(left: dp(20), right: dp(20)),
                child: Row(
                  children: <Widget>[
                    Image.asset('images/login/lock.webp',
                      height: dp(20),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: TextField(
                          controller: _passWordController,
                          inputFormatters:  [
                            BlacklistingTextInputFormatter(RegExp(r'[\u4e00-\u9fa5]')),
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
            Padding(padding: EdgeInsets.only(top: dp(30)),),
            RawMaterialButton (
              constraints: BoxConstraints(minHeight: 40),
              fillColor: Color(0xffff7701),
              elevation: 0,
              highlightElevation: 0,
              highlightColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              onPressed: () {},
              child: Center(
                child: Text('登录',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
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
                GestureDetector(
                  onTap: _changePhoneLogin,
                  child: Text(type == 2 ? '手机密码登录' : '手机验证码快捷登录',
                    style: TextStyle(
                      color: Color(0xffff7701),
                    ),
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
