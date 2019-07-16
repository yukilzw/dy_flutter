import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'base.dart' show DYBase;
import 'config.dart' as config;

class DyIndexPage extends StatefulWidget {
  final arguments;
  DyIndexPage({Key key, this.arguments}) : super(key: key);

  @override
  _DyIndexPageState createState() => _DyIndexPageState();
}

class _DyIndexPageState extends State<DyIndexPage> with DYBase {
  /*---- 实例属性 State ----*/
  int _navIndex = 0;
  List navList = config.navListData;

  /*---- 生命周期钩子 ----*/
  @override
  void initState() {
    _getNav();
  }

  /*---- 网络请求 ----*/
  void _getNav() async {
      var url = 'http://10.113.22.82:1236/dy/flutter/Nav';
      var httpClient = new HttpClient();

      List result;
      try {
        var request = await httpClient.getUrl(Uri.parse(url));
        var response = await request.close();
        if (response.statusCode == HttpStatus.OK) {
          var json = await response.transform(utf8.decoder).join();
          var data = jsonDecode(json);
          result = data['data'];

          if (!mounted || data['error'] != 0) return;
          setState(() {
            navList = result;
          });
        }
      } catch (exception) {}
  }

  /*---- 事件对应方法 ----*/
  // 点击悬浮标
  void _incrementCounter() {
    Navigator.pushNamed(context, '/demo');
  }
  // 选择导航tab
  void _chooseTabNav(i) {
    setState(() {
      _navIndex = i;
    });
  }
  // 跳转直播间
  void _goToLiveRoom(item) {
    Navigator.pushNamed(context, '/room', arguments: item);
  }

