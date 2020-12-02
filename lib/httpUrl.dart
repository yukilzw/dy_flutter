/*
 * @discripe: 网络服务
 */
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:web_socket_channel/io.dart';

import 'base.dart';

// 接口URL
abstract class API {
  static const nav = '/dy/flutter/nav';                                       // 首页顶部导航
  static const swiper = '/dy/flutter/swiper';                                 // 首页轮播图
  static const broadcast = '/dy/flutter/broadcast';                           // 首页推荐广播
  static const liveData = '/dy/flutter/liveData';                             // 首页直播视频列表
  static const lotteryConfig = '/dy/flutter/lotteryConfig';                   // 抽奖配置信息
  static const lotteryResult = '/dy/flutter/lotteryResult';                   // 点击抽奖结果
  static const yubaList = '/dy/flutter/yubaList';                             // 鱼吧列表
  static const areaList = '/static/areaTel.json';                             // 国家地区号码静态文件
}

// http请求
final dioManager = DioCacheManager(
  CacheConfig(
    skipDiskCache: true
  )
);
final httpClient = Dio(BaseOptions(
  baseUrl: DYBase.baseUrl,
  responseType: ResponseType.json,
  connectTimeout: 5000,
  receiveTimeout: 3000,
))..interceptors.add(
  dioManager.interceptor,
);

// 直播房间webSocket
class SocketClient {
  static IOWebSocketChannel channel;

  SocketClient.create() {
    SocketClient.channel = IOWebSocketChannel.connect('ws://${DYBase.baseHost}:${DYBase.basePort}/socket/dy/flutter');
  }

}