/**
 * @discripe: 载入APP启动页
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

import '../bloc.dart';
import '../base.dart';
import 'countdown.dart';
import 'wave.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);
  
  @override
  _SplashPageState createState() => _SplashPageState();
}
  
class _SplashPageState extends State<SplashPage> with DYBase, SingleTickerProviderStateMixin  {
  SharedPreferences prefs;
  int count;
  
  @override
  void initState() {
    super.initState();
    _initAsync();
    _getNav();
    _getSwiperPic();
    _initLiveData();
  }
  
  void _initAsync() async {
    // App启动时读取Sp数据，需要异步等待Sp初始化完成。
    prefs = await SharedPreferences.getInstance();
  }
  
  // 获取导航列表
  void _getNav() {
    final indexBloc = BlocProvider.of<IndexBloc>(context);

    httpClient.get(
      API.nav,
    ).then((res) {
      var navList = res.data['data'];
      indexBloc.dispatch(UpdateTab(navList));
    });
  }

  // 获取轮播图列表
  void _getSwiperPic() {
    final indexBloc = BlocProvider.of<IndexBloc>(context);

    httpClient.post(
      API.swiper,
      options: buildCacheOptions(Duration(minutes: 30)),
    ).then((res) {
      var swiper = res.data['data'];
      indexBloc.dispatch(UpdateSwiper(swiper));
    }).catchError((err) {
      indexBloc.dispatch(UpdateSwiper(null));
    });
  }

  // 获取直播间列表
  Future<List> _getLiveData() async {
    final counterBloc = BlocProvider.of<CounterBloc>(context);
    int livePageIndex = BlocObj.counter.currentState;

    var res = await httpClient.get(
      API.liveData,
      queryParameters: {
        'page': livePageIndex.toString()
      },
      options: livePageIndex == 1 ? buildCacheOptions(
        Duration(minutes: 30),
      ) : null,
    );

    counterBloc.dispatch(CounterEvent.increment);
    return res.data['data']['list'];
  }

  void _initLiveData() async {
    final indexBloc = BlocProvider.of<IndexBloc>(context);

    var liveList = await _getLiveData();
    indexBloc.dispatch(UpdateLiveData(liveList));
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: DYBase.dessignWidth)..init(context);
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: <Widget>[
            Positioned(
              right: dp(25),
              top: dp(25),
              child: CountdownInit(),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: dp(70)),),
                Image.asset(
                  'images/init_logo.webp',
                  width: dp(300),
                ),
                Padding(padding: EdgeInsets.only(top: dp(70)),),
                Image.asset(
                  'images/init_icon.png',
                  width: dp(90),
                ),
                WaveBtoom(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
