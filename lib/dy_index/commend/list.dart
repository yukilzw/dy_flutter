/**
 * @discripe: 正在直播列表
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../base.dart';

class LiveListWidgets extends StatelessWidget with DYBase {
  final indexState;
  LiveListWidgets(this.indexState);

  // 跳转直播间
  void _goToLiveRoom(context, item) {
    Navigator.pushNamed(context, '/room', arguments: item);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: DYBase.dessignWidth)..init(context);
    List liveData = indexState['liveData'];

    return Column(
      children: <Widget>[
        _listTableHeader(),
        _listTableInfo(context, liveData),
      ]
    );
  }

  // 直播列表头部
  Widget _listTableHeader() {
    return Padding(
      padding: EdgeInsets.only(left: dp(6), right: dp(6)),
      child: Row(
        children: <Widget>[
          Container(
            width: dp(20),
            height: dp(30),
            margin: EdgeInsets.only(right: dp(5)),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/isLive.png'),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Expanded(
            child: Text('正在直播'),
          ),
          Row(
            children: <Widget>[
              Text('当前',
                style: TextStyle(
                  color: Color(0xff999999),
                ),
              ),
              Text('12345',
                style: TextStyle(
                  color: Color(0xffff7700),
                ),
              ),
              Text('个直播',
                style: TextStyle(
                  color: Color(0xff999999),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: dp(5)),
                child: Image.asset(
                  'images/next.png',
                  height: dp(14),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  // 直播列表详情
  Widget _listTableInfo(context, liveData) {
    final liveList = List<Widget>();
    var fontStyle = TextStyle(
      color: Colors.white,
      fontSize: 12.0
    );

    liveData.forEach((item) {
      liveList.add(
        GestureDetector(
          onTap: () {
            _goToLiveRoom(context, item);
          },
          child: Padding(
          key: ObjectKey(item['rid']),
          padding: EdgeInsets.all(dp(5)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CachedNetworkImage(
                  imageUrl: item['roomSrc'],
                  imageBuilder: (context, imageProvider) => Container(
                    width: dp(175),
                    height: dp(120),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(dp(4)),
                      ),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          child: Container(
                            width: dp(120),
                            height: dp(18),
                            padding: EdgeInsets.only(right: dp(5)),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(topRight: Radius.circular(dp(4))),
                              gradient: LinearGradient(
                                begin: Alignment(-.4, 0.0),
                                end: Alignment(1, 0.0),
                                colors: <Color>[
                                  Color.fromRGBO(0, 0, 0, 0),
                                  Color.fromRGBO(0, 0, 0, .6),
                                ],
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Image.asset(
                                  'images/hot.png',
                                  height: dp(14),
                                ),
                                Padding(padding: EdgeInsets.only(right: dp(3))),
                                Text(
                                  item['hn'],
                                  style: fontStyle,
                                ),
                              ],
                            ),
                          ),
                          top: 0,
                          right: 0,
                        ),
                        Positioned(
                          child: Container(
                            width: dp(175),
                            height: dp(18),
                            padding: EdgeInsets.only(right: dp(5)),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(dp(4)),
                                bottomRight: Radius.circular(dp(4)),
                              ),
                              gradient: LinearGradient(
                                begin: Alignment(0, -.5),
                                end: Alignment(0, 1.3),
                                colors: <Color>[
                                  Color.fromRGBO(0, 0, 0, 0),
                                  Color.fromRGBO(0, 0, 0, .6),
                                ],
                              ),
                            ),
                            child: Row(
                              children: <Widget>[
                                Padding(padding: EdgeInsets.only(left: dp(3))),
                                Image.asset(
                                  'images/member.png',
                                  height: dp(14),
                                ),
                                Padding(padding: EdgeInsets.only(right: dp(3))),
                                Text(
                                  item['nickname'],
                                  style: fontStyle,
                                ),
                              ],
                            ),
                          ),
                          bottom: 0,
                          left: 0,
                        ),
                      ],
                    ),
                  ),
                  placeholder: (context, url) => ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(dp(4)),
                    ),
                    child:Image.asset(
                      'images/pic-default.jpg',
                      width: dp(175),
                      height: dp(120),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Container(
                  width: dp(175),
                  padding: EdgeInsets.fromLTRB(dp(1), dp(4), 0, 0),
                  child: Text(
                    item['roomName'],
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      );
    });

    return Wrap(
      children: liveList,
    );
  }

}