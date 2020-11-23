import 'package:flutter/foundation.dart';

class SearchProvider with ChangeNotifier {
  String _value;

  String get value => _value;

  set value(String value) {
    if (_value == value) {
      return;
    }

    _value = value;
    notifyListeners();
  }
}