import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_mapbox/models/error_response.dart';
import 'package:my_mapbox/network/api_routes.dart';
import 'package:my_mapbox/network/http_helper.dart';
import 'package:my_mapbox/network/search_address_response.dart';

const SEARCH_TAG = 'Search Service';

class SearchServices {
  Future<dynamic> searchAddress({
    @required String query,
  }) async {
    final url =
        ApiRoutes.dpsBaseUrl + '?token=${ApiRoutes.dpsToken}&value=$query';
    // 'https://dps.ethicaldigit.com/api/?token=aLy1EiehhwJF7SJ10Hb1Vxx7&value=1st%20street&fbclid=IwAR2Mh_7kJFR37DBsQ1LJhIe3Pa-XWL6I9ZbTflnkEG3bDxWKirpgpoOvjwk';

    final Map<String, String> param = {
      'token': ApiRoutes.dpsToken,
      'value': query,
    };

    var response;
    try {
      response = await getCall(
        tag: SEARCH_TAG,
        url: url,
      );
    } catch (e) {
      return ErrorResponseCodeAndMessage(code: null, message: 'No Connection!');
    }

    if (response != null) {
      Map<String, dynamic> resp = json.decode(response.body);
      int code = 0;
      resp.forEach(
        (key, value) {
          if (key == 'code') {
            code = value;
          }
        },
      );

      if (code == 200) {
        return SearchAddressResponse.fromJson(json.decode(response.body));
      } else if (code == 401) {
        return ErrorResponseCodeAndMessage.fromJson(json.decode(response.body));
      } else if (code == 404){
        return ErrorResponseCodeAndMessage.fromJson(json.decode(response.body));
      }
    }
  }
}
