/*
 * @discripe: 轮播图
 */
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../bloc.dart';
import '../../base.dart';

class SwiperList extends StatelessWidget with DYBase {

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: DYBase.dessignWidth)..init(context);

    return BlocBuilder<IndexBloc, Map>(
      builder: (ctx, indexState) {
        List swiperPic = indexState['swiper'];
        return Padding(
          padding: EdgeInsets.all(dp(16)),
          child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(dp(10)),
            ),
            child: Container(
              height: dp(130),
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
            'images/shayuniang.png',
            fit: BoxFit.contain,
          ),
          fit: BoxFit.cover,
        ),
        itemCount: swiperPic.length,
        pagination: SwiperPagination(
          builder: DotSwiperPaginationBuilder(
            color: Colors.white,
            size: dp(6),
            activeSize: dp(9),
            activeColor: DYBase.defaultColor,
          ),
          margin: EdgeInsets.only(
            right: dp(10),
            bottom: dp(5),
          ),
          alignment: Alignment.bottomRight
        ),
        scrollDirection: Axis.horizontal,
        autoplay: true,
        onTap: (index) => print('Swiper pic $index click'),
      );
    }

    return null;
  }

}