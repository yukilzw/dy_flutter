/*
 * @discripe: 鱼吧推荐帖子列表
 */
import 'dart:ui' as ui;
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:dy_flutter/service.dart';

import '../../base.dart';
import 'photoGallery.dart';

class FishBarCardList extends StatefulWidget with DYBase {
  final hourTitleKey, refreshController;
  FishBarCardList({ this.hourTitleKey, this.refreshController });

  @override
  _FishBarCardList createState() => _FishBarCardList();
}

class _FishBarCardList extends State<FishBarCardList> with DYBase {
  List yuba = [];
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _getYubaList();
    rx.subscribe('yubaList', (data) async {
        if (data == 'refresh') {
          pageIndex = 0;
          await _getYubaList();
          widget.refreshController.refreshCompleted();
        } else if (data== 'more') {
          pageIndex++;
          await _getYubaList();
          widget.refreshController..loadComplete();
        }
    }, name: 'FishBarCardList');
  }

  @override
  void dispose() {
    rx.unSubscribe('yubaList', name: 'FishBarCardList');
    super.dispose();
  }

  Future _getYubaList() async {
    var res = await httpClient.get(
      API.yubaList,
      queryParameters: {
        'page': pageIndex
      },
    );
    var list = res.data['data'];
    if (mounted)
    setState(() {
      if (pageIndex == 0) {
        yuba = list;
      } else {
        yuba.addAll(list);
      }
    });
  }

  // 图片预览gallery
  void _showPhotoGallery(List pic, { int index = 0, String tag }) {
    var galleryItems = pic.asMap().map((i, item) {
      return MapEntry(i, GalleryItem(
        id: tag,
        resource: item,
      ));
    }).values.toList();
    Navigator.push(context, PageRouteBuilder(
      pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: GalleryPhotoViewWrapper(
            galleryItems: galleryItems,
            backgroundDecoration: BoxDecoration(
              color: Colors.black,
            ),
            initialIndex: index,
            scrollDirection: Axis.horizontal,
          ),
        );
      })
    );
  }

  // 根据数量动态计算图片宽高（类似微信朋友圈）
  Widget _picUnknownNum(List pic, { String id }) {
    double screenWidth = MediaQuery.of(context).size.width;
    double boxMargin = dp(60);
    double picPadding = dp(5);

    return Wrap(
      children: pic.asMap().map((i, item) {
          String tag = id + i.toString();
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
                        return GestureDetector(
                          onTap: () {
                            _showPhotoGallery(pic, tag: tag);
                          },
                          child: Hero(
                            tag: tag,
                            child: Image.network(
                              item,
                              height: imageSize['height'],
                              width: imageSize['width'],
                              fit: BoxFit.cover,
                            ),
                          ),
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
                child: GestureDetector(
                  onTap: () {
                    _showPhotoGallery(pic, index: i, tag: tag);
                  },
                  child: Hero(
                    tag: tag,
                    child: Image.network(
                      item,
                      height: imageSize['height'],
                      width: imageSize['width'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ).values.toList(),
    );
  }
  
  void _showCardOption() {
    RenderBox box = widget.hourTitleKey.currentContext.findRenderObject();
    Offset offset = box.localToGlobal(Offset.zero);
  }

  void _starNews(i) {
    setState(() {
      yuba[i]['isAgree'] = !yuba[i]['isAgree'];
    });
  }

  List<Widget> _creatEach(i, item) {
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
              i <= 2 ? Positioned(
                left: dp(10),
                bottom: dp(13),
                child: Container(
                  width: dp(20),
                  height: dp(5),
                  color: Color(0xffff5d24),
                ),
              ) : SizedBox(),
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: dp(10)),
                  ),
                  Text(
                    i <= 2 ? 'TOP.${i + 1}' : 'NO.${i + 1}',
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
          margin: EdgeInsets.only(bottom: dp(15)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(dp(15)),
              bottomRight: Radius.circular(dp(15)),
            ),
          ),
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
                          item['avatar'],
                          width: dp(40),
                          height: dp(40),
                          fit: BoxFit.fill,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: dp(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Container(
                              width: dp(180.0 + 17 + 14),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    item['name'],
                                    style: TextStyle(
                                      color: Color(0xff666666),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Padding(padding: EdgeInsets.only(left: dp(4)),),
                                  Image.asset(
                                    item['sex'] == 0 ? 'images/bar/girl.webp' : 'images/bar/boy.webp',
                                    height: dp(17),
                                  ),
                                  Padding(padding: EdgeInsets.only(left: dp(4)),),
                                  Image.asset(
                                    'images/lv/${item['level']}.png',
                                    height: dp(14),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  DYservice.formatTime(item['time']),
                                  style: TextStyle(
                                    color: Color(0xff999999),
                                    fontSize: 12
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(left: dp(10)),),
                                Text(
                                  '${DYservice.formatNum(item['read'])}阅读',
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
                  item['title'],
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
                  item['content'],
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
                child: _picUnknownNum(item['pic'], id: item['id']),
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
                            '${DYservice.formatNum(item['hot'])}赞',
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
                              item['anchor'],
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
                          padding: EdgeInsets.only(left: dp(4), right: dp(6)),
                          child: Text(
                            DYservice.formatNum(item['share']),
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
                          padding: EdgeInsets.only(left: dp(4), right: dp(6)),
                          child: Text(
                            DYservice.formatNum(item['chat']),
                            style: TextStyle(
                              color: Color(0xff999999),
                            ),
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        _starNews(i);
                      },
                      child: Row(
                        children: <Widget>[
                          Image.asset(
                            item['isAgree'] ? 'images/bar/chat-star-act.webp' : 'images/bar/chat-star.jpg',
                            height: dp(18),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: dp(4),),
                            child: Text(
                              DYservice.formatNum(item['agree']),
                              style: TextStyle(
                                color: item['isAgree'] ? DYBase.defaultColor : Color(0xff999999),
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
    List<Widget> yubaList = [];

    yuba.asMap().forEach((i, item) {
      yubaList.addAll(_creatEach(i, item)); 
    });

    return Column(
      children: yubaList,
    );
  }
}