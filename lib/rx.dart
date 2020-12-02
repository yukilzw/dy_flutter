/*
 * @discripe: RxDart全局消息通信封装处理
 */
import 'package:rxdart/rxdart.dart';

class _Rx {
  final _subject = PublishSubject<List>();
  Map<String, Map<String, List<Function>>> _signMapping = {};

  _Rx() {
    _subject.listen((addArg) {
      String sign = addArg[0];
      var data = addArg[1];
      if (_signMapping[sign] != null) {
        _signMapping[sign].forEach((name, callBackList) {
          callBackList.forEach((callBack) {
            callBack(data);
          });
        });
      }
    });
  }
  void push(String sign, { dynamic data }) {
    _subject.add([sign, data]);
  }
  // 参数name为销毁监听标识，当同一个sign被多个模块监听时，销毁方法unSubscribe只会销毁对应name的监听，不传入会销毁当前sign的所有注册回调
  void subscribe(String sign, void Function(dynamic data) callBack, { String name = '' }) {
    if (_signMapping[sign] == null) {
      _signMapping[sign] = {
        name: [callBack]
      };
    } else if (_signMapping[sign][name] == null) {
      _signMapping[sign][name] = [callBack];
    } else {
      _signMapping[sign][name].add(callBack);
    }
  }
  void unSubscribe(String sign, { String name = '' }) {
    if (_signMapping[sign] != null && _signMapping[sign][name] is List<Function>) {
      _signMapping[sign].remove(name);
    }
  }
}

final rx = _Rx();