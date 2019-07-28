import 'package:flutter/material.dart';
import 'package:mobile/Home/Homepage.dart';
import 'package:mobile/States/CameraState.dart';
import 'package:mobile/States/ItemDetailEditPageState.dart';
import 'package:provider/provider.dart';

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
        )
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: new ThemeData(primaryColor: Color.fromRGBO(58, 66, 86, 1.0)),
          home: Homepage()),
    );
  }
}
