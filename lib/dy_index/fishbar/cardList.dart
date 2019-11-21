/**
 * @discripe: 鱼吧推荐帖子列表
 */
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:async';

import '../../base.dart';

class FishBarCardList extends StatefulWidget with DYBase {
  final hourTitleKey;
  FishBarCardList({ this.hourTitleKey });

  @override
  _FishBarCardList createState() => _FishBarCardList(hourTitleKey);
}

class _FishBarCardList extends State<FishBarCardList> with DYBase {
  final hourTitleKey;
  _FishBarCardList(this.hourTitleKey);

  bool _isStar = false;

  // 根据数量动态计算图片宽高（类似微信朋友圈）
  Widget _picUnknownNum(List pic) {
    double screenWidth = MediaQuery.of(context).size.width;
    double boxMargin = dp(60);
    double picPadding = dp(5);

    return Wrap(
      children: pic.asMap().map((i, item) {
          Map<String, double> imageSize = {};
          // 1张图：宽高自适应
          if (pic.length == 1) {
            imageSize['paddingRight'] = 0;
            Image image = Image.network(item);
            Completer<ui.Image> completer = Completer<ui.Image>();
            image.image.resolve(ImageConfiguration()).addListener(ImageStreamListener(
              (ImageInfo info, bool _) {
                completer.complete(info.image);
              }
            ));

            return MapEntry(
              i, Padding(
                padding: EdgeInsets.only(
                  bottom: picPadding, right: imageSize['paddingRight']
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(dp(10)),
                  ),
                  child: FutureBuilder<ui.Image>(
                    future: completer.future,
                    builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
                      if (snapshot.hasData) {
                        var maxWidth = (screenWidth - boxMargin - picPadding) * .7;
                        var maxHeight = (screenWidth - boxMargin - picPadding) / 2;
                        var imgWidth = snapshot.data.width;
                        var imgHeight = snapshot.data.height;

                        if (imgWidth >= imgHeight) {
                          imageSize['width'] = maxWidth;
                          imageSize['height'] = imgHeight < imgWidth / 2 ? maxWidth / 2 : null;
                        } else {
                          imageSize['height'] = maxHeight;
                          imageSize['width'] = imgWidth < imgHeight / 2 ? maxHeight / 2 : null;
                        }
                        return Image.network(
                          item,
                          height: imageSize['height'],
                          width: imageSize['width'],
                          fit: BoxFit.cover,
                        );
                      } else {
                        return SizedBox();
                      }
                    },
                  ),
                ),
              ),
            );
          // 2、4张图：宽高正方形，单行80%各占一半
          } else if (pic.length == 2 || pic.length == 4) {
            if (pic.length == 4) {
              imageSize['width'] = ((screenWidth - boxMargin - picPadding) / 2.5).floor().toDouble();
            } else {
              imageSize['width'] = ((screenWidth - boxMargin - picPadding) / 2).floor().toDouble();
            }
            imageSize['height'] = imageSize['width'];
            imageSize['paddingRight'] = (i + 1) % 2 == 0 ? .0 : picPadding;
          // 3、5~9张图：宽高正方形，单行三张流式，九宫格
          } else {
            imageSize['width'] = ((screenWidth - boxMargin - picPadding * 2) / 3).floor().toDouble();
            imageSize['height'] = imageSize['width'];
            imageSize['paddingRight'] = (i + 1) % 3 == 0 ? .0 : picPadding;
          }

          return MapEntry(
            i, Padding(
              padding: EdgeInsets.only(
                bottom: picPadding, right: imageSize['paddingRight']
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(dp(10)),
                ),
                child: Image.network(
                  item,
                  height: imageSize['height'],
                  width: imageSize['width'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ).values.toList(),
    );
  }
  
  void _showCardOption() {
    RenderBox box = hourTitleKey.currentContext.findRenderObject();
    Offset offset = box.localToGlobal(Offset.zero);

    print(offset);
  }

  void _starNews() {
    setState(() {
        _isStar = !_isStar; 
    });
  }

   List<Widget> _creatEach() {
    return [
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _showCardOption,
                      child: Container(
                        width: dp(20),
                        height: dp(20),
                        color: Colors.transparent,
                        child: Center(
                            child: Image.asset(
                            'images/bar/pull-icon.webp',
                            width: dp(10),
                          ),
                        ),
                      ),
                    ),
                  ),
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
                            Container(
                              width: dp(180.0 + 17 + 14),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    '小玉太难了丶',
                                    style: TextStyle(
                                      color: Color(0xff666666),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Padding(padding: EdgeInsets.only(left: dp(4)),),
                                  Image.asset(
                                    'images/bar/girl.webp',
                                    height: dp(17),
                                  ),
                                  Padding(padding: EdgeInsets.only(left: dp(4)),),
                                  Image.asset(
                                    'images/lv/30.png',
                                    height: dp(14),
                                  ),
                                ],
                              ),
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
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: dp(10)),
                child: Text(
                  '10月24日晚六点，我再斗鱼3168536等你！！！不见不散哦！',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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
                  '观众姥爷们，我正方形主播玉酱回来啦！24号晚六点，斗鱼房间3168536，我再直播间等你们！还有精彩好礼，不停放送！！',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xff999999),
                    height: 1.1
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: dp(10)),
                child: _picUnknownNum([
                  'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1572082173861&di=e5e040c062de8d2c56216205c4d95f9b&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201612%2F01%2F20161201234647_MPzZc.jpeg',
                ]),
              ),
              Padding(
                padding: EdgeInsets.only(top: dp(10), bottom: dp(10)),
                child: Container(
                  padding: EdgeInsets.all(dp(10)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(dp(10)),
                    ),
                    color: Color(0xfff8f8f8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Image.asset(
                            'images/bar/hot-chat.jpg',
                            height: dp(18),
                          ),
                          Text(
                            '82赞',
                            style: TextStyle(
                              color: Color(0xffcccccc),
                            ),
                          )
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(top: dp(5)),),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Color(0xff666666), fontSize: 14,
                            height: 1.3
                          ),
                          children: [
                            TextSpan(
                              text: '醉音符：',
                              style: TextStyle(
                                color: Color(0xff5f84b0)
                              ),
                            ),
                            TextSpan(
                              text: '小姐姐终于开播了，火车开起来！',
                            ),
                          ],
                        ),       
                      ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Color(0xff666666), fontSize: 14,
                            height: 1.3
                          ),
                          children: [
                            TextSpan(
                              text: '小流仔丶QAQ',
                              style: TextStyle(
                                color: Color(0xff5f84b0)
                              ),
                            ),
                            TextSpan(
                              text: ' 回复 ',
                            ),
                            TextSpan(
                              text: '醉音符：',
                              style: TextStyle(
                                color: Color(0xff5f84b0)
                              ),
                            ),
                            TextSpan(
                              text: '你怎么像个魔教中人？',
                            ),
                          ],
                        ),       
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: dp(10),),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: dp(110),
                      child: Wrap(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(
                              left: dp(10), right: dp(10), top: dp(7), bottom: dp(7),
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xfff8f8f8),
                              borderRadius: BorderRadius.all(
                                Radius.circular(dp(15)),
                              ),
                            ),
                            child: Text(
                              '一条小团团',
                              style: TextStyle(
                                color: Color(0xff999999),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1, child: SizedBox(),
                    ),
                    Row(
                      children: <Widget>[
                        Image.asset(
                          'images/bar/chat-share.jpg',
                          height: dp(18),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: dp(4), right: dp(12)),
                          child: Text(
                            '129',
                            style: TextStyle(
                              color: Color(0xff999999),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Image.asset(
                          'images/bar/chat-add.jpg',
                          height: dp(18),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: dp(4), right: dp(12)),
                          child: Text(
                            '2156',
                            style: TextStyle(
                              color: Color(0xff999999),
                            ),
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        _starNews();
                      },
                      child: Row(
                        children: <Widget>[
                          Image.asset(
                            _isStar ? 'images/bar/chat-star-act.webp' : 'images/bar/chat-star.jpg',
                            height: dp(18),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: dp(4),),
                            child: Text(
                              '1.3万',
                              style: TextStyle(
                                color: _isStar ? DYBase.defaultColor : Color(0xff999999),
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
      ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _creatEach(),
    );
  }
}