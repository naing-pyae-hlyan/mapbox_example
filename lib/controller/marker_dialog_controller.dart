import 'package:flutter/foundation.dart';

class MarkerDialogController with ChangeNotifier {
  bool showDialog;

  MarkerDialogController({this.showDialog = false});

  set setDialog(bool b) {
    this.showDialog = b;
    notifyListeners();
  }
}
