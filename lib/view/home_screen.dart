import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:my_mapbox/providers/marker_dialog_provider.dart';
import 'package:my_mapbox/providers/location_provider.dart';
import 'package:my_mapbox/util/app_const.dart';
import 'package:my_mapbox/widgets/address_search.dart';
import 'package:provider/provider.dart';

class BaseHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MarkerDialogProvider(showDialog: false),
        ),
      ],
      child: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  static MapController _mapController = new MapController();
  static LocationProvider _locationProvider;

  void _currentLocation(BuildContext context) async {
    LocationData location = await AppConst.getLocation();

    _locationProvider.setLatLng = LatLng(location.latitude, location.longitude);
  }

  @override
  Widget build(BuildContext context) {
    _locationProvider = Provider.of<LocationProvider>(context, listen: false);
    _currentLocation(context);
    return Scaffold(
      body: _bodyWidget(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search, color: Colors.blue),
        backgroundColor: Colors.white,
        onPressed: () => showSearch(
          context: context,
          delegate: AddressSearch(onPressItem: (resp) {
            double lat = double.parse(resp.latitude);
            double long = double.parse(resp.longitude);

            _locationProvider.setLatLng = LatLng(lat, long);
            _mapController.move(LatLng(lat, long), 13);
          }),
        ),
      ),
    );
  }

  Widget _bodyWidget(BuildContext context) {
    final double halfScreen = MediaQuery.of(context).size.width / 2;

    return Consumer<LocationProvider>(
      builder: (context, locationProvider, child) {
        return FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            zoom: 13.0,
            center: locationProvider.getLatLng(),
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: AppConst.mapUrl,
              additionalOptions: {
                'accessToken': AppConst.mapToken,
                'id': 'mapbox.streets',
              },
            ),
            MarkerLayerOptions(
              markers: [
                new Marker(
                  width: halfScreen,
                  height: halfScreen,
                  point: locationProvider.getLatLng(),
                  builder: (_) => _createMarker(context),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _createMarker(BuildContext context) {
    return Consumer<MarkerDialogProvider>(
      builder: (context, markerProvider, child) {
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Visibility(
              visible: markerProvider.showDialog,
              child: Container(
                width: 250,
                height: 150,
                color: Colors.white,
              ),
            ),
            IconButton(
              iconSize: 32,
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
