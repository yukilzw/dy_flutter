/*
 * @discripe: webView & 拍照
 */
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import '../base.dart';
import '../service.dart';

final flutterWebviewPlugin = FlutterWebviewPlugin();

class DevelopTest extends StatefulWidget {
  @override
  _DevelopTest createState() => _DevelopTest();
}

class _DevelopTest extends State<DevelopTest> with DYBase {
  final url = 'https://apiv2.douyucdn.cn/h5/ecydt/subjectRanklist';
  File _image;  // 拍照（从照片选择）后的文件
  bool _getPhotoSource = false;   // 是否拍照
  bool _openWebViewType = false;    // 是否全屏打开webView

  // 点击拍照
  Future _getImage() async {
    final picker = ImagePicker();
    var image = await picker.getImage(
      source: _getPhotoSource ? ImageSource.camera : ImageSource.gallery,
      maxHeight: dp(200),
      maxWidth: dp(350),
    );
    if (mounted)
    setState(() {
      _image = File(image.path);
    });
  }

  // 弹出webView
  void _showWebView() {
    if (_openWebViewType) {
      Navigator.pushNamed(context, '/webView',
        arguments: {
          'url': url,
          'title': 'dy_flutter 源码'
        }
      );
      return;
    }
    flutterWebviewPlugin.launch(url,
      rect: Rect.fromLTWH(
        0.0,
        MediaQuery.of(context).size.height * .3,
        MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.height * .7,
      ),
    );
    Navigator.push(context, PageRouteBuilder(
      opaque: false,
      pageBuilder: (context, _, __) {
        return GestureDetector(
          onTap: () {
            flutterWebviewPlugin?.close();
            Navigator.pop(context);
          },
          child: WillPopScope(
            onWillPop: _onWillPop,
            child: Container(
              color: Color.fromARGB(100, 0, 0, 0),
            ),
          )
        );
      },
      transitionsBuilder: (context, Animation<double> animation, _, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      }
    ));
  }

  Future<bool> _onWillPop() async {
    flutterWebviewPlugin?.close();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: DYBase.dessignWidth)..init(context);
    return Padding(
        padding: EdgeInsets.all(dp(10)),
          child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  textColor: Colors.white,
                  color: DYBase.defaultColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(_getPhotoSource ? '拍照' : '从相册中选'),
                  onPressed: _getImage,
                ),
                Padding(padding: EdgeInsets.only(left: dp(15)),),
                Text('是否拍照:'),
                Switch(
                  value: _getPhotoSource,
                  activeColor: DYBase.defaultColor,
                  onChanged: (value) => {
                    if (mounted)
                    setState(() {
                      _getPhotoSource = value;
                    })
                  },
                ),
              ],
            ),
            _image == null ? SizedBox() : Image.file(_image),
            RaisedButton(
              textColor: Colors.white,
              color: DYBase.defaultColor,
              child: Text('正在加载弹框'),
              onPressed: () => DYdialog.showLoading(context),
            ),
            RaisedButton(
              textColor: Colors.white,
              color: DYBase.defaultColor,
              child: Text('登陆弹窗'),
              onPressed: () => DYdialog.showLogin(context),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  textColor: Colors.white,
                  color: DYBase.defaultColor,
                  child: Text('${_openWebViewType ? '全屏' : '半屏'}webView'),
                  onPressed: _showWebView,
                ),
                Padding(padding: EdgeInsets.only(left: dp(15)),),
                Text('是否全屏:'),
                Switch(
                  value: _openWebViewType,
                  activeColor: DYBase.defaultColor,
                  onChanged: (value) => {
                    if (mounted)
                    setState(() {
                      _openWebViewType = value;
                    })
                  },
                ),
              ],
            )
          ],
        ),
      );
  }

}