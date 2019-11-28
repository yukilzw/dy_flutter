/**
 * @discripe: 登录注册页
 */
import 'dart:convert';
import 'dart:ui';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

import '../base.dart';

class AreaTel extends StatefulWidget {
  AreaTel({Key key}) : super(key: key);
  
  @override
  _AreaTel createState() => _AreaTel();
}
  
class _AreaTel extends State<AreaTel> with DYBase {
  double _letterListHeight = 0;
  int _actLetter;
  String _selectLetter;
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

  void _show(GlobalKey key) {
    if (key.currentContext == null) {
      return;
    }
    RenderBox renderBox = key.currentContext.findRenderObject();
    Offset offset = renderBox.localToGlobal(Offset.zero);

    print('${offset.dx},${offset.dy}');
  }

  void _getAreaList() async {
    var res = await httpClient.get(
      API.areaList,
      options: buildCacheOptions(
        Duration(days: 365),
      ),
    );
    var data = jsonDecode(res.data);
    var letterScrollTopMap = {};
    double height = 0;
    data.forEach((key, value) {
      if (value.length == 0) {
        return;
      }
      letterScrollTopMap[key] = height;
      var i = 0;
      do {
        height += 40.0;
        i++;
      } while(i < value.length);
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
          onTap: () => _show(_key),
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
      if (i == _actLetter) {
        setState(() {
          _selectLetter =  item['key'];
        });
      }
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
    if (_letterScrollTopMap[_selectLetter] != null) {
      _scrollController.jumpTo(
        min(_letterScrollTopMap[_selectLetter], _scrollController.position.maxScrollExtent)
      );
    }
  }

  void _onVerticalDragEnd(details) {
    setState(() {
      _actLetter = null;
      _selectLetter = null;
    });
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
          _selectLetter != null ? Positioned(
            child: Container(
              height: dp(120),
              width: dp(120),
              decoration: BoxDecoration(
                color: DYBase.defaultColor,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Center(
                child: Text(_selectLetter,
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