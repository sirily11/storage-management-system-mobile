import 'package:flutter/material.dart';

class DetailedCard extends StatelessWidget {
  final String title;
  final String subtitle;

  DetailedCard({this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Container(
            child: ListTile(
                title: Text(
                  this.title,
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  this.subtitle,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  maxLines: 30,
                  style: TextStyle(color: Colors.white),
                ))));
  }
}
