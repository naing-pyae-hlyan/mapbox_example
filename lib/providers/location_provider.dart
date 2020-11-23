import 'package:flutter/foundation.dart';
import 'package:latlong/latlong.dart';

class LocationProvider with ChangeNotifier {
  LatLng _latLng;

  LatLng getLatLng() {
    if (this._latLng == null) {
      this._latLng = LatLng(16.798759185125473, 96.14939761321457);
    }
    return this._latLng;
  }

  set setLatLng(LatLng latLng) {
    this._latLng = latLng;
    notifyListeners();
  }
}
