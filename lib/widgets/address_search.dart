import 'package:flutter/material.dart';
import 'package:my_mapbox/models/error_response.dart';
import 'package:my_mapbox/network/search_address_response.dart';
import 'package:my_mapbox/providers/search_address_provider.dart';
import 'package:provider/provider.dart';

class AddressSearch extends SearchDelegate<SearchAddressResponse> {
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
    final provider = Provider.of<SearchAddressProvider>(context, listen: false);
    return FutureBuilder(
        // We will put the api call here
        future: provider.searchAddress(query: query),
        builder: (context, snapshot) {
          if (query == '') {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Text('Enter address'),
            );
          }

          if (snapshot.hasData) {
            if (snapshot.data is SearchAddressResponse) {
              return ListView.builder(
                itemCount: snapshot.data.data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(snapshot.data.data[index].sRNEng),
                    onTap: () {
                      close(context, snapshot.data);
                    },
                  );
                },
              );
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
}
