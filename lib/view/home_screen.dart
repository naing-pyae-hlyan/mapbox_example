import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:my_mapbox/network/http_helper.dart';
import 'package:my_mapbox/providers/dps_data_provider.dart';
import 'package:my_mapbox/providers/map_controller_providers.dart';
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
        ChangeNotifierProvider(
          create: (_) =>
              MapControllerProvider(mapController: new MapController()),
        ),
      ],
      child: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  static MapControllerProvider _mapControllerProvider;
  static LocationProvider _locationProvider;
  static DpsDataProvider _dpsProvider;
  static int count = 0;

  void _initProvider(BuildContext context) {
    _locationProvider = Provider.of<LocationProvider>(context, listen: false);
    _dpsProvider = Provider.of<DpsDataProvider>(context, listen: false);
    _mapControllerProvider =
        Provider.of<MapControllerProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    _initProvider(context);
    return Scaffold(
      body: _bodyWidget(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search, color: Colors.blue),
        backgroundColor: Colors.white,
        onPressed: () => showSearch(
          context: context,
          delegate: AddressSearch(onPressItem: (resp) async {
            double lat = double.parse(resp.latitude);
            double long = double.parse(resp.longitude);

            _locationProvider.setLatLng = LatLng(lat, long);
            _dpsProvider.setDpsData = resp;
            _mapControllerProvider.move(LatLng(lat, long), 13.0);
          }),
        ),
      ),
    );
  }

  Widget _bodyWidget(BuildContext context) {
    final double halfScreen = MediaQuery.of(context).size.width / 1.5;

    return Consumer2<LocationProvider, MapControllerProvider>(
      builder: (context, locationProvider, mapControllerProvider, child) {
        myLog('Location',
            '${locationProvider.getLatLng.latitude} : ${locationProvider.getLatLng.longitude}');
        return FlutterMap(
          mapController: mapControllerProvider.mapController,
          options: MapOptions(
            zoom: 13.0,
            center: locationProvider.getLatLng,
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
                Marker(
                  width: halfScreen,
                  height: halfScreen / 1.5,
                  point: locationProvider.getLatLng,
                  anchorPos: AnchorPos.align(AnchorAlign.bottom),
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
        return Column(
          children: [

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
          ],
        );
      },
    );
  }
}
