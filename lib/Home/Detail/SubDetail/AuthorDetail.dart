import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../../DataObj/StorageItem.dart';
import 'DetailedCard.dart';

class AuthorDetail extends StatelessWidget {
  final Author author;
  AuthorDetail(this.author);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: AppBar(
        title: Text(author.name),
      ),
      body: ListView(
        children: <Widget>[
          DetailedCard(
            title: "作者名",
            subtitle: author.name,
          ),
          DetailedCard(
            title: "作者简介",
            subtitle: author.description,
          ),
        ],
      ),
    );
  }
}
