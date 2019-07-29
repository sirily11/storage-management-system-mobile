import 'package:flutter/material.dart';

class CardSelectorTheme extends StatelessWidget {
  final Widget child;

  CardSelectorTheme({this.child});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: new ThemeData(
          hintColor: Colors.white,
          focusColor: Colors.white,
          accentColor: Colors.white,
          primaryColor: Colors.orange[300],
          primaryColorDark: Colors.white,
          canvasColor: Colors.blueGrey),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: child,
      ),
    );
  }
}
