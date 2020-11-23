import 'package:flutter/foundation.dart';
import 'package:my_mapbox/network/search_services.dart';

class SearchAddressProvider with ChangeNotifier {
  Future<dynamic> searchAddress({
    @required String query,
  }) async {
    return SearchServices().searchAddress(
      query: query,
    );
  }
}
