/**
 * @discripe: 轮播图
 */
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

import '../../base.dart';

class SWwiperWidgets extends StatefulWidget {
  @override
  _SWwiperWidgets createState() => _SWwiperWidgets();
}

class _SWwiperWidgets extends State<SWwiperWidgets> with DYBase {
  List swiperPic = [];  // 轮播图地址

  @override
  void initState() {
    super.initState();
    _getSwiperPic();
  }

  // 获取轮播图数据
  void _getSwiperPic() {
    httpClient.post(
      API.swiper,
      options: buildCacheOptions(Duration(minutes: 30)),
    ).then((res) {
      setState(() {
        swiperPic = res.data['data']; 
      });
    }).catchError((err) {
      setState(() {
        swiperPic = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: DYBase.dessignWidth)..init(context);

    return Padding(
      padding: EdgeInsets.all(dp(10)),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(dp(10)),
        ),
        child: Container(
          width: dp(340),
          height: dp(330) / 1.7686,
          child: _waitSwiperData(),
        ),
      ),
    );
  }

  Widget _waitSwiperData() {
    if (swiperPic == null) {
      return Image.asset(
        'images/shayuniang.png',
      );
    } else if (swiperPic.length > 0) {
      return Swiper(
        itemBuilder: _swiperBuilder,
        itemCount: swiperPic.length,
        pagination: SwiperPagination(
            builder: DotSwiperPaginationBuilder(
          color: Color.fromRGBO(0, 0, 0, .2),
          activeColor: DYBase.defaultColor,
        )),
        control: SwiperControl(
          size: dp(20),
          color: DYBase.defaultColor,
        ),
        scrollDirection: Axis.horizontal,
        autoplay: true,
        onTap: (index) => print('Swiper pic $index click'),
      );
    }

    return null;
  }

  Widget _swiperBuilder(BuildContext context, int index) {
    return (Image.network(
      swiperPic[index],
      fit: BoxFit.fill,
    ));
  }

}