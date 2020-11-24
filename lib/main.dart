import 'package:flutter/material.dart';
import 'package:my_mapbox/providers/dps_data_provider.dart';
import 'package:my_mapbox/providers/location_provider.dart';
import 'package:my_mapbox/providers/search_address_provider.dart';
import 'package:my_mapbox/view/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LocationProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => SearchAddressProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => DpsDataProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DPS Map',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BaseHomePage(),
    );
  }
}
