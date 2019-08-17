library base;
/**
 * @discripe: 抽象类与通用封装
 */

import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

// 所有Widget继承的抽象类
abstract class DYBase {
  // 网络环境配置
  static final scheme = 'http';
  static final host = '192.168.0.100';
  static final port = 1236;
  // 默认斗鱼主题色
  static final defaultColor = Color(0xffff5d23);
  // 初始化设计稿尺寸
  static final double dessignWidth = 375.0;
  static final double dessignHeight = 1335.0;

  // flutter_screenutil px转dp
  num dp(double dessignValue) => ScreenUtil.getInstance().setWidth(dessignValue);

  // 默认弹窗alert
  void alert(context, {
    String text = '', String title = '提示', String yes = '确定'
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
          return AlertDialog(
              title: Text(title),
              content: SingleChildScrollView(
                  child: ListBody(
                      children: <Widget>[
                          Text(text),
                      ],
                  ),
              ),
              actions: <Widget>[
                  FlatButton(
                      child: Text(yes),
                      onPressed: () {
                          Navigator.of(context).pop();
                      },
                  ),
              ],
          );
      },
    ).then((val) {});
  }
}

// http请求
class DYhttp {
  static Future<dynamic> post(String url, {bool cache = false, Map param}) async {
    var client = http.Client();
    var totalUrl = Uri(
      scheme: DYBase.scheme,
      host: DYBase.host,
      port: DYBase.port,
      path: url,
    );
    try {
      var uriResponse = await client.post(
        '$totalUrl',
        body: param == null ? {} : param
      );
      return jsonDecode(uriResponse.body);
    } finally {
      client.close();
    }
  }

  static Future<dynamic> get(String url, {dynamic cacheName, Map param}) async {
    var client = http.Client();
    var totalUrl = Uri(
      scheme: DYBase.scheme,
      host: DYBase.host,
      port: DYBase.port,
      path: url,
      queryParameters: param
    );
    try {
      var uriResponse = await client.get(
        '$totalUrl',
      );
      if (cacheName is String) {
        DYio.setTempFile(cacheName, uriResponse.body);
      }
      return jsonDecode(uriResponse.body);
    } finally {
      client.close();
    }
  }
}

// 缓存读写清
class DYio {
  // 获取缓存目录
  static Future<String> getTempPath() async {
    var tempDir = await getTemporaryDirectory();
    return tempDir.path;
  }

  // 设置缓存
  static void setTempFile(fileName, [str = '']) async {
    String tempPath = await getTempPath();
    await File('$tempPath/$fileName.txt').writeAsString(str);
  }

  // 读取缓存
  static Future<dynamic> getTempFile(fileName) async {
    String tempPath = await getTempPath();
    try {
      String contents = await File('$tempPath/$fileName.txt').readAsString();
      return jsonDecode(contents);
    } catch(e) {
      print('$fileName:缓存不存在');
    }
  }

  // 清缓存
  static void clearCache() async {
    try {
      Directory tempDir = await getTemporaryDirectory();
      await _delDir(tempDir);
      Fluttertoast.showToast(msg: '清除缓存成功');
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '清除缓存失败');
    } finally {}
  }

  // 递归方式删除目录
  static Future<Null> _delDir(FileSystemEntity file) async {
    try {
      if (file is Directory) {
        final List<FileSystemEntity> children = file.listSync();
        for (final FileSystemEntity child in children) {
          await _delDir(child);
        }
      }
      await file.delete();
    } catch (e) {
      print(e);
    }
  }
}

// 禁用点击水波纹
class NoSplashFactory extends InteractiveInkFeatureFactory {
  @override
  InteractiveInkFeature create({
    MaterialInkController controller,
    RenderBox referenceBox,
    Offset position,
    Color color,
    TextDirection textDirection,
    bool containedInkWell = false,
    rectCallback,
    BorderRadius borderRadius,
    ShapeBorder customBorder,
    double radius,
    onRemoved
  }) {
    return NoSplash(
      controller: controller,
      referenceBox: referenceBox,
    );
  }
}

class NoSplash extends InteractiveInkFeature {
  NoSplash({
    @required MaterialInkController controller,
    @required RenderBox referenceBox,
  }) : super(
    controller: controller,
    referenceBox: referenceBox,
  );

  @override
  void paintFeature(Canvas canvas, Matrix4 transform) {}
}