/*
 * @discripe: bloc全局状态管理
 */
import 'package:bloc/bloc.dart';

abstract class BlocObj {
  static final counter = CounterBloc();
  static final index = IndexBloc();
}

// 直播列表页码
enum CounterEvent { increment, reset }
class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(1);

  @override
  Stream<int> mapEventToState(CounterEvent event) async* {
    switch (event) {
      case CounterEvent.reset:
        yield 1;
        break;
      case CounterEvent.increment:
        yield state + 1;
        break;
    }
  }
}

// 启动页预加载首页信息
abstract class IndexEvent {}

class UpdateTab implements IndexEvent {
  final List tab;
  UpdateTab(this.tab);
}

class UpdateLiveData implements IndexEvent {
  final List liveData;
  UpdateLiveData(this.liveData);
}

class UpdateSwiper implements IndexEvent {
  final List swiper;
  UpdateSwiper(this.swiper);
}

class IndexBloc extends Bloc<IndexEvent, Map> {
  IndexBloc() : super({
    'nav': [],
    'liveData': [],
    'swiper': []
  });

  @override
  Stream<Map> mapEventToState(IndexEvent event) async* {
    if (event is UpdateTab) {
      yield { ...state, 'nav': event.tab };
    } else if (event is UpdateLiveData) {
      yield { ...state, 'liveData': event.liveData };
    } else if (event is UpdateSwiper) {
      yield { ...state, 'swiper': event.swiper };
    }
  }
}