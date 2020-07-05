import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:storage_management_mobile/DataObj/StorageItem.dart';
import 'package:storage_management_mobile/Home/Detail/ItemDetailPage.dart';

class SearchListPage extends StatelessWidget {
  final List<StorageItemAbstract> items;
  SearchListPage({this.items});

  ListTile buildListTile(StorageItemAbstract item, BuildContext context) {
    return ListTile(
      leading: Container(
        decoration: BoxDecoration(
            border: Border(right: BorderSide(width: 1, color: Colors.white24))),
        child: Icon(
          Icons.book,
          color: Colors.white,
        ),
      ),
      title: Text(
        "${item?.name}",
        style: TextStyle(color: Colors.white),
      ),
      subtitle: Text("${item?.authorName} - ${item?.seriesName}",
          style: TextStyle(color: Colors.white)),
      trailing: Text(
        "${item?.position}\nRow:${item?.row}: Col:${item?.column}",
        style: TextStyle(color: Colors.white),
      ),
      onTap: () {
        Navigator.of(context).push(CupertinoPageRoute(builder: (context) {
          return ItemDetailPage(
            id: item.id,
            name: item.name,
            series: item.seriesName,
            author: item.authorName,
          );
        }));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(items.length > 0 ? items.first.position : ""),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (c, i) {
          var item = items[i];
          return Card(
            margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: Container(
              child: buildListTile(item, context),
            ),
          );
        },
      ),
    );
  }
}
