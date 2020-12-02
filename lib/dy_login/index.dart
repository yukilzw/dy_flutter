/*
 * @discripe: 登录注册页
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';

import '../base.dart';
import '../service.dart';
import 'area.dart';

class DyLoginPage extends StatefulWidget {
  final arguments;
  DyLoginPage({Key key, this.arguments}) : super(key: key);
  
  @override
  _DyLoginPage createState() => _DyLoginPage(arguments);
}
  
class _DyLoginPage extends State<DyLoginPage> with DYBase {
  final _routeProp;
  String _country = '中国大陆';
  String _phoneNumber = '86';
  int type = 2; // 0:注册, 1:手机号码+密码登录, 2:手机号码+验证码登录, 3:昵称登录

  _DyLoginPage(this._routeProp) {
    switch(_routeProp['type']) {
      case 'signin':
        type = 1;
        break;
      case 'signup':
        type = 0;
        break;
    }
  }

  TextEditingController _nickNameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _codeController = TextEditingController();
  TextEditingController _passWordController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _subscribeChooseArea();
  }

  @override
  void dispose() {
    rx.unSubscribe('chooseArea', name: 'DyLoginPage');
    super.dispose();
  }

  void _subscribeChooseArea() {
    rx.subscribe('chooseArea', (data) {
        if (mounted)
        setState(() {
          _country = data[0];
          _phoneNumber = data[1];
        });
    }, name: 'DyLoginPage');
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

  void _changeSinup() {
    setState(() {
      type = type == 0 ? 1 : 0;
    });
  }

  void _forgetPassword() {
    DYdialog.alert(context, title: '太好了', text: '那你重新注册个号吧！');
  }

  void _showAreaList() {
    Navigator.push(context, CupertinoPageRoute(
      builder: (context) {
        return AreaTel();
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: DYBase.dessignWidth)..init(context);

    String title;
    switch(type) {
      case 0:
        title = '注册';
        break;
      case 1:
      case 2:
        title = '手机登录';
        break;
      case 3:
        title = '昵称登录';
        break;
    }
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          title:Text(title),
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
            type != 0 ? GestureDetector(
              onTap: _changeNickNameLogin,
              child: Row(
                children: <Widget>[
                  Text(type == 3 ? '手机登录' : '昵称登录'),
                  Padding(padding: EdgeInsets.only(left: dp(20)),)
                ],
              ),
            ) : SizedBox(),
          ],
        ),
        preferredSize: Size.fromHeight(dp(55)),
      ),
      backgroundColor: Color(0xffeeeeee),
      body: Padding(
        padding: EdgeInsets.only(left: dp(18), right: dp(18)),
        child: Column(
          children: <Widget>[
            type != 3 ? GestureDetector(
              onTap: _showAreaList,
              child: Container(
                margin: EdgeInsets.only(top: dp(18)),
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
                      Text(_country),
                      Padding(padding: EdgeInsets.only(left: dp(10)),),
                      Image.asset('images/show-area.webp',
                        height: dp(16),
                      ),
                    ],
                  ),
                ),
              ),
            ) : SizedBox(),
            type != 3 ? Container(
              margin: EdgeInsets.only(top: dp(18)),
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
                      child: Text('+$_phoneNumber',
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
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          keyboardType: TextInputType.number,
                          cursorColor: DYBase.defaultColor,
                          cursorWidth: 1.5,
                          style: TextStyle(
                            color: Color(0xff333333),
                            fontSize: 14.0,
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none
                            ),
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
              margin: EdgeInsets.only(top: dp(18)),
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
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          keyboardType: TextInputType.number,
                          cursorColor: DYBase.defaultColor,
                          cursorWidth: 1.5,
                          style: TextStyle(
                            color: Color(0xff333333),
                            fontSize: 14.0,
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none
                            ),
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
            type != 2 ? Container(
              margin: EdgeInsets.only(top: dp(18)),
              height: dp(40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: Padding(
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
                            FilteringTextInputFormatter.allow(RegExp(r'[\u4e00-\u9fa5]')),
                          ],
                          obscureText: true,
                          cursorColor: DYBase.defaultColor,
                          cursorWidth: 1.5,
                          style: TextStyle(
                            color: Color(0xff333333),
                            fontSize: 14.0,
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none
                            ),
                            contentPadding: EdgeInsets.only(left: dp(15), top: dp(3), bottom: dp(3)),
                            hintText: '请输入密码',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ) : SizedBox(),
            type == 2 || type == 0 ? Container(
              margin: EdgeInsets.only(top: dp(18)),
              height: dp(40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: Padding(
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
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          cursorColor: DYBase.defaultColor,
                          cursorWidth: 1.5,
                          style: TextStyle(
                            color: Color(0xff333333),
                            fontSize: 14.0,
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none
                            ),
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
              ),
            ) : SizedBox(),
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
                child: Text(type == 0 ? '注册' : '登录',
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
                type != 0 ? GestureDetector(
                  onTap: _forgetPassword,
                  child: Text('忘记密码？',
                    style: TextStyle(
                      color: Color(0xff999999),
                    ),
                  ) 
                ): SizedBox(),
                type != 0 ? GestureDetector(
                  onTap: _changePhoneLogin,
                  child: Text(type == 2 ? '手机密码登录' : '手机验证码快捷登录',
                    style: TextStyle(
                      color: Color(0xffff7701),
                    ),
                  ),
                ) : SizedBox(),
                GestureDetector(
                  onTap: _changeSinup,
                  child: Text(type == 0 ? '去登陆' : '快速注册',
                    style: TextStyle(
                      color: Color(0xffff7701),
                      decorationStyle: TextDecorationStyle.solid,
                      decorationColor: Color(0xffff7701),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
