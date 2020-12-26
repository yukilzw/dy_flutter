/*
 * @discripe: 正在直播列表
 */
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../base.dart';

final _random = Random();
int next(int min, int max) => min + _random.nextInt(max - min);
final int _baseLiveNum = next(1e3.round() + 1, 1e4.round());

class LiveList extends StatelessWidget with DYBase {
  // 跳转直播间
  void _goToLiveRoom(context, item) {
    Navigator.pushNamed(context, '/room', arguments: item);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: DYBase.dessignWidth)..init(context);

    return BlocBuilder<IndexBloc, Map>(
      builder: (ctx, indexState) {
        return Container(
          color: Color(0xfff1f5f6),
          child: Column(
            children: <Widget>[
              _listTableHeader(),
              _listTableInfo(context),
            ]
          ),
        );
      }
    );
  }

  Iterable<Widget> _numberList() {
    int liveDataLen = BlocObj.index.state['liveData'].length + _baseLiveNum;
    String liveDataLenStr = liveDataLen.toString();
    return liveDataLenStr.split('').map((number) => Image.asset(
      'images/num/$number.webp',
      height: dp(13),
    ));
  }

  // 直播列表头部
  Widget _listTableHeader() {
    var numberList = _numberList();
    return Container(
      height: dp(52),
      margin: EdgeInsets.only(
        left: dp(15),
        right: dp(15),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: dp(25),
            margin: EdgeInsets.only(right: dp(5)),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/cqe.webp'),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Expanded(
            child: Text(
              '猜你喜欢',
              style: TextStyle(
                color: Color(0xff333333),
                fontSize: dp(18),
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: dp(1.5)),
                child:  Text(
                  '当前',
                  style: TextStyle(
                    color: Color(0xfff8632e),
                    fontSize: dp(13),
                  ),
                ),
              ),
              ...numberList,
              Padding(
                padding: EdgeInsets.only(left: dp(1.5)),
                child: Text(
                  '位主播',
                  style: TextStyle(
                    color: Color(0xfff8632e),
                    fontSize: dp(13),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: dp(5)),
                child: Image.asset(
                  'images/cfk.webp',
                  height: dp(14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _renderTag(showKingTag) {
    if (showKingTag) {
      return [
        Container(
          height: dp(18),
          decoration: BoxDecoration(
            color: Color(0xfffcf0e2),
            borderRadius: BorderRadius.all(
              Radius.circular(9),
            ),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(
                left: dp(6), right: dp(6),
              ),
              child: Text(
                '皇帝推荐',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: dp(10),
                  color: Color(0xfff7802c),
                ),
              ),
            ),
          ),
        ),
      ];
    }
    return [
      Text(
          '颜值',
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: dp(12),
            color: Color(0xffa2a2a2),
          ),
          strutStyle: StrutStyle(
            forceStrutHeight: true,
            fontSize: dp(13),
            height: 1,
          ),
        ),
      Padding(
        padding: EdgeInsets.only(right:dp(2)),
      ),
      Image.asset(
        'images/dg.webp',
        height: dp(7),
      ),
    ];
  }

  // 直播列表详情
  Widget _listTableInfo(context) {
    List liveData = BlocObj.index.state['liveData'];
    final liveList = List<Widget>();
    var fontStyle = TextStyle(
      color: Colors.white,
      fontSize: dp(12),
    );
    var boxWidth = dp(164);
    var imageHeight = dp(98);
    var boxMargin = (dp(375) - boxWidth * 2) / 3 / 2;

    liveData.asMap().keys.forEach((index) {
      var item = liveData[index];
      var showKingTag = index % 5 == 0;
      liveList.add(
        GestureDetector(
          onTap: () {
            _goToLiveRoom(context, item);
          },
          child: Padding(
          key: ObjectKey(item['rid']),
          padding: EdgeInsets.only(
            left: boxMargin,
            right: boxMargin,
            bottom: boxMargin * 2
          ),
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(dp(10)),
              ),
              child: Container(
                width: boxWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    CachedNetworkImage(
                      imageUrl: item['roomSrc'],
                      imageBuilder: (context, imageProvider) => Container(
                        height: imageHeight,
                        decoration: BoxDecoration(
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
                                padding: EdgeInsets.only(right: dp(6)),
                                decoration: BoxDecoration(
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
                                width: boxWidth,
                                height: dp(25),
                                decoration: BoxDecoration(
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
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: dp(6),
                                        top: dp(4)
                                      ),
                                      child:  Image.asset(
                                        'images/member.png',
                                        height: dp(12),
                                      ),
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
                      placeholder: (context, url) => Image.asset(
                        'images/pic-default.jpg',
                        height: imageHeight,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          SizedBox(
                            height: dp(27),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: dp(6), right: dp(6)),
                                  width: boxWidth,
                                  child: Text(
                                    item['roomName'],
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: dp(13),
                                    ),
                                  ),
                                )
                              ]
                            ),
                          ),
                          Stack(
                            alignment: AlignmentDirectional.centerStart,
                            children: [
                               Container(
                                margin: EdgeInsets.only(right: dp(6.0 + 20)),
                                padding: EdgeInsets.only(left: dp(6)),
                                height: dp(18),
                                child: Row(
                                  children: _renderTag(showKingTag),
                                ),
                              ),
                              Positioned(
                                right: dp(6),
                                child: Image.asset(
                                  'images/dg0.webp',
                                  height: dp(3),
                                ),
                              )
                            ]
                          ),
                          Padding(padding: EdgeInsets.only(bottom: dp(7.5),))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });

    return Wrap(
      children: liveList,
    );
  }

}