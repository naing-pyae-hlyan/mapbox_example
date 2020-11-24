import 'package:flutter/material.dart';
import 'package:my_mapbox/models/search_address_response.dart';

void showMarkerDataSheet(BuildContext context, {@required DPSData dpsData}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => MarkerDataSheet(dpsData: dpsData),
  );
}

class MarkerDataSheet extends StatelessWidget {
  final DPSData dpsData;
  static double width;

  MarkerDataSheet({this.dpsData});

  @override
  Widget build(BuildContext context) {
    width = MediaQuery
        .of(context)
        .size
        .width;
    return Wrap(
      children: [
        Container(
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _itemsText(key: 'DPS ID: ', value: dpsData.dPSID),
              _itemsText(key: 'House Number:', value: dpsData.hNEng),
              _itemsText(key: 'Postal Code:', value: dpsData.postalCod),
              _itemsText(key: 'Street:', value: dpsData.stNEng),
              _itemsText(key: 'Ward:', value: dpsData.wardNEng),
              _itemsText(key: 'Township:', value: dpsData.tspNEng),
              _itemsText(key: 'District:', value: dpsData.distNEng),
              _itemsText(key: 'State:', value: dpsData.sRNEng),
              _itemsText(key: 'Country:', value: dpsData.countryN),
              _itemsText(key: 'Latitude:', value: dpsData.latitude),
              _itemsText(key: 'Longitude:', value: dpsData.longitude),
            ],
          ),
        )
      ],
    );
  }

  Widget _itemsText({String key, String value}) {
    return Container(
      margin: const EdgeInsets.all(4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: width / 3, child: Text('$key')),

          Expanded(
            child: Text(
              '$value',
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              softWrap: true,
            ),
          )
        ],
      ),
    );
  }
}
