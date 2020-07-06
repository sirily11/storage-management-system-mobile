import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:provider/provider.dart';

import 'States/HomeProvider.dart';
import 'States/ItemProvider.dart';
import 'pages/Home/Homepage.dart';

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
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        themeMode: ThemeMode.system,
        theme: Theme.of(context).copyWith(accentColor: Colors.black),
        darkTheme: ThemeData.dark(),
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
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

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HomeProvider homeProvider = Provider.of(context);
    ItemProvider itemProvider = Provider.of(context);

    Widget widget = Container(
      color: Theme.of(context).scaffoldBackgroundColor,
    );

    if (homeProvider.baseURL != null && itemProvider.baseURL != null) {
      widget = Homepage();
    }

    return AnimatedSwitcher(
      duration: Duration(seconds: 1),
      child: widget,
    );
  }
}
