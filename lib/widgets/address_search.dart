import 'package:flutter/material.dart';
import 'package:my_mapbox/models/error_response.dart';
import 'package:my_mapbox/models/search_address_response.dart';
import 'package:my_mapbox/providers/location_provider.dart';
import 'package:my_mapbox/providers/search_address_provider.dart';
import 'package:provider/provider.dart';

class AddressSearch extends SearchDelegate<SearchAddressResponse> {
  final ValueChanged<DPSData> onPressItem;

  AddressSearch({this.onPressItem});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: 'Clear',
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final searchProvider =
        Provider.of<SearchAddressProvider>(context, listen: false);
    return FutureBuilder(
        // We will put the api call here
        future: query.length >= 3
            ? searchProvider.searchAddress(query: query)
            : null,
        builder: (context, snapshot) {
          if (query == '') {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Text('Enter address'),
            );
          }

          if (snapshot.hasData) {
            if (snapshot.data is SearchAddressResponse) {
              return _listTile(context, snapshot.data);
            } else if (snapshot.data is ErrorResponseCodeAndMessage) {
              return Container(
                  alignment: Alignment.topCenter,
                  child: Text(
                    snapshot.data.message,
                  ));
            }
          }

          return Container(
            alignment: Alignment.topCenter,
            child: Text('Loading...'),
          );
        });
  }

  Widget _listTile(BuildContext context, SearchAddressResponse response) {
    return ListView.builder(
      itemCount: response.data.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            response.data[index].stNEng + ' ' + response.data[index].tspNEng,
          ),
          onTap: () async {
            onPressItem(response.data[index]);
            // double lat = double.parse(response.data[index].latitude);
            // double long = double.parse(response.data[index].longitude);
            // locationProvider.setLatLng = LatLng(lat, long);
            close(context, response);
          },
        );
      },
    );
  }
}
