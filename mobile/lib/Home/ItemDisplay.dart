import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile/DataObj/StorageItem.dart';

import 'package:mobile/Home/Detail/ItemDetailPage.dart';

class ItemDisplay extends StatelessWidget {
  final List<StorageItemAbstract> _items;

  ItemDisplay(this._items);

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
    if (_items == null) {
      return CircularProgressIndicator();
    }

    return ListView.builder(
        itemCount: 2 * _items.length,
        itemBuilder: (BuildContext context, int i) {
          if (i.isOdd) return Divider();
          final index = i ~/ 2;
          var item = _items[index];
          print(item);
          return ListTile(
            leading: itemIcon(item.categoryName),
            title: Text("${item.name}"),
            subtitle: Text("${item.authorName} - ${item.seriesName}"),
            trailing:
                Text("${item.position}\nRow:${item.row}: Col:${item.column}"),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return ItemDetailPage(
                  item.id,
                  name: item.name,
                  series: item.seriesName,
                  author: item.authorName,
                );
              }));
            },
          );
        });
  }
}
