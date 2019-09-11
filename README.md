## 斗鱼APP by Flutter
![Flutter](https://img.shields.io/badge/Flutter-1.7.8-5bc7f8.svg) ![Dart](https://img.shields.io/badge/Dart-2.4.0%2B-00B4AB.svg) 

flutter重构的斗鱼直播APP，接口源来自于服务端[MOCK数据中心](https://github.com/yukilzw/factory/blob/master/py/tornado/flutter_data.py)<br/>

#### 包含功能：

- 开播列表上拉加载、下拉刷新
- 渐进式导航头部
- 封装HTTP、IO缓存操作
- 页面路由传值
- bloc全局状态管理
- 礼物横幅动画队列
- 弹幕消息滚动
- 静态视频流
- 九宫格抽奖游戏
- 照片选择
- 全屏、窗口webView
- ...（持续增加中）

#### APP截图：
<img src="http://r.photo.store.qq.com/psb?/V14dALyK4PrHuj/hQczSj5NliQQyOggCfbBU365lpGmqjEIjLlWKTEP1d0!/r/dL8AAAAAAAAA" width="280"/> <img src="http://r.photo.store.qq.com/psb?/V14dALyK4PrHuj/ihs1e7eg5Nm4yBi8oe0Mt0WqV.DfQCOa0mWDZ0jyPg4!/r/dMMAAAAAAAAA" width="280"/>
<br/>
<img src="http://r.photo.store.qq.com/psb?/V14dALyK4PrHuj/c4ql4M5xWstDQx.QsoTQOTZCw7UuPf9zUgCjqG23tOo!/r/dLYAAAAAAAAA" width="280"/> <img src="http://r.photo.store.qq.com/psb?/V14dALyK4PrHuj/aF9iAvcPD06FGIHKJjwWEopdpLPWSd.Xy9vjyhYQs7o!/r/dL4AAAAAAAAA" width="280"/>

#### 调试
如需本地启动该项目调试，可修改`lib/base.dart`中`DYBase.baseUrl`接口域名为本机ip:port<br/>
然后clone[服务端仓库](https://github.com/yukilzw/factory)，安装python3与tornado，命令行cd进入`./py/tornado`文件夹执行`python main.py`启动服务<br/>
个人项目，仅供学习交流用