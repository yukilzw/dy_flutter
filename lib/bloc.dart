/**
 * @discripe: bloc全局状态管理
 */
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

enum CounterEvent { increment, decrement }

// 点击悬浮球增加当前直播数量
class CounterBloc extends Bloc<CounterEvent, int> {
  @override
  int get initialState => 21567;

  @override
  Stream<int> mapEventToState(CounterEvent event) async* {
    switch (event) {
      case CounterEvent.decrement:
        yield currentState - 1;
        break;
      case CounterEvent.increment:
        yield currentState + 1;
        break;
    }
  }
}

// 保存首页navList信息
abstract class TabEvent extends Equatable {
  TabEvent([List props = const []]) : super(props);
}

class UpdateTab extends TabEvent {
  final List tab;

  UpdateTab(this.tab) : super([tab]);

  @override
  String toString() => 'UpdateTab { tab: $tab }';
}


class TabBloc extends Bloc<TabEvent, List> {
  @override
  List get initialState => [];

  @override
  Stream<List> mapEventToState(TabEvent event) async* {
    if (event is UpdateTab) {
      yield event.tab;
    }
  }
}