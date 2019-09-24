/**
 * @discripe: 轮播图
 */
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../bloc.dart';
import '../../base.dart';

class SWwiperWidgets extends StatelessWidget with DYBase {

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: DYBase.dessignWidth)..init(context);

    return BlocBuilder<IndexBloc, Map>(
      builder: (context, indexState) {
        List swiperPic = indexState['swiper'];
        return Padding(
          padding: EdgeInsets.all(dp(10)),
          child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(dp(10)),
            ),
            child: Container(
              width: dp(340),
              height: dp(330) / 1.7686,
              child: _waitSwiperData(swiperPic),
            ),
          ),
        );
      }
    );
  }

  Widget _waitSwiperData(swiperPic) {
    if (swiperPic == null) {
      return Image.asset(
        'images/shayuniang.png',
      );
    } else if (swiperPic.length > 0) {
      return Swiper(
        itemBuilder: (BuildContext context, int index) => CachedNetworkImage(
            imageUrl: swiperPic[index],
            placeholder: (context, url) => Image.asset(
              'images/pic-default.jpg',
              fit: BoxFit.fill,
            ),
            fit: BoxFit.fill,
        ),
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

}