/*
 * @discripe: 视频播放器
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

import '../base.dart';

class PlayerWidgets extends StatefulWidget {
  final routeProp;
  PlayerWidgets(this.routeProp);

  @override
  _PlayerWidgets createState() => _PlayerWidgets();
}

class _PlayerWidgets extends State<PlayerWidgets> with DYBase {
  Future _initializeVideoPlayerFuture;
  VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network('${DYBase.baseUrl}/static/suen.mp4')
      ..setLooping(true);

    _initializeVideoPlayerFuture = _videoPlayerController.initialize().then((_) {
      setState(() {});
    });
    _videoPlayerController.play();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
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
      child: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return AspectRatio(
              aspectRatio: _videoPlayerController.value.aspectRatio,
              child: VideoPlayer(_videoPlayerController),
            );
          } else {
            return Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                Positioned(
                  child: Image.network(
                    widget.routeProp['roomSrc'],
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
            );
          }
        },
      ),
    );
  }

}