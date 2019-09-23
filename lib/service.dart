import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

import 'bloc.dart';
import 'base.dart';

abstract class DYservice {
  // 获取直播间列表
  static Future<List> getLiveData(context, [ pageIndex ]) async {
    final counterBloc = BlocProvider.of<CounterBloc>(context);
    int livePageIndex = BlocObj.counter.currentState;

    var res = await httpClient.get(
      API.liveData,
      queryParameters: {
        'page': pageIndex == null ? livePageIndex : pageIndex
      },
      options: livePageIndex == 1 ? buildCacheOptions(
        Duration(minutes: 30),
      ) : null,
    );

    counterBloc.dispatch(CounterEvent.increment);
    return res.data['data']['list'];
  }
}