import 'package:flutter/material.dart';
import 'package:mobile/Home/Detail/ItemDetailPage.dart';
import 'package:mobile/Home/Homepage.dart';
import 'package:mobile/States/CameraState.dart';
import 'package:mobile/States/ItemDetailEditPageState.dart';
import 'package:provider/provider.dart';

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
          builder: (_) => ItemDetailEditPageState(),
        ),
        ChangeNotifierProvider(
          builder: (_) => CameraState(),
        ),
         ChangeNotifierProvider(
          builder: (_) => ItemDetailState(),
        )
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: new ThemeData(
              primaryColor: Color.fromRGBO(58, 66, 86, 1.0),
              primaryColorDark: Colors.red,
              textTheme: TextTheme(body1: TextStyle(color: Colors.white))),
          home: Homepage()),
    );
  }
}
