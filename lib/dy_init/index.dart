/*
 * @discripe: 载入APP启动页
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:dio/dio.dart';

import '../bloc.dart';
import '../base.dart';
import '../service.dart';
import 'countdown.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);
  
  @override
  _SplashPageState createState() => _SplashPageState();
}
  
class _SplashPageState extends State<SplashPage> with DYBase {
  SharedPreferences prefs;
  
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
      indexBloc.add(UpdateTab(navList));
    });
  }

  // 获取轮播图列表
  void _getSwiperPic() {
    final indexBloc = BlocProvider.of<IndexBloc>(context);

    httpClient.post(
      API.swiper,
      data: FormData.fromMap({
        'num': 4
      }),
      options: buildCacheOptions(
        Duration(minutes: 30),
        // options: Options(contentType: ContentType.parse("application/x-www-form-urlencoded"))
      ),
    ).then((res) {
      var swiper = res.data['data'];
      indexBloc.add(UpdateSwiper(swiper));
    }).catchError((err) {
      indexBloc.add(UpdateSwiper(null));
    });
  }

  void _initLiveData() async {
    final indexBloc = BlocProvider.of<IndexBloc>(context);

    var liveList = await DYservice.getLiveData(context);
    indexBloc.add(UpdateLiveData(liveList));
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
            SizedBox(
              width: dp(375),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'images/init_logo.webp',
                    width: dp(300),
                  ),
                  Padding(padding: EdgeInsets.only(top: dp(70)),),
                  Image.asset(
                    'images/init_icon.png',
                    width: dp(90),
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
