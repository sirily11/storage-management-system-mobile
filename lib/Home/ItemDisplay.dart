import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../DataObj/StorageItem.dart';
import '../utils/utils.dart';
import 'Detail/ItemDetailPage.dart';

class ItemDisplay extends StatelessWidget {
  final List<StorageItemAbstract> items;
  final Function removeItemById;

  ItemDisplay({@required this.items, @required this.removeItemById});

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

    return ListView.builder(
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
                    await removeItemById(item);
                    await removeItem(item);
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
                      decoration:
                          BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                      child: buildListTile(item, context),
                    )),
              ],
            ),
          );
        });
  }

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
        "${item.name}",
        style: TextStyle(color: Colors.white),
      ),
      subtitle: Text("${item.authorName} - ${item.seriesName}",
          style: TextStyle(color: Colors.white)),
      trailing: Text(
        "${item.position}\nRow:${item.row}: Col:${item.column}",
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
}