## 斗鱼APP
![Flutter](https://img.shields.io/badge/Flutter-1.7.8%2B-5bc7f8.svg) ![Dart](https://img.shields.io/badge/Dart-2.4.0%2B-00B4AB.svg) 

flutter重构的斗鱼直播APP<br/>
基于Material原生Widget开发，外加各类优质的第三方开源库，打造出优于原生APP的用户体验<br/>
尽可能接入更多功能，帮助你在使用flutter进行开发新的应用提供实用的借鉴案例<br/>

#### 包含功能：

- 启动页广告位
- 开播列表上拉加载、下拉刷新、返回顶部
- 列表图片缓存加载优化
- 渐进式头部动画
- 底部导航切换保存页面状态
- HTTP缓存、IO缓存
- 直播间webSocket消息弹幕、礼物
- 页面路由传值
- Bloc全局状态管理(启动页预加载首页数据)
- 礼物横幅动画队列
- 弹幕消息滚动
- 静态视频流
- 九宫格抽奖游戏
- 照片选择器
- 全屏、半屏webView
- ...（持续增加中）

#### APP截图：
<img src="http://r.photo.store.qq.com/psb?/V14dALyK4PrHuj/OFSw8qFQ6ZTt4Qry.FD5zxLEOyTxOJDRc0zUeDKvTgU!/r/dMMAAAAAAAAA" width="280"/> | <img src="http://r.photo.store.qq.com/psb?/V14dALyK4PrHuj/5I7nPNCsk6rawRlhX5DvnmJr9akVwt1*XQIQHTJ1uy0!/r/dDIBAAAAAAAA" width="280"/> |
-|-
<img src="http://r.photo.store.qq.com/psb?/V14dALyK4PrHuj/PiWK848iFea5HhE8XPuJnU2y8CPRpn91zuSYejmfu7s!/r/dL8AAAAAAAAA" width="280"/> | <img src="http://r.photo.store.qq.com/psb?/V14dALyK4PrHuj/c4ql4M5xWstDQx.QsoTQOTZCw7UuPf9zUgCjqG23tOo!/r/dLYAAAAAAAAA" width="280"/> |
<img src="http://r.photo.store.qq.com/psb?/V14dALyK4PrHuj/uPUfvzq6QWWJjmkf*OkmzHV6apSbGKK9FPXXC8itWH8!/r/dMMAAAAAAAAA" width="280"/> | <img src="http://r.photo.store.qq.com/psb?/V14dALyK4PrHuj/FDYCtFUGAS.FMi0oCu0wzIGhFK3BDzubAXdlZbStLyg!/r/dFIBAAAAAAAA" width="280"/> |

#### 调试：
服务端接口没有上云，如需本地启动该项目调试，可修改`lib/base.dart`中`DYBase.baseUrl`接口域名为本机ip:port<br/>
然后clone[服务端仓库](https://github.com/yukilzw/factory)，安装python3与tornado，requests，命令行cd进入`./py/tornado`文件夹执行`python main.py`启动服务<br/>

#### 建议：
使用Material自带的widget进行搭配使用，已经能满足绝大部分场景的开发需求<br/>
但是在企业级APP高度UI交互定制化的场景下，仍需要根据业务场景重新实现诸如AppBar、TabView等widget<br/><br/>


#### dy_flutter为个人试验项目，仅供学习借鉴用
