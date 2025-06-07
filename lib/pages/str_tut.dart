import 'dart:async';

StreamController<List<dynamic>> _streamController =
    StreamController<List<dynamic>>();

get _stream => _streamController.stream;

void main() {
  _streamController.add(['Hello', 'World']);
  _addData();
  _stream.listen((data) {
    print(data.runtimeType);
    for (var item in data) {
      print(item);
    }
  });
}

void _addData() async {
  for (var i = 0; i < 20; i++) {
    _streamController.add(['Item $i']);
    await Future.delayed(Duration(seconds: 1));
  }
}
