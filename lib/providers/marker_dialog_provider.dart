import 'package:flutter/foundation.dart';

class MarkerDialogProvider with ChangeNotifier {
  bool showDialog;

  MarkerDialogProvider({this.showDialog = false});

  set setDialog(bool b) {
    this.showDialog = b;
    notifyListeners();
  }
}
