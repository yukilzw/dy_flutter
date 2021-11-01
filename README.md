
<p align="center">
  <img src="https://img.shields.io/badge/flutter-2.0.0-52c6f9.svg?sanitize=true" alt="flutter-1.22">
  <img src="https://img.shields.io/badge/android✔-brightgreen.svg?sanitize=true" alt="android✔">
  <img src="https://img.shields.io/badge/ios✔-green.svg?sanitize=true" alt="ios✔">
</p>

<h2 align="center">斗鱼Flutter</h2>

flutter重构的斗鱼直播APP<br/>
首页、娱乐为Material组件；直播间、鱼吧为纯自定义编写。<br/>
另外整合各类优质的第三方开源库，打造出原生APP丝滑的用户体验<br/>
尽可能接入更多功能，方法附带注释，帮助你在使用flutter进行开发新的应用提供实用的借鉴案例<br/>

#### APP截图：

#### 包含功能：
- 启动页广告位
- 开播列表上拉加载、下拉刷新、返回顶部
- 列表图片缓存加载优化
- 渐进式头部动画
- 底部导航切换保存页面状态
- HTTP缓存、IO缓存
- 直播间webSocket消息弹幕、礼物
- 页面路由传值
- RxDart全局消息通信封装
- Bloc流式状态管理(启动页预加载首页数据)
- 礼物横幅动画队列
- 礼物特效全屏lottie
- 弹幕消息滚动
- 静态视频流
- 九宫格抽奖游戏
- 照片选择器
- 全屏、半屏webView
- 鱼吧头部手势动画
- 仿微信朋友圈图片控件
- 登录注册弹窗
- 国家区号列表(仿微信通讯录滑动首字母定位)
- 二维码扫码
- 本地通知推送
- ...
- 持续增加中

#### 本地调试：
`flutter run --release`打包发布版本预览<br/>
APP所有数据均来源Mock网络请求，服务端接口没有上云，可修改`lib/base.dart`中`DYBase.baseHost`为你的电脑IP，并确保手机与电脑在同一局域网且能访问内网`1236`端口<br/>
然后clone[服务端仓库](https://github.com/yukilzw/factory)，Mock服务为`python tornado`，两种简单启动方式可选：<br/>
1. 在py 3.6~3.8下启动服务
  - 安装`python3.6`环境;
  - cmd切换运行环境`cd ./tornado`;
  - 加载依赖包 `pip install -r requirements.txt`;
  - 启动服务`python main.py`
2. 使用Docker镜像，具体方式参考该项目说明。

安卓打包可能因为国内无法加载gradle的问题，就算配了镜像也很慢，建议手动下载`grdle-6.4.1-all.zip`版本再构建，下载安装可见[此文章](https://www.cnblogs.com/yehuabin/p/10344713.html)

#### 入门推荐：
[Dart语法](https://www.dartcn.com/guides/get-started) - 语法中文教程<br/>
[Flutter中文网](https://flutterchina.club/get-started/install/) - 简单易懂的入门教程<br/>
[Flutter实战](https://book.flutterchina.club/) - 较为全面的进阶教程<br/>
[Dart SDK（EN）](https://api.dartlang.org/stable/2.4.0/index.html) - flutter中可用的SDK<br/>
[Flutter官网（EN）](https://flutter.dev/docs) - 可查阅全部的API与SDK相关<br/>
[Bloc（EN）](https://felangel.github.io/bloc/#/gettingstarted) - 全局状态管理

#### dy_flutter为个人开源项目，仅用作学习实践
