import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storage_management_mobile/States/HomeProvider.dart';
import 'package:storage_management_mobile/States/ItemProvider.dart';
import 'package:storage_management_mobile/States/LoginProvider.dart';
import 'package:storage_management_mobile/pages/Home/Homepage.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    LoginProvider loginProvider = Provider.of(context, listen: false);

    loginProvider.autoSignIn().catchError((err) => print(err));
  }

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
