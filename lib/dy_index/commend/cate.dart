/*
 * @discripe: 分区
 */
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:cached_network_image/cached_network_image.dart';

import '../../base.dart';
import '../../service.dart';

const _tab = ['好声音', '舞蹈', '电子竞技', '颜值', '主机游戏', '打榜', '心动FM', '你画我猜', '竞速', '陪玩', '做任务'];

class CateList extends StatefulWidget {
  @override
  _CateList createState() => _CateList();
}

class _CateList extends State<CateList> with DYBase {
  double scrollRatio = 0;

  Widget _renderWidget(context) {
    var tabRender = _tab.asMap().keys.map((index) => InkWell(
      onTap: () => DYdialog.alert(
        context,
        title: _tab[index],
        text: '年轻人不讲武德，偷袭！🪓\n我还没上线呢...',
        yes: '😭 好的，下次一定'
      ),
      child: Container(
        width: dp(375 / 5),
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/cate/tab-${index.toString()}.webp',
              height: dp(40),
            ),
            Padding(padding: EdgeInsets.only(top: dp(7)),),
            Text(
              _tab[index],
              style: TextStyle(
                color: Color(0xff888888),
                fontSize: dp(13.5),
              ),
            ),
          ],
        ),
      ),
    )).toList();

    double indicatorBoxWidth = dp(34);
    double indicatorHeight = dp(3.5);
    double indicatorWidth = dp(15);
    double scrollValue = scrollRatio * (indicatorBoxWidth - indicatorWidth);

    return Column(
      children: [
        Container(
          height: dp(80),
          child: NotificationListener(
            onNotification: (ScrollNotification note) {
              setState(() {
                scrollRatio = note.metrics.pixels / note.metrics.maxScrollExtent;
              });
              return true;
            },
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(0),
              children: tabRender,
            ),
          ),
        ),
        SizedBox(
          height: dp(18),
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(indicatorHeight / 2),
              ),
              child: Container(
                width: indicatorBoxWidth,
                height: indicatorHeight,
                color: Color(0xffd0d0d0),
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Positioned(
                      left: scrollValue,
                      child: Container(
                        width: indicatorWidth,
                        height: indicatorHeight,
                        color: Color(0xffff5d24),
                      ),
                    )
                  ]
                ),
              ),
            ),
          ),
        ),
        Padding(padding: EdgeInsets.only(top: dp(6)),)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: DYBase.dessignWidth)..init(context);

    return BlocBuilder<IndexBloc, Map>(
      builder: (ctx, indexState) => _renderWidget(context)
    );
  }

}