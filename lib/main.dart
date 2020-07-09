import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:provider/provider.dart';
import 'package:storage_management_mobile/States/LoginProvider.dart';
import 'package:storage_management_mobile/pages/Loading/LoadingScreen.dart';

import 'States/HomeProvider.dart';
import 'States/ItemProvider.dart';

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
          create: (_) => ItemProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => HomeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LoginProvider(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        themeMode: ThemeMode.system,
        theme: Theme.of(context).copyWith(accentColor: Colors.black),
        darkTheme: ThemeData.dark(),
        onGenerateRoute: (settings) {
          return MaterialWithModalsPageRoute(
            settings: settings,
            builder: (context) => Container(),
          );
        },
        routes: {
          '/': (c) => CupertinoScaffold(
                body: LoadingScreen(),
              )
        },
      ),
    );
  }
}
