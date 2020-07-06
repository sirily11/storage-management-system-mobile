import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:storage_management_mobile/DataObj/StorageItem.dart';
import 'package:storage_management_mobile/States/HomeProvider.dart';

import '../DataObj/StorageItem.dart';
import 'Detail/ItemDetailPage.dart';

class ItemDisplay extends StatelessWidget {
  final List<StorageItemAbstract> items;

  ItemDisplay({@required this.items});

  Widget itemIcon(String type) {
    switch (type) {
      case "Blu-ray":
        return Icon(Icons.video_library);

      default:
        return Icon(Icons.book);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (items == null) {
      return CircularProgressIndicator();
    }

    return Scrollbar(
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: items.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int i) {
            var item = items[i];
            return Slidable(
              key: Key(item.id.toString()),
              actionPane: SlidableDrawerActionPane(),
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: "Delete",
                  icon: Icons.delete,
                  color: Colors.red,
                  onTap: () async {
                    try {
                      HomeProvider provider =
                          Provider.of(context, listen: false);
                      await provider.remove(item);
                    } on Exception catch (err) {}
                  },
                )
              ],
              child: Column(
                children: <Widget>[
                  Card(
                    margin: new EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 6.0),
                    child: Container(
                      child: buildListTile(item, context),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  ListTile buildListTile(StorageItemAbstract item, BuildContext context) {
    return ListTile(
      leading: Container(
        decoration: BoxDecoration(
            border: Border(right: BorderSide(width: 1, color: Colors.white24))),
        child: Icon(
          Icons.book,
        ),
      ),
      title: Text(
        "${item.name}",
      ),
      subtitle: Text(
        "${item.authorName} - ${item.seriesName}",
      ),
      trailing: Text(
        "${item.position}\nRow:${item.row}: Col:${item.column}",
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
}
