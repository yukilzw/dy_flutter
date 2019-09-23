/**
 * @discripe: bloc全局状态管理
 */
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

enum CounterEvent { increment, reset }

// 直播列表页码
class CounterBloc extends Bloc<CounterEvent, int> {
  @override
  int get initialState => 1;

  @override
  Stream<int> mapEventToState(CounterEvent event) async* {
    switch (event) {
      case CounterEvent.reset:
        yield 1;
        break;
      case CounterEvent.increment:
        yield currentState + 1;
        break;
    }
  }
}

// 启动页预加载首页信息
abstract class IndexEvent extends Equatable {
  IndexEvent([List props = const []]) : super(props);
}

class UpdateTab extends IndexEvent {
  final List tab;
  UpdateTab(this.tab) : super([tab]);
}

class UpdateLiveData extends IndexEvent {
  final List liveData;
  UpdateLiveData(this.liveData) : super([liveData]);
}

class UpdateSwiper extends IndexEvent {
  final List swiper;
  UpdateSwiper(this.swiper) : super([swiper]);
}

class IndexBloc extends Bloc<IndexEvent, Map> {
  @override
  Map get initialState => {
    'nav': [],
    'liveData': [],
    'swiper': []
  };

  @override
  Stream<Map> mapEventToState(IndexEvent event) async* {
    if (event is UpdateTab) {
      currentState.addAll({
        'nav': event.tab
      });
      yield currentState;
    } else if (event is UpdateLiveData) {
      currentState.addAll({
        'liveData': event.liveData
      });
      yield currentState;
    } else if (event is UpdateSwiper) {
      currentState.addAll({
        'swiper': event.swiper
      });
      yield currentState;
    }
  }
}