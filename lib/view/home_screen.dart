import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:my_mapbox/controller/location_controller.dart';
import 'package:my_mapbox/controller/marker_dialog_controller.dart';
import 'package:my_mapbox/util/app_const.dart';
import 'package:provider/provider.dart';

class BaseHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MarkerDialogController(showDialog: false),
        ),
      ],
      child: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  static MapController _mapController = new MapController();

  void _currentLocation(BuildContext context) async {
    final locationProvider =
        Provider.of<LocationController>(context, listen: false);

    LocationData location = await AppConst.getLocation();

    locationProvider.setLatLng = LatLng(location.latitude, location.longitude);
    // locationProvider.setLocation(
    //     lat: location.latitude, long: location.longitude);
  }

  void _fabClick(BuildContext context) {
    final locationProvider =
        Provider.of<LocationController>(context, listen: false);

    locationProvider.setLatLng = LatLng(22.569254670014818, 95.68967653125696);
    _mapController.move(locationProvider.getLatLng(), 13);
    // locationProvider.setLocation(
    //   lat: 22.569254670014818,
    //   long: 95.68967653125696,
    // );
  }

  @override
  Widget build(BuildContext context) {
    _currentLocation(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My MapBox'),
      ),
      body: _bodyWidget(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _fabClick(context),
        child: Icon(Icons.search),
      ),
    );
  }

  Widget _bodyWidget(BuildContext context) {
    final double helfScreen = MediaQuery.of(context).size.width / 2;

    return Consumer<LocationController>(
      builder: (context, locationProvider, child) {
        return FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            zoom: 13.0,
            center: locationProvider.getLatLng(),

            // LatLng(
            //   locationProvider.getLat(),
            //   locationProvider.getLong(),
            // ),
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: AppConst.fullURL,
              additionalOptions: {
                'accessToken': AppConst.TOKEN,
                'id': 'mapbox.streets',
              },
            ),
            MarkerLayerOptions(
              markers: [
                Marker(
                  width: helfScreen,
                  height: helfScreen,
                  point: locationProvider.getLatLng(),

                  // LatLng(
                  //   locationProvider.getLat(),
                  //   locationProvider.getLong(),
                  // ),
                  builder: (_) => _createMarker(context),
                )
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _createMarker(BuildContext context) {
    return Consumer<MarkerDialogController>(
      builder: (context, markerProvider, child) {
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Visibility(
              visible: markerProvider.showDialog,
              child: Container(
                width: 150,
                height: 150,
                color: Colors.white,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.location_on,
                color: Colors.blue,
              ),
              onPressed: () {
                markerProvider.setDialog = !markerProvider.showDialog;
              },
            ),
          ],
        );
      },
    );
  }
}
