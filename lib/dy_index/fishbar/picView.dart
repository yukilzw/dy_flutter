/*
 * @discripe: 单图片全屏预览
 */
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../../base.dart';

class PicView extends StatefulWidget {
  final picUrl, width, height;
  PicView(this.picUrl, { this.width, this.height });

  @override
  _PicView createState() => _PicView(picUrl, width, height);
}

class _PicView extends State<PicView> with DYBase {
  final picUrl, width, height;
  _PicView(this.picUrl, this.width, this.height );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          color: Colors.black,
          child: SafeArea(
            child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Center(
                  child: Hero(
                    tag: picUrl,
                    child: Image.network(
                      picUrl,
                      width: dp(375),
                      height: height == null ? null : dp(375 * height / width),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: dp(20),
                  child: Text('1/1',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23.0,
                    ),
                  ),
                ),
                Positioned(
                  bottom: dp(20),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: dp(90),
                      width: dp(375),
                      color: Color.fromARGB(100, 255, 255, 255),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(left: dp(10)),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: DYBase.defaultColor, width: dp(4)
                                    ),
                                  ),
                                  child: Image.network(
                                    picUrl,
                                    width: dp(70),
                                    height: dp(70),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}