import 'package:location/location.dart';

class AppConst {
  static final mapUrl =
      // Street Map
      'https://api.mapbox.com/styles/v1/naingpyaehlyan/ckhvlx3jy0imm19pmp3biaom1/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibmFpbmdweWFlaGx5YW4iLCJhIjoiY2todTBpb3cyMDFkbjJ5bWxhYnpub3RoeiJ9.Ptipl9UsY0PygJ_5P_PkBw';

  //Basic Map  // 'https://api.mapbox.com/styles/v1/naingpyaehlyan/ckhu4ujn71ojn19p6dq9ozm4t/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibmFpbmdweWFlaGx5YW4iLCJhIjoiY2todTBpb3cyMDFkbjJ5bWxhYnpub3RoeiJ9.Ptipl9UsY0PygJ_5P_PkBw';
  static final mapToken =
      'pk.eyJ1IjoibmFpbmdweWFlaGx5YW4iLCJhIjoiY2todTBpb3cyMDFkbjJ5bWxhYnpub3RoeiJ9.Ptipl9UsY0PygJ_5P_PkBw';

  static get getLat async {
    var location = await getLocation();
    double let = location == null ? 16.798759185125473 : location.latitude;
    return let;
  }

  static get getLong async {
    var location = await getLocation();
    double long = location == null ? 96.14939761321457 : location.longitude;

    return long;
  }

  static Future<LocationData> getLocation() async {
    var location = new Location();
    LocationData locationData;

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return locationData;
      }
    }

    PermissionStatus permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        return locationData;
      }
    }

    try {
      locationData = await location.getLocation();
    } catch (e) {
      print(e);
    }

    return locationData;
  }
}
