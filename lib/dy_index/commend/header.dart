/**
 * @discripe: 推荐AppBar顶部
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../base.dart';

class HeaderWidgets extends StatelessWidget with DYBase {

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: DYBase.dessignWidth)..init(context);

    return Container(
      width: dp(375),
      height: dp(80),
      padding: EdgeInsets.fromLTRB(dp(10), dp(24), dp(20), 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // 斗鱼LOGO
          GestureDetector(
            onTap: DYio.clearCache,
            child: Image(
              image: AssetImage('images/dylogo.png'),
              width: dp(76),
              height: dp(34),
            ),
          ),
          // 搜索区域容器
          Expanded(
            flex: 1,
            child: Container(
              width: dp(150),
              height: dp(30),
              margin: EdgeInsets.only(left: dp(15)),
              padding: EdgeInsets.only(left: dp(5), right: dp(5)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(dp(15)),
                ), 
              ),
              child: Row(
                children: <Widget>[
                  // 搜索ICON
                  Image.asset(
                    'images/search.png',
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
                        hintText: '搜索你想看的直播内容',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}