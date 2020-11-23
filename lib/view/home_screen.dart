import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:my_mapbox/providers//location_provider.dart';
import 'package:my_mapbox/providers//marker_dialog_provider.dart';
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

  void _currentLocation(BuildContext context) async {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);

    LocationData location = await AppConst.getLocation();

    locationProvider.setLatLng = LatLng(location.latitude, location.longitude);
  }

  // void _fabClick(BuildContext context) {
  // final locationProvider =
  //     Provider.of<LocationController>(context, listen: false);
  // locationProvider.setLatLng = LatLng(22.569254670014818, 95.68967653125696);
  // _mapController.move(locationProvider.getLatLng(), 13);
  // }

  Widget _searchWidget(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.all(12),
      child: TextFormField(
        onChanged: (value) {},
        cursorColor: Colors.white,
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: TextStyle(color: Colors.blue),
          suffixIcon: Icon(
            Icons.search,
            color: Colors.blue,
          ),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _currentLocation(context);
    return Scaffold(
      // extendBodyBehindAppBar: true,
      // appBar: AppBar(),
      body: _bodyWidget(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search, color: Colors.blue),
        backgroundColor: Colors.white,
        onPressed: () => showSearch(
          context: context,
          delegate: AddressSearch(),
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
                Marker(
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
