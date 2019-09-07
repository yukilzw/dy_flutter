/**
 * @discripe: 视频播放器
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

import '../base.dart';

class PlayerWidgets extends StatefulWidget {
  final _routeProp;
  PlayerWidgets(this._routeProp);

  @override
  _PlayerWidgets createState() => _PlayerWidgets(_routeProp);
}

class _PlayerWidgets extends State<PlayerWidgets> with DYBase {
  final _routeProp;
  _PlayerWidgets(this._routeProp);

  ChewieController _videoController;    // 播放器Controller : chewie
  VideoPlayerController _videoPlayerController;   // 播放器Controller : video_player

  @override
  void initState() {
    super.initState();
    // 初始化播放器设置
    _videoPlayerController = VideoPlayerController.network('${DYBase.baseUrl}/static/suen.mp4');
    _videoController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 960 / 540,
      autoPlay: true,
      looping: true,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: DYBase.dessignWidth)..init(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double playerHeight = screenWidth * 540 / 960;

    return Container(
      width: screenWidth,
      height: playerHeight,
      color: Color(0xff333333),
      child: _videoController != null ? Chewie(
        controller: _videoController,
      ) :
      Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          Positioned(
            child: Image.network(
              _routeProp['roomSrc'],
              height: playerHeight,
            ),
          ),
          Positioned(
            child: Image.asset(
              'images/play.png',
              height: dp(60),
            ),
          ),
        ],
      ),
    );
  }

}