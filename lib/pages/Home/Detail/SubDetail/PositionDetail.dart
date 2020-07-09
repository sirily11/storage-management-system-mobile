import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:storage_management_mobile/DataObj/StorageItem.dart';
import 'package:storage_management_mobile/States/ItemProvider.dart';
import 'package:storage_management_mobile/States/LoginProvider.dart';
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

  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = Provider.of(context);
    ItemProvider itemProvider = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Position"),
        actions: <Widget>[
          IconButton(
            key: Key("Print position"),
            icon: Icon(Icons.print),
            onPressed: () async {
              ItemProvider itemDetailState =
                  Provider.of(context, listen: false);
              await showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  content: Container(
                    height: 200,
                    width: 200,
                    child: RepaintBoundary(
                      key: itemDetailState.qrKey,
                      child: QrImage(
                        key: Key("Qrimage"),
                        backgroundColor: Colors.white,
                        data: widget.position.uuid,
                        version: QrVersions.auto,
                        gapless: false,
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      child: Text("OK"),
                    ),
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
          if (loginProvider.hasLogined)
            IconButton(
              key: Key("Add detail image"),
              onPressed: () async {
                await showModalBottomSheet(
                  context: context,
                  builder: (context) => ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      ListTile(
                        onTap: () async {
                          File file =
                              await itemProvider.pickImage(ImageSource.camera);
                          Navigator.pop(context);
                          await uploadImage(file);
                        },
                        title: Text("From Camera"),
                      ),
                      ListTile(
                        onTap: () async {
                          var file =
                              await itemProvider.pickImage(ImageSource.gallery);
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: imageURL,
                      height: 200,
                      fit: BoxFit.cover,
                      progressIndicatorBuilder: (context, url, progress) =>
                          Center(
                        child: CircularProgressIndicator(
                          value: progress.progress,
                        ),
                      ),
                    ),
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
    ItemProvider itemProvider = Provider.of(context, listen: false);
    String url;
    if (!itemProvider.isTest) {
      url = await showCupertinoModalBottomSheet<String>(
        context: context,
        expand: true,
        builder: (context, c) => UploadDialog(
          image: file,
          imageDestination: ImageDestination.detailPosition,
        ),
      );
    }

    if (url != null) {
      itemProvider.item.position.imageURL = url;
      setState(() {
        imageURL = url;
      });
    }
  }
}
