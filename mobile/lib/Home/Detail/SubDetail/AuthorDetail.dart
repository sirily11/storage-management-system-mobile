import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile/DataObj/StorageItem.dart';

class AuthorDetail extends StatelessWidget{
  final Author author;
  AuthorDetail(this.author);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text(author.name),),
      body: ListView(children: <Widget>[
        ListTile(title: Text("作者名"), subtitle: Text(author.name),),
        ListTile(title: Text("作者简介"), subtitle: Text(author.description),)
      ],),
    );
  }

}