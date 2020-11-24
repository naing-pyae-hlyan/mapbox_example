import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class MapControllerProvider with ChangeNotifier {
  MapController mapController;

  MapControllerProvider({this.mapController});

  void move(LatLng center, double zoom){
    this.mapController.move(center, zoom);
    notifyListeners();
  }
}
