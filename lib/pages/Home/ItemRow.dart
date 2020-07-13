import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:provider/provider.dart';
import 'package:storage_management_mobile/DataObj/StorageItem.dart';
import 'package:storage_management_mobile/States/HomeProvider.dart';
import 'package:storage_management_mobile/pages/utils/ConfirmDialog.dart';
import 'Detail/ItemDetailPage.dart';

/// Render list of items
class ItemRow extends StatelessWidget {
  final StorageItemAbstract item;

  ItemRow({@required this.item});

  @override
  Widget build(BuildContext context) {
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
