import 'package:hive/hive.dart';

int put(String s) {
  var box = Hive.box('myBox');
  if (s == null) {
    box.put('state', "null");
    return 0;
  }
  box.put('state', s);
  return 1;
}

String get() {
  var box = Hive.box('myBox');

  var state = box.get('state');

  return state;
}
