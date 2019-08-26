/**
 * @discripe: 关注
 */
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../base.dart';

class FocusPage extends StatefulWidget {
  @override
  _FocusPage createState() => _FocusPage();
}

class _FocusPage extends State<FocusPage> with DYBase {
  bool _getPhotoSource = false;
  File _image;  // 拍照（从照片选择）后的文件

  // 点击拍照
  Future _getImage() async {
    var image = await ImagePicker.pickImage(
      source: _getPhotoSource ? ImageSource.camera : ImageSource.gallery,
      maxHeight: dp(200),
      maxWidth: dp(350),
    );

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: DYBase.dessignWidth)..init(context);
    return Scaffold(
      appBar: AppBar(
        title:Text('关注（现为新加功能测试页面）'),
        centerTitle: true,
        backgroundColor: DYBase.defaultColor,
        brightness: Brightness.dark,
        textTheme: TextTheme(
          title: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        )
      ),
      body: Padding(
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
                  onChanged: (value) => setState(() {
                    _getPhotoSource = value;
                  }),
                ),
              ],
            ),
            _image == null ? SizedBox() : Image.file(_image),
            RaisedButton(
              textColor: Colors.white,
              color: DYBase.defaultColor,
              child: Text('正在加载弹框'),
              onPressed: () => showLoading(context),
            ),
            RaisedButton(
              textColor: Colors.white,
              color: DYBase.defaultColor,
              child: Text('webView'),
              onPressed: () {
                Navigator.pushNamed(context, '/webView',
                  arguments: {
                    'url': 'https://m.douyu.com',
                    'title': '斗鱼直播 - H5'
                  });
              },
            ),
          ],
        ),
      ),
    );
  }

}