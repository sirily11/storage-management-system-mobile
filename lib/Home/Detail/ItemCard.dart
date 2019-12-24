import 'package:flutter/material.dart';

class Info {
  String title;
  String subtitle;
  Function onPress;

  Info({@required this.title, @required this.subtitle, this.onPress});
}

class CardInfo extends StatelessWidget {
  final List<Info> info;

  CardInfo({@required this.info});

  @override
  Widget build(BuildContext context) {
    return Row(
        children: this.info.map((i) {
      return _card(i);
    }).toList());
  }

  Flexible _card(Info i) {
    return Flexible(
      flex: 1,
      child: Card(
        child: Container(
          child: ListTile(
            title: Text(
              i.title ?? "",
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              i.subtitle ?? "",
              style: TextStyle(color: Colors.white),
            ),
            trailing: i.onPress != null
                ? Icon(
                    Icons.more_horiz,
                    color: Colors.white,
                  )
                : null,
            onTap: i.onPress,
          ),
        ),
      ),
    );
  }
}
