import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:storage_management_mobile/DataObj/StorageItem.dart';
import 'package:storage_management_mobile/States/ItemProvider.dart';
import 'package:storage_management_mobile/pages/ItemImage/UploadDialog.dart';

import '../../../DataObj/StorageItem.dart';
import 'DetailedCard.dart';

class PositionDetail extends StatefulWidget {
  final Position position;

  PositionDetail(this.position);

  @override
  _PositionDetailState createState() => _PositionDetailState();
}

class _PositionDetailState extends State<PositionDetail> {
  String imageURL;

  @override
  void initState() {
    super.initState();
    this.imageURL = widget.position.imageURL;
  }

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
        title: Text("Position"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.print),
            onPressed: () async {
              ItemProvider itemDetailState =
                  Provider.of(context, listen: false);
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
          ),
          IconButton(
            onPressed: () async {
              showModalBottomSheet(
                context: context,
                builder: (context) => ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    ListTile(
                      onTap: () async {
                        var file =
                            await ItemProvider.pickImage(ImageSource.camera);
                        Navigator.pop(context);
                        await uploadImage(file);
                      },
                      title: Text("From Camera"),
                    ),
                    ListTile(
                      onTap: () async {
                        var file =
                            await ItemProvider.pickImage(ImageSource.gallery);
                        Navigator.pop(context);
                        await uploadImage(file);
                      },
                      title: Text("From Photo Library"),
                    ),
                  ],
                ),
              );
            },
            icon: Icon(Icons.photo_library),
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          imageURL != null
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    imageURL,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                )
              : Container(),
          DetailedCard(
            title: "位置",
            subtitle: widget.position?.name,
          ),
          DetailedCard(
            title: "位置简介",
            subtitle: widget.position?.description,
          ),
        ],
      ),
    );
  }

  Future<void> uploadImage(File file) async {
    var url = await showCupertinoModalBottomSheet<String>(
      context: context,
      expand: true,
      builder: (context, c) => UploadDialog(
        image: file,
        imageDestination: ImageDestination.detailPosition,
      ),
    );
    if (url != null) {
      ItemProvider itemProvider = Provider.of(context, listen: false);
      itemProvider.item.position.imageURL = url;
      setState(() {
        imageURL = url;
      });
    }
  }
}
