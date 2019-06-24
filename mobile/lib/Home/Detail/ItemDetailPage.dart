import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/DataObj/StorageItem.dart';
import 'package:mobile/Home/Detail/ItemDescription.dart';
import 'package:mobile/Home/Detail/SubDetail/AuthorDetail.dart';
import 'package:mobile/Home/Detail/SubDetail/LocationDetail.dart';
import 'package:mobile/Home/Detail/SubDetail/PositionDetail.dart';
import 'package:mobile/Home/Detail/SubDetail/SeriesDetail.dart';
import 'package:mobile/utils.dart';
import 'package:mobile/Home/Detail/HorizontalImage.dart';

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

  ItemDetailPageState(this._id, {this.name, this.series, this.author});

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    var item = await fetItem();
    setState(() {
      this.item = item;
    });
  }

  Future<StorageItemDetail> fetItem() async {
    var url = getURL("item/$_id");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      Utf8Decoder decode = Utf8Decoder();
      var data = json.decode(decode.convert(response.bodyBytes));
      return StorageItemDetail.fromJson(data);
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Failed to fetch item details"),
      ));
      throw ("Error");
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

//  Widget itemRow(List<String> labels, List<String> values) {
//    List<Widget> widgets = [];
//    labels.asMap().forEach((index, label) {
//      widgets.add(itemLabel(label, values[index]));
//    });
//
//    return Row(
//      children: widgets,
//    );
//  }

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
        var item = await fetItem();
        setState(() {
          this.item = item;
        });
      },
      child: ListView(
        children: <Widget>[
          itemRow(item.name, "物品名", null),
          itemRow(item.category.name, "种类", null),
          itemRow(item.series.name, "系列名", () => navigationTo("series")),
          itemRow(item.author.name, "作者", () => navigationTo("author")),
          itemRow(item.description, "简介", null),
          itemRow(item.price.toString(), "价格", null),
          itemRow(item.location.toString(), "地址", () => navigationTo("location")),
          itemRow(item.position.name, "详细地址", () => navigationTo("position")),
          itemRow("Column: ${item.column}\nRow:${item.row}", "坐标", null),
          HorizontalImage(item.images)
        ],
      ),
    );
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
      appBar: AppBar(
        title: Text(name),
      ),
      body: GestureDetector(
        child: body,
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      ),
//      floatingActionButton: FloatingActionButton(
//        child: Icon(Icons.save),
//      ),
    );
  }
}
