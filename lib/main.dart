/*
 * @discripe: 斗鱼APP
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'base.dart';
import 'dy_init/index.dart';
import 'dy_index/index.dart';
import 'dy_room/index.dart';
import 'dy_login/index.dart';
import 'develop/index.dart';

class DyApp extends StatelessWidget {
  // 路由路径匹配
  Route<dynamic> _getRoute(RouteSettings settings) {
    Map<String, WidgetBuilder> routes = {
      '/': (BuildContext context) => SplashPage(),
      '/index': (BuildContext context) => DyIndexPage(),
      '/room': (BuildContext context) => DyRoomPage(arguments: settings.arguments),
      '/login': (BuildContext context) => DyLoginPage(arguments: settings.arguments),
      '/webView': (BuildContext context) {  // webView全屏容器
        Map arg = settings.arguments;
        return WebviewScaffold(
          url: arg['url'],
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: DYBase.defaultColor,
            brightness: Brightness.dark,
            textTheme: TextTheme(
              headline6: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            title: Text(arg['title']),
          ),
        );
      },
      '/develop': (BuildContext context) => DevelopPage(),
    };
    var widget = routes[settings.name];

    if (widget != null) {
      return MaterialPageRoute<void>(
        settings: settings,
        builder: widget,
      );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(     // 多个Bloc注册
      providers: [
        BlocProvider<CounterBloc>(
          create: (context) => BlocObj.counter,
        ),
        BlocProvider<IndexBloc>(
          create: (context) => BlocObj.index,
        ),
      ],
      child: MaterialApp(
        title: '斗鱼',
        theme: ThemeData(
          scaffoldBackgroundColor: Color.fromARGB(255, 255, 255, 255),
          primarySwatch: Colors.orange,
          textTheme: TextTheme(
            bodyText1: TextStyle(color: Colors.black),
          ),
          appBarTheme: AppBarTheme(
            textTheme: TextTheme(
              headline6: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
              bodyText1: TextStyle(color: Colors.black),
            ),
          )
          // splashFactory: NoSplashFactory()
        ),
        onGenerateRoute: _getRoute,
      ),
    );
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // 强制竖屏
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(DyApp());
}