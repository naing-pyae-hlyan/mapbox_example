import 'package:flutter/material.dart';
import 'package:my_mapbox/models/search_address_response.dart';
import 'package:my_mapbox/providers/search_address_provider.dart';
import 'package:my_mapbox/providers/search_provider.dart';
import 'package:provider/provider.dart';

void showSearchWidget(BuildContext context) {
  showModalBottomSheet(
      context: context,
      // backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return BaseSearchWidget();
      });
}

class BaseSearchWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SearchProvider()),
      ],
      child: SearchWidget(),
    );
  }
}

class SearchWidget extends StatelessWidget {
  static SearchProvider _searchProvider;

  @override
  Widget build(BuildContext context) {
    _searchProvider = Provider.of<SearchProvider>(context, listen: false);

    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Text('Hello'),
            _searchWidget(context),
            _dpsList(context),
            SizedBox(
              height: 500,
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchWidget(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.all(12),
      child: TextFormField(
        onChanged: (value) => _searchProvider.value = value,
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: TextStyle(color: Colors.white),
          suffixIcon: Icon(Icons.search),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: Colors.cyan,
      ),
    );
  }

  Widget _dpsList(BuildContext context) {
    final provider = Provider.of<SearchAddressProvider>(context, listen: false);
    return FutureBuilder(
      future: provider.searchAddress(query: ''),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container();
        }

        if (snapshot.hasData) {
          if (snapshot.data is SearchAddressResponse) {
            return _listView(context, snapshot.data.data);
          } else {
            return Text('Cant find');
          }
        }

        return Center(child: CircularProgressIndicator(),);
      },
    );
  }

  Widget _listView(BuildContext context, List<DPSData> data) {
    return ListView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemCount: data.length,
      itemBuilder: (context, index) {
        return Text(data[index].distNMyn);
      },
    );
  }
}