  /*---- 部件buid函数入口 ----*/
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: DYBase.dessignWidth)..init(context);

    return Scaffold(
      body: new Container(
        child: new Column(
          children: [
            _header(),
            _nav(),
            new Container( // 页面整体滚动容器
              height: MediaQuery.of(context).size.height - dp(80.0 + 40.0),
              child: new ListView(
                padding: EdgeInsets.only(top: 0),
                children: [
                  _swiper(),
                  _liveTable(),
                ],
              ),
            ),
          ]
        ),
      ),
      // 右下角悬浮按钮
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        foregroundColor: Color(0xffff5d23),
        backgroundColor: Colors.white,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  /*---- 组件化拆分 ----*/
  // Header容器
  Widget _header() {
    return new Container(
      width: dp(375),
      height: dp(80),
      padding: EdgeInsets.fromLTRB(dp(10), dp(24), dp(20), 0),
      decoration: BoxDecoration(
        // 背景渐变
        gradient: LinearGradient(
          begin: const Alignment(-1.0, 0.0),
          end: const Alignment(0.6, 0.0),
          colors: <Color>[
            const Color(0xffffffff),
            const Color(0xffff9b7a)
          ],
        ),
      ),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // 斗鱼LOGO
          new Image(
            image: AssetImage('lib/images/dylogo.png'),
            width: dp(76),
            height: dp(34),
          ),
          // 搜索区域容器
          new Expanded(
            flex: 1,
            child: new Container(
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
              child: new Row(
                children: <Widget>[
                  // 搜索ICON
                  new Image.asset(
                    'lib/images/search.png',
                    width: dp(25),
                    height: dp(15),
                  ),
                  // 搜索输入框
                  new Expanded(
                    flex: 1,
                    child: new TextField(
                      cursorColor: Color(0xffff5d23),
                      cursorWidth: 1.5,
                      style: TextStyle(
                        color: Color(0xffff5d23),
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

  // tab 切换导航
  Widget _nav() {
    return SizedBox(
      height: dp(40),
      // 导航滚动列表视图
      child: new ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.all(10),
        children: _creatNavList(),
      ),
      // 滚动视图的另一种快捷API实现 
      /* child: new ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.all(10),
        itemCount: config.navListData.length,
        itemBuilder: (context, i) {
          return new Container(
            color: Colors.orange,
            margin: EdgeInsets.only(right: dp(10)),
            child: new Text(
              '${config.navListData[i]}',
            ),
          );
        },
      ), */
    );
  }

  // 创建导航子项
  List<Container> _creatNavList() {
    var navWidgetList = new List<Container>();

    for (var i = 0; i < navList.length; i++) {
      var border, style;
      Color actColor = Color(0xffff5d23);

      if (i == _navIndex) {
        border = Border(bottom: BorderSide(color: actColor, width: dp(2)));
        style = new TextStyle(
          color: actColor,
        );
      } else {
        style = new TextStyle(
          color: Color(0xff3f3f3f),
        );
      }
      navWidgetList.add(
        new Container(
          decoration: BoxDecoration(
            border: border
          ),
          margin: EdgeInsets.only(right: dp(10)),
          child: GestureDetector(
            onTap: () {
              _chooseTabNav(i);
            },
            child: new Text(
              '${navList[i]}',
              style: style,
            ),
          ),
        ),
      );
    }
    return navWidgetList;
  }

  // 轮播图
  Widget _swiper() {
    return new Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width / 1.7686,
      child: new Swiper(
        itemBuilder: _swiperBuilder,
        itemCount: 3,
        pagination: new SwiperPagination(
            builder: DotSwiperPaginationBuilder(
          color: Color.fromRGBO(0, 0, 0, .2),
          activeColor: Color(0xfffa7122),
        )),
        control: new SwiperControl(),
        scrollDirection: Axis.horizontal,
        autoplay: true,
        onTap: (index) => print('this is $index click'),
      ),
    );
  }

  Widget _swiperBuilder(BuildContext context, int index) {
    return (Image.network(
      config.swiperPic[index],
      fit: BoxFit.fill,
    ));
  }

  // 直播列表
  Widget _liveTable() {
    return new Column(
      children: <Widget>[
        _listTableHeader(),
        _listTableInfo(),
      ]
    );
  }

  // 直播列表头部
  Widget _listTableHeader() {
    return Padding(
      padding: EdgeInsets.only(left: dp(6), right: dp(6)),
      child: new Row(
        children: <Widget>[
          new Container(
            width: dp(20),
            height: dp(30),
            margin: EdgeInsets.only(right: dp(5)),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/images/isLive.png'),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          new Expanded(
            child: new Text('正在直播'),
          ),
          new Row(
            children: <Widget>[
              new Text('当前',
                style: new TextStyle(
                  color: Color(0xff999999),
                ),
              ),
              new Text('28346',
                style: new TextStyle(
                  color: Color(0xffff7700),
                ),
              ),
              new Text('个直播',
                style: new TextStyle(
                  color: Color(0xff999999),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: dp(5)),
                child: new Image.asset(
                  'lib/images/next.png',
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
  Widget _listTableInfo() {
    final liveList = new List<Widget>();
    var fontStyle = new TextStyle(
      color: Colors.white,
      fontSize: 12.0
    );

    config.liveData.forEach((item) {
      liveList.add(
        GestureDetector(
          onTap: () {
            _goToLiveRoom(item);
          },
          child: Padding(
          key: ObjectKey(item['rid']),
          padding: EdgeInsets.all(dp(5)),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(
                  width: dp(175),
                  height: dp(101.25),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(dp(4)),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(item['roomSrc']),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: new Stack(
                    children: <Widget>[
                      new Positioned(
                        child: new Container(
                          width: dp(120),
                          height: dp(18),
                          padding: EdgeInsets.only(right: dp(5)),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topRight: Radius.circular(dp(4))),
                            gradient: LinearGradient(
                              begin: const Alignment(-.4, 0.0),
                              end: const Alignment(1, 0.0),
                              colors: <Color>[
                                const Color.fromRGBO(0, 0, 0, 0),
                                const Color.fromRGBO(0, 0, 0, .6),
                              ],
                            ),
                          ),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              new Image.asset(
                                'lib/images/hot.png',
                                height: dp(14),
                              ),
                              Padding(padding: EdgeInsets.only(right: dp(3))),
                              new Text(
                                item['hn'],
                                style: fontStyle,
                              ),
                            ],
                          ),
                        ),
                        top: 0,
                        right: 0,
                      ),
                      new Positioned(
                        child: new Container(
                          width: dp(175),
                          height: dp(18),
                          padding: EdgeInsets.only(right: dp(5)),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(dp(4)),
                              bottomRight: Radius.circular(dp(4)),
                            ),
                            gradient: LinearGradient(
                              begin: const Alignment(0, -.5),
                              end: const Alignment(0, 1.3),
                              colors: <Color>[
                                const Color.fromRGBO(0, 0, 0, 0),
                                const Color.fromRGBO(0, 0, 0, .6),
                              ],
                            ),
                          ),
                          child: new Row(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(left: dp(3))),
                              new Image.asset(
                                'lib/images/member.png',
                                height: dp(14),
                              ),
                              Padding(padding: EdgeInsets.only(right: dp(3))),
                              new Text(
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
                new Container(
                  width: dp(175),
                  padding: EdgeInsets.fromLTRB(dp(1), dp(4), 0, 0),
                  child: new Text(
                    item['roomName'],
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: new TextStyle(
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

    return new Wrap(
      children: liveList,
    );
  }
}
