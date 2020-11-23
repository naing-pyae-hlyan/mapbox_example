import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:my_mapbox/providers/dps_data_provider.dart';
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
  static DpsDataProvider _dpsProvider;

  void _initProvider(BuildContext context) {
    _locationProvider = Provider.of<LocationProvider>(context, listen: false);
    _dpsProvider = Provider.of<DpsDataProvider>(context, listen: false);
  }

  void _currentLocation(BuildContext context) async {
    LocationData location = await AppConst.getLocation();

    _locationProvider.setLatLng = LatLng(location.latitude, location.longitude);
  }

  @override
  Widget build(BuildContext context) {
    _initProvider(context);
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
            _dpsProvider.setDpsData = resp;
            _mapController.move(LatLng(lat, long), 13);
          }),
        ),
      ),
    );
  }

  Widget _bodyWidget(BuildContext context) {
    final double halfScreen = MediaQuery.of(context).size.width / 1.5;

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
                  height: halfScreen / 1.5,
                  point: locationProvider.getLatLng(),
                  builder: (_) => _createMarker(context, halfSize: halfScreen),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _createMarker(BuildContext context, {double halfSize}) {
    return Consumer<MarkerDialogProvider>(
      builder: (context, markerProvider, child) {
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Visibility(
              visible: markerProvider.showDialog,
              child: _dpsProvider.dpsData == null
                  ? SizedBox()
                  : Container(
                      width: halfSize,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${_dpsProvider.dpsData.dPSID}'),
                          Text('${_dpsProvider.dpsData.wardNEng}'),
                          Text('${_dpsProvider.dpsData.tspNEng}'),
                          Text('${_dpsProvider.dpsData.distNEng}'),
                          Text('${_dpsProvider.dpsData.sRNEng}'),
                        ],
                      )),
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
