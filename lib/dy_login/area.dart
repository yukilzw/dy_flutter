/*
 * @discripe: 国家首字母选择页(仿微信联系人列表)
 */
import 'dart:ui';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

import '../base.dart';

const _letter = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];

class AreaTel extends StatefulWidget {
  AreaTel({Key key}) : super(key: key);
  
  @override
  _AreaTel createState() => _AreaTel();
}
  
class _AreaTel extends State<AreaTel> with DYBase {
  double _letterListHeight = 0; // 字母列表的高度
  int _actLetter; // 当前触摸区域字母的索引
  ScrollController _scrollController = ScrollController();
  Map<String, GlobalKey> _titlekey = {};
  Map _area = {};
  Map _letterScrollTopMap;
  
  _AreaTel() {
    _letterListHeight = MediaQueryData.fromWindow(window).size.height - DYBase.statusBarHeight - dp(50) - 60;
  }

  @override
  void initState() {
    super.initState();
    _getAreaList();
  }

  void _chooseArea(String country, String tel) {
    rx.push('chooseArea', data: [country, tel] );
    Navigator.of(context).pop();
    /* if (key.currentContext == null) {
      return;
    }
    RenderBox renderBox = key.currentContext.findRenderObject();
    Offset offset = renderBox.localToGlobal(Offset.zero);

    print('${offset.dx},${offset.dy}'); */
  }

  // 触摸右侧字母栏滑动时，滚动到对应的字母地区集
  void _onVerticalDragUpdate(details) {
    var eachHeight =_letterListHeight / 26;
    if (details.localPosition.dy <= 0) {
      _actLetter = 0;
    } else if (details.localPosition.dy >= _letterListHeight) {
      _actLetter = 25;
    } else {
      _actLetter = details.localPosition.dy ~/ eachHeight;
    }
    setState(() {});
    if (_letterScrollTopMap[_letter[_actLetter]] != null) {
      _scrollController.jumpTo(
        min(_letterScrollTopMap[_letter[_actLetter]], _scrollController.position.maxScrollExtent)
      );
    }
  }

  // 触摸松手置空选中字母
  void _onVerticalDragEnd(details) {
    setState(() {
      _actLetter = null;
    });
  }

  // 获取地区静态配置文件
  void _getAreaList() async {
    var res = await httpClient.get(
      API.areaList,
      options: buildCacheOptions(
        Duration(days: 365),
      ),
    );
    var data = res.data;
    var letterScrollTopMap = {};
    double height = 0;
    data.forEach((key, value) {
      if (value.length == 0) {
        return;
      }
      letterScrollTopMap[key] = height;
      var i = 0;
      do {
        height += dp(46.6);
        i++;
      } while(i < value.length + 1);
    });
    setState(() {
      _area = data;
      _letterScrollTopMap = letterScrollTopMap;
    });
  }

  List<Widget> _areaList() {
    if (_area == null) {
      return [SizedBox()];
    }
    List<Widget> result = [];
    _area.forEach((key, value) {
      if (value.length == 0) {
        return null;
      }
      GlobalKey _key = GlobalKey();
      _titlekey[key] = _key;
      result.add(Container(
        key: _key,
        margin: EdgeInsets.only(left: dp(6), right: dp(6)),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xff999999), width: dp(.6))),
        ),
        child: Container(
          height: dp(46),
          color: Colors.transparent,
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: dp(10)),
                child: Text(
                  key,
                  style: TextStyle(color: Color(0xff999999),),
                ),
              ),
            ],
          ),
        ),
      ));
      value.forEach((item) {
        var _item = item.split('-');
        var enName = _item[0];
        var cnName = _item[1];
        var tel = _item[2];
        result.add(GestureDetector(
          onTap: () => _chooseArea(cnName, tel),
          child: Container(
            margin: EdgeInsets.only(left: dp(6), right: dp(6)),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xff999999), width: dp(.6))),
            ),
            child: Container(
              height: dp(46),
              color: Colors.transparent,
              child: Row(
                children: <Widget>[
                  Text(
                    '$cnName($enName)',
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ));
      });
    });

    return result;
  }

  List<Widget> _letterList() {
    List config = _area.map((key, value) {
      return MapEntry(key, {
        'key': key,
      });
    }).values.toList();

    return config.asMap().map((i, item) {
      var baseColor = _actLetter == null ? Colors.black : Colors.white;
      return MapEntry(i, Container(
        height: _letterListHeight / 26,
        child: Center(child: Text(item['key'],
          style: TextStyle(
            color: i == _actLetter ? DYBase.defaultColor : baseColor,
            fontSize: i == _actLetter ? 12.0 : 8.0,
            fontWeight: FontWeight.bold,
          ),
        ),),
      ));
    }).values.toList();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: DYBase.dessignWidth)..init(context);
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          title: Text('选择国家和地区代码'),
          titleSpacing: 0,
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          leading: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              color: Colors.white,
              child: Center(
                child: Image.asset('images/back.webp',
                  width: dp(8),
                ),
              ),
            ),
          ),
          elevation: 0,
        ),
        preferredSize: Size.fromHeight(dp(55)),
      ),
      backgroundColor: Color(0xffeeeeee),
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          ListView(
            controller: _scrollController,
            padding: EdgeInsets.all(0),
            children: [
              ..._areaList(),
            ],
          ),
          Positioned(
            right: 0,
            child: Container(
              color: _actLetter == null ? Colors.transparent : Color.fromARGB(90, 0, 0, 0),
              width: dp(30),
              height: _letterListHeight + 60,
              child: Center(
                child: GestureDetector(
                  onVerticalDragEnd: _onVerticalDragEnd,
                  onVerticalDragDown: _onVerticalDragUpdate,
                  onVerticalDragUpdate: _onVerticalDragUpdate,
                  child: Container(
                    color: Colors.transparent,
                    height: _letterListHeight,
                    child: Column(
                      children: _letterList(),
                    ),
                  ),
                ),
              ),
            ),   
          ),
          _actLetter != null ? Positioned(
            child: Container(
              height: dp(120),
              width: dp(120),
              decoration: BoxDecoration(
                color: DYBase.defaultColor,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Center(
                child: Text(_letter[_actLetter],
                  style: TextStyle(
                    fontSize: dp(60),
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ) : SizedBox(),
        ],
      ),
    );
  }

}