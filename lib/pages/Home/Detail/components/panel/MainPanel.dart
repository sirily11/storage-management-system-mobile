import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storage_management_mobile/DataObj/StorageItem.dart';
import 'package:storage_management_mobile/States/ItemProvider.dart';
import 'package:storage_management_mobile/pages/Home/Detail/components/panel/BodyPanel.dart';
import 'package:storage_management_mobile/utils/utils.dart';

/// Main Panel which contains Body Panel
class MainPanel extends StatelessWidget {
  final ScrollController scrollController;

  MainPanel({this.scrollController});

  @override
  Widget build(BuildContext context) {
    ItemProvider detailState =
        Provider.of<ItemProvider>(context, listen: false);
    StorageItemDetail item = detailState.item;
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 12.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 30,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.all(
                    Radius.circular(12.0),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 18.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              item.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 24.0,
              ),
            ),
          ),
          Text(getTime(item.createAt)),
          BodyPanel(),
        ],
      ),
    );
  }
}
