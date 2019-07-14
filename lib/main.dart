import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'config.dart' as config;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DYFlutter',
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromARGB(255, 255, 255, 255),
        primarySwatch: Colors.orange,
      ),
      home: DyIndexPage(title: '斗鱼APP'),
    );
  }
}

class DyIndexPage extends StatefulWidget {
  final String title;

  DyIndexPage({Key key, this.title}) : super(key: key);

  @override
  _DyIndexPageState createState() => _DyIndexPageState();
}

class _DyIndexPageState extends State<DyIndexPage> {
  int _navIndex = 0;

  void _incrementCounter() {
    print('开播按钮');
  }
  // 选择导航tab
  void _chooseTabNav(i) {
    setState(() {
      _navIndex = i;
    });
  }

  // flutter_screenutil px转dp
  num _dp(double dessignValue) => ScreenUtil.getInstance().setWidth(dessignValue);

  @override
  Widget build(BuildContext context) {
    // 分辨率适配
    ScreenUtil.instance = ScreenUtil(width: 375, height: null)..init(context);

    return Scaffold(
      body: new Container(
        child: new Column(
          children: [
            _header(),
            _nav(),
            _swiper(),
            _liveTable(),
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
    );
  }

  // Header容器
  Widget _header() {
    return new Container(
      width: _dp(375),
      height: _dp(80),
      padding: EdgeInsets.fromLTRB(_dp(10), _dp(24), _dp(20), 0),
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
            width: _dp(76),
            height: _dp(34),
          ),
          // 搜索区域容器
          new Expanded(
            flex: 1,
            child: new Container(
              width: _dp(150),
              height: _dp(30),
              margin: EdgeInsets.only(left: _dp(15)),
              padding: EdgeInsets.only(left: _dp(5), right: _dp(5)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(_dp(15)),
                ), 
              ),
              child: new Row(
                children: <Widget>[
                  // 搜索ICON
                  new Image.asset(
                    'lib/images/search.png',
                    width: _dp(25),
                    height: _dp(15),
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
      height: _dp(40),
      // 导航滚动列表视图
      child: new ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.all(10),
        children: _creatNavList(),
      ),
      // 滚动视图的另一种API实现 
      /* child: new ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.all(10),
        itemCount: config.navListData.length,
        itemBuilder: (context, i) {
          return new Container(
            color: Colors.orange,
            margin: EdgeInsets.only(right: _dp(10)),
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

    for (var i = 0; i < config.navListData.length; i++) {
      var border, style;
      Color actColor = Color(0xffff5d23);

      if (i == _navIndex) {
        border = Border(bottom: BorderSide(color: actColor, width: _dp(2)));
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
          margin: EdgeInsets.only(right: _dp(10)),
          child: GestureDetector(
            onTap: () {
              _chooseTabNav(i);
            },
            child: new Text(
              '${config.navListData[i]}',
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
      padding: EdgeInsets.only(left: _dp(6), right: _dp(6)),
      child: new Row(
        children: <Widget>[
          new Container(
            width: _dp(20),
            height: _dp(30),
            margin: EdgeInsets.only(right: _dp(5)),
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
                padding: EdgeInsets.only(left: _dp(5)),
                child: new Image.asset(
                  'lib/images/next.png',
                  height: _dp(14),
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
    var fontStyle = new TextStyle(
      color: Colors.white,
      fontSize: 12.0
    );
    return new Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(_dp(5)),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                width: _dp(180),
                height: _dp(101.25),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(_dp(4)),
                  ),
                  image: DecorationImage(
                    image: NetworkImage('https://rpic.douyucdn.cn/live-cover/appCovers/2019/06/06/910907_20190606212356_small.jpg'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: new Stack(
                  children: <Widget>[
                    new Positioned(
                      child: new Container(
                        width: _dp(120),
                        height: _dp(18),
                        padding: EdgeInsets.only(right: _dp(5)),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topRight: Radius.circular(_dp(4))),
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
                              height: _dp(14),
                            ),
                            Padding(padding: EdgeInsets.only(right: _dp(3))),
                            new Text(
                              '27.7万',
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
                        width: _dp(180),
                        height: _dp(18),
                        padding: EdgeInsets.only(right: _dp(5)),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(_dp(4)),
                            bottomRight: Radius.circular(_dp(4)),
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
                            Padding(padding: EdgeInsets.only(left: _dp(3))),
                            new Image.asset(
                              'lib/images/member.png',
                              height: _dp(14),
                            ),
                            Padding(padding: EdgeInsets.only(right: _dp(3))),
                            new Text(
                              '27.7万',
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
              Padding(
                padding: EdgeInsets.fromLTRB(_dp(3), _dp(4), _dp(3), 0),
                child: new Text(
                  'LPL夏季赛7月14日重播',
                  textAlign: TextAlign.right,
                  style: new TextStyle(
                    fontSize: 13.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
