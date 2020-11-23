import 'package:flutter/foundation.dart';
import 'package:my_mapbox/models/search_address_response.dart';

class DpsDataProvider with ChangeNotifier {
  DPSData dpsData;

  DpsDataProvider({this.dpsData});

  set setDpsData(DPSData data) {
    this.dpsData = data;
    notifyListeners();
  }
}
