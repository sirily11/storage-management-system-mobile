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
        themeMode: ThemeMode.system,
        theme: Theme.of(context).copyWith(accentColor: Colors.black),
        darkTheme: ThemeData.dark(),
        home: Homepage(),
      ),
    );
  }
}
