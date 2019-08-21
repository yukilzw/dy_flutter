/**
 * @discripe: 九宫格抽奖
 */
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../bloc.dart';
import '../base.dart';

class Lottery extends StatefulWidget {
  @override
  _Lottery createState() => _Lottery();
}
class _Lottery extends State<Lottery> with DYBase {
  Map lotteryConfig;

  _Lottery() {
    DYhttp.get(
      '/dy/flutter/lotteryConfig',
    ).then((res) {
      setState(() {
        lotteryConfig = res['data']; 
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: DYBase.dessignWidth)..init(context);
    return BlocBuilder<TabBloc, List>(
      builder: (context, navList) {
        return  Container(
          color: Color(0xffff9434),
          child: lotteryConfig == null ? null : ListView(
            children: [
              Container(
                height: dp(lotteryConfig['pageH']),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(lotteryConfig['pageBg']),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    Positioned(
                      bottom: 0,
                      child: Container(
                        width: dp(lotteryConfig['lotteryW']),
                        height: dp(lotteryConfig['lotteryH']),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(lotteryConfig['lotteryBg']),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Wrap(
                          children: <Widget>[
                            Container(
                              width: dp(lotteryConfig['lotteryW'] / 3),
                              height: dp(lotteryConfig['lotteryH'] / 3),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(lotteryConfig['highLightBg']),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: dp(lotteryConfig['myRewardW']),
                    height: dp(lotteryConfig['myRewardH']),
                    margin: EdgeInsets.only(top: dp(10), bottom: dp(10)),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(lotteryConfig['myRewardBg']),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      }
    );
  }

}