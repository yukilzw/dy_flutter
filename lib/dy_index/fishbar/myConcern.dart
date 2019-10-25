import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../base.dart';

class MyConcern extends StatefulWidget {
  @override
  _MyConcern createState() => _MyConcern();
}

class _MyConcern extends State<MyConcern> with DYBase {
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xfff3f3f3),
      child: SmartRefresher(
        enablePullDown: false,
        enablePullUp: false,
        header: WaterDropHeader(),
        controller: _refreshController,
        // onRefresh: _onRefresh,
        // onLoading: _onLoading,
        child: ListView(
          padding: EdgeInsets.all(0),
          physics: BouncingScrollPhysics(),
          children: [
            Container(
              margin: EdgeInsets.all(dp(15)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(dp(15)),
                ),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xfff9f9f9),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(dp(15)),
                        topRight: Radius.circular(dp(15)),
                      ),
                    ),
                    height: dp(40),
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: <Widget>[
                        Positioned(
                          left: dp(10),
                          bottom: dp(13),
                          child: Container(
                            width: dp(20),
                            height: dp(5),
                            color: Color(0xffff5d24),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: dp(10)),
                            ),
                            Text(
                              'TOP.2',
                              style: TextStyle(
                                color: Color(0xff333333),
                                fontSize: dp(18),
                                fontWeight: FontWeight.bold,
                                letterSpacing: dp(2.5),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(dp(20)),
                              ),
                              child: Image.network(
                                'http://r.photo.store.qq.com/psb?/V14dALyK4PrHuj/9iN5AqTsytMeLcWQ56xLgtYX*CfeHYPJ1eqqj4p5OTM!/r/dL8AAAAAAAAA',
                                width: dp(40),
                                height: dp(40),
                                fit: BoxFit.fill,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: dp(10)),
                              height: dp(40),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        width: dp(200),
                                        child: Text(
                                          'Xleft小叮当Xleft小叮当Xleft小叮当Xleft小叮当Xleft小叮当Xleft小叮当Xleft小叮当',
                                          style: TextStyle(
                                            color: Color(0xff666666),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Image.asset(
                                        'images/bar-girl.webp',
                                        height: dp(17),
                                      ),
                                      Padding(padding: EdgeInsets.only(left: dp(4)),),
                                      Image.asset(
                                        'images/lv/30.png',
                                        height: dp(14),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        '昨天21:01',
                                        style: TextStyle(
                                          color: Color(0xff999999),
                                          fontSize: 12
                                        ),
                                      ),
                                      Padding(padding: EdgeInsets.only(left: dp(10)),),
                                      Text(
                                        '15.0万阅读',
                                        style: TextStyle(
                                          color: Color(0xff999999),
                                          fontSize: 12
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: dp(10)),
                          child: Text(
                            '10月24日晚六点，我再斗鱼3168536等你！！！不见不散哦！',
                            style: TextStyle(
                              color: Color(0xff333333),
                              fontSize: 15.5,
                              height: 1.2
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: dp(4)),
                          child: Text(
                            '观众姥爷们，我平面设计师回来啦！24号晚六点，斗鱼房间3168536，我再直播间等你们！还有精彩好礼，不停放送！！',
                            style: TextStyle(
                              color: Color(0xff999999),
                              height: 1.1
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}