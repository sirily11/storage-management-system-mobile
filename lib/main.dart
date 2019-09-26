import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'Home/Homepage.dart';
import 'States/ItemDetailState.dart';

Future<void> main() async {
  runApp(StorageManagement());
}

class StorageManagement extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          builder: (_) => ItemDetailState(),
        )
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: new ThemeData(
              brightness: Brightness.dark,
              scaffoldBackgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
              primaryColor: Color.fromRGBO(58, 66, 86, 1.0),
              textTheme: TextTheme(body1: TextStyle(color: Colors.white))),
          home: Homepage()),
    );
  }
}
