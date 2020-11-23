import 'package:flutter/foundation.dart';
import 'package:latlong/latlong.dart';

class LocationController with ChangeNotifier {
  // double _geoLat, _geoLong;
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

  // double getLat() {
  //   if (this._geoLat == null) {
  //     return 16.798759185125473;
  //   }
  //   return this._geoLat;
  // }
  //
  // double getLong() {
  //   if (this._geoLong == null) {
  //     return 96.14939761321457;
  //   }
  //   return this._geoLong;
  // }
  //
  // void setLocation({@required double lat, @required double long}) {
  //   this._geoLat = lat;
  //   this._geoLong = long;
  //   notifyListeners();
  // }
}
