/*
 * @discripe: 广播游戏订阅推荐
 */
import 'package:flutter/material.dart';
import 'package:dy_flutter/service.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../base.dart';

class BroadcastSwiper extends StatefulWidget {
  @override
  _BroadcastSwiper createState() => _BroadcastSwiper();
}

class _BroadcastSwiper extends State<BroadcastSwiper> with DYBase {
  List _broadcastList;

  @override
  void initState() {
    super.initState();
    _getBroadcastList();
  }

  Future _getBroadcastList() async {
    var res = await httpClient.get(
      API.broadcast,
    );
    var list = res.data['data'];
    setState(() {
      _broadcastList = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: DYBase.dessignWidth)..init(context);

    return Container(
      padding: EdgeInsets.only(left: dp(15), right: dp(15)),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color(0xfffbfbfb),
            width: 1,
          )
        )
      ),
      height: dp(40),
      child: _waitBroadcastSwiperData(),
    );
  }

  String _formatTime(int timeSec) {
    var date = DateTime.fromMillisecondsSinceEpoch(timeSec * 1000);
    return '${date.month.toString().padLeft(2,'0')}/${date.day.toString().padLeft(2,'0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} ';
  }

  void _changeOrderStatus(Map item) {
    var current = item['order'];
    setState(() {
      item['order'] = !current;
    });
    if (current) {
      Fluttertoast.showToast(msg: '已取消订阅');
    } else {
      Fluttertoast.showToast(msg: '已订阅');
    }
  }

  Widget _waitBroadcastSwiperData() {
    if (_broadcastList == null) {
      return SizedBox();
    } else if (_broadcastList.length > 0) {
      return Swiper(
        itemBuilder: (BuildContext context, int index) => Container(
          child: Row(
            children: <Widget>[
              Image.asset(index % 2 == 0 ? 'images/cjf.webp' : 'images/broadcast.webp',
                height: dp(20),
              ),
              Padding(padding: EdgeInsets.only(right: dp(5)),),
              Expanded(
                flex: 1,
                child: Text(
                  _broadcastList[index]['title'],
                  style: TextStyle(
                    color: Color(0xff333333),
                    fontSize: dp(12.5),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(padding: EdgeInsets.only(right: dp(5)),),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Color(0xff999999),
                    fontSize: dp(12.5),
                  ),
                  children: [
                    TextSpan(
                      text: _formatTime(_broadcastList[index]['time']),
                    ),
                    TextSpan(
                      text: DYservice.formatNum(_broadcastList[index]['num']),
                      style: TextStyle(
                        color: DYBase.defaultColor
                      ),
                    ),
                    TextSpan(
                      text: '人预定',
                    ),
                  ],
                ),       
              ),
              Padding(padding: EdgeInsets.only(right: dp(5)),),
              GestureDetector(
                onTap: () => _changeOrderStatus( _broadcastList[index]),
                child: Container(
                  padding: EdgeInsets.only(
                    left: dp(8), right: dp(8), top: dp(3), bottom: dp(3),
                  ),
                  child: Text(
                    _broadcastList[index]['order'] ? '已预订' : '预订',
                    style: TextStyle(
                      color: _broadcastList[index]['order'] ? Colors.white : DYBase.defaultColor,
                      fontSize: 11,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: _broadcastList[index]['order'] ? Color(0xffd9d9d9) : Colors.transparent,
                    border: _broadcastList[index]['order'] ? null : Border.all(color: Color(0xffffd2a6), width: dp(.7)),
                    borderRadius: BorderRadius.all(
                      Radius.circular(dp(4)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        itemCount: _broadcastList.length,
        scrollDirection: Axis.vertical,
        autoplay: true,
        duration: 1500,
        autoplayDelay: 4500,
        curve: Curves.linear,
      );
    }

    return null;
  }

}