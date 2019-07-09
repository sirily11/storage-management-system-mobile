import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/DataObj/StorageItem.dart';
import 'package:mobile/Edit/EditPage.dart';
import 'package:mobile/Home/Detail/FileView.dart';
import 'package:mobile/Home/Detail/ItemDescription.dart';
import 'package:mobile/Home/Detail/SubDetail/AuthorDetail.dart';
import 'package:mobile/Home/Detail/SubDetail/LocationDetail.dart';
import 'package:mobile/Home/Detail/SubDetail/PositionDetail.dart';
import 'package:mobile/Home/Detail/SubDetail/SeriesDetail.dart';
import 'package:mobile/ItemImage/ItemImageScreen.dart';
import 'package:mobile/States/ItemDetailEditPageState.dart';
import 'package:mobile/utils/utils.dart';
import 'package:mobile/Home/Detail/HorizontalImage.dart';
import 'package:provider/provider.dart';

class ItemDetailPage extends StatefulWidget {
  final int _id;
  final String name;
  final String author;
  final String series;

  ItemDetailPage(this._id, {this.author, this.name, this.series});

  @override
  State<StatefulWidget> createState() {
    return ItemDetailPageState(this._id,
        name: this.name, author: this.author, series: this.series);
  }
}

class ItemDetailPageState extends State<ItemDetailPage> {
  final int _id;
  final String name;
  final String author;
  final String series;
  StorageItemDetail item;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  ItemDetailPageState(this._id, {this.name, this.series, this.author});

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    var item = await fetchItem();
    setState(() {
      this.item = item;
    });
  }

  Future<StorageItemDetail> fetchItem() async {
    try {
      var url = getURL("item/$_id");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        Utf8Decoder decode = Utf8Decoder();
        var data = json.decode(decode.convert(response.bodyBytes));
        var item = StorageItemDetail.fromJson(data);
        return item;
      } else {
        throw ("Error");
      }
    } on Exception catch (err) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Failed to fetch item details"),
      ));
    }
  }

  Widget itemLabel(String label, String value) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          decoration: InputDecoration(labelText: label),
          initialValue: value,
        ),
      ),
    );
  }

  navigationTo(String navTo) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      switch (navTo) {
        case "author":
          return AuthorDetail(item.author);
        case "series":
          return SeriesDetail(item.series);
        case "location":
          return LocationDetail(item.location);
        case "position":
          return PositionDetail(item.position);
      }
    }));
  }

  Widget itemRow(String value, String label, Function onTab) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(label),
          subtitle: Text(
            value,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            maxLines: 3,
          ),
          onTap: onTab,
          trailing: onTab == null ? null : Icon(Icons.more_horiz),
        ),
        Divider()
      ],
    );
  }

  Widget bodyWidget() {
    return RefreshIndicator(
      onRefresh: () async {
        var item = await fetchItem();
        setState(() {
          this.item = item;
        });
      },
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          itemRow(item.name, "物品名", null),
          item.category != null
              ? itemRow(item.category.name, "种类", null)
              : Container(),
          item.series != null
              ? itemRow(item.series.name, "系列名", () => navigationTo("series"))
              : Container(),
          item.author != null
              ? itemRow(item.author.name, "作者", () => navigationTo("author"))
              : Container(),
          item.description != null
              ? itemRow(item.description, "简介", null)
              : Container(),
          item.price != null
              ? itemRow(item.price.toString(), "价格", null)
              : Container(),
          item.location != null
              ? itemRow(item.location.toString(), "地址",
                  () => navigationTo("location"))
              : Container(),
          item.position != null
              ? itemRow(
                  item.position.name, "详细地址", () => navigationTo("position"))
              : Container(),
          item.column != null
              ? itemRow("Column: ${item.column}\nRow:${item.row}", "坐标", null)
              : Container(),
          HorizontalImage(item.images),
          FileView(item.files)
        ],
      ),
    );
  }

  updateDetailPageItem(StorageItemDetail item) {
    setState(() {
      this.item = item;
    });
  }

  @override
  Widget build(BuildContext context) {
    var body;
    if (item == null) {
      body = Center(child: CircularProgressIndicator());
    } else {
      body = bodyWidget();
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(name),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return ItemImageScreen(_id, this.name);
              }));
            },
          )
        ],
      ),
      body: GestureDetector(
        child: body,
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return EditPage(
              isEditMode: true,
              id: _id,
              item: item,
              updateItem: updateDetailPageItem,
            );
          }));
        },
      ),
    );
  }
}
