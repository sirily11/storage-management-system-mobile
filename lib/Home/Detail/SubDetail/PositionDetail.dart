import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:storage_management_mobile/States/ItemDetailState.dart';

import '../../../DataObj/StorageItem.dart';
import 'DetailedCard.dart';

class PositionDetail extends StatelessWidget {
  final Position position;

  PositionDetail(this.position);

  Widget item(String label, String value) {
    return ListTile(
      title: Text(label),
      subtitle: Text(value == null ? "Empty" : value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Location"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.print),
            onPressed: () async {
              ItemDetailState itemDetailState = Provider.of(context);
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  content: Container(
                    height: 200,
                    width: 200,
                    child: RepaintBoundary(
                      key: itemDetailState.qrKey,
                      child: QrImage(
                        backgroundColor: Colors.white,
                        data: itemDetailState.item.position.uuid,
                        version: QrVersions.auto,
                        gapless: false,
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () async {
                        itemDetailState.printPDF();
                      },
                      child: Text("Print"),
                    )
                  ],
                ),
              );
            },
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          DetailedCard(
            title: "位置",
            subtitle: position.name,
          ),
          DetailedCard(title: "位置简介", subtitle: position.description),
        ],
      ),
    );
  }
}
