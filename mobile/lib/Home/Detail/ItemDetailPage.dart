import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile/DataObj/StorageItem.dart';
import 'package:mobile/Edit/EditPage.dart';
import 'package:mobile/Home/Detail/FileView.dart';
import 'package:mobile/Home/Detail/ItemCard.dart';
import 'package:mobile/Home/Detail/SubDetail/AuthorDetail.dart';
import 'package:mobile/Home/Detail/SubDetail/LocationDetail.dart';
import 'package:mobile/Home/Detail/SubDetail/PositionDetail.dart';
import 'package:mobile/Home/Detail/SubDetail/SeriesDetail.dart';
import 'package:mobile/States/ItemDetailEditPageState.dart';
import 'package:mobile/States/ItemDetailState.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

enum Path { author, location, position, series }

class ItemDetailPage extends StatefulWidget {
  final int id;
  final String name;
  final String author;
  final String series;

  ItemDetailPage({@required this.id, this.author, this.name, this.series});

  @override
  State<StatefulWidget> createState() {
    return ItemDetailPageState(
        id: this.id, name: this.name, author: this.author, series: this.series);
  }
}

class ItemDetailPageState extends State<ItemDetailPage> {
  final int id;
  final String name;
  final String author;
  final String series;
  final double _panelMinHeight = 200;
  final double _panelMaxHeight = 800;

  ItemDetailPageState({this.id, this.name, this.series, this.author});

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 20), () async {
      ItemDetailState detailState = Provider.of<ItemDetailState>(context);
      await detailState.fetchData(id: this.id);
    });
  }

  navigationTo(Path navTo) {
    ItemDetailState detailState = Provider.of<ItemDetailState>(context);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      switch (navTo) {
        case Path.author:
          return AuthorDetail(detailState.item.author);
        case Path.series:
          return SeriesDetail(detailState.item.series);
        case Path.location:
          return LocationDetail(detailState.item.location);
        case Path.position:
          return PositionDetail(detailState.item.position);
      }
    }));
  }

  Widget _panel() {
    ItemDetailState detailState = Provider.of<ItemDetailState>(context);
    StorageItemDetail item = detailState.item;
    return Theme(
      data: ThemeData(primaryColor: Colors.white),
      child: Column(
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
                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
              ),
            ],
          ),
          SizedBox(
            height: 18.0,
          ),
          Text(
            item.name,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 24.0,
            ),
          ),
          _bodypanel(),
        ],
      ),
    );
  }

  Widget _bodypanel() {
    ItemDetailState detailState = Provider.of<ItemDetailState>(context);
    StorageItemDetail item = detailState.item;
    return Expanded(
      child: Container(
        child: ListView(
          children: <Widget>[
            Card(
              child: Container(
                decoration:
                    BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ButtonInfo(
                        label: "Price",
                        icon: Icons.label,
                        color: Colors.blue,
                        value: '${item.price} ${item.unit}',
                      ),
                      ButtonInfo(
                        label: "Column",
                        icon: Icons.view_column,
                        color: Colors.orange,
                        value: item.column.toString(),
                      ),
                      ButtonInfo(
                        label: "Row",
                        icon: Icons.reorder,
                        color: Colors.green,
                        value: item.row.toString(),
                      )
                    ],
                  ),
                ),
              ),
            ),
            CardInfo(
              info: [Info(title: "Description", subtitle: item.description)],
            ),
            CardInfo(
              info: [
                Info(
                    title: "Author",
                    subtitle: item?.author?.name,
                    onPress: () {
                      navigationTo(Path.author);
                    }),
                Info(title: "Category", subtitle: item?.category?.name),
                Info(
                    title: "Series",
                    subtitle: item?.series?.name,
                    onPress: () {
                      navigationTo(Path.series);
                    }),
              ],
            ),
            CardInfo(
              info: [
                Info(
                    title: "Position",
                    subtitle: item?.position?.name,
                    onPress: () {
                      navigationTo(Path.position);
                    }),
                Info(
                    title: "Location",
                    subtitle: item?.location?.toString(),
                    onPress: () {
                      navigationTo(Path.location);
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ItemDetailState detailState = Provider.of<ItemDetailState>(context);
    var item = detailState.item;
    return Scaffold(
      key: detailState.scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        child: Icon(Icons.edit),
        onPressed: () {
          ItemDetailEditPageState settings =
              Provider.of<ItemDetailEditPageState>(context);
          // init edit info
          // put current author, series info into the setting state
          settings.edit(item.author.id, item.series.id, item.category.id,
              item.location.id, item.position.id, item.unit);
          _edit(context);
        },
      ),
      body: item == null
          ? Container()
          : Stack(
              children: <Widget>[
                item.images != null && item.images.length > 0
                    ? ImageCard(
                        imageSrc: item.images.map((i) => i.image).toList(),
                      )
                    : Center(
                        child: Image.asset(
                          "assets/database.png",
                          height: 240,
                          color: Colors.white,
                        ),
                      ),
                SlidingUpPanel(
                  backdropEnabled: true,
                  minHeight: _panelMinHeight,
                  color: Color.fromRGBO(58, 66, 86, 1.0),
                  parallaxEnabled: true,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18.0),
                      topRight: Radius.circular(18.0)),
                  panel: _panel(),
                )
              ],
            ),
    );
  }

  /// Clicked when user do the editing stuff
  _edit(BuildContext context) {
    ItemDetailState detailState = Provider.of<ItemDetailState>(context);
    return Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EditPage(
        isEditMode: true,
        id: id,
        item: detailState.item,
        updateItem: detailState.updateItem,
      );
    }));
  }
}

class ButtonInfo extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  ButtonInfo(
      {@required this.label,
      @required this.icon,
      @required this.color,
      @required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Icon(
            icon,
            color: Colors.white,
          ),
          decoration:
              BoxDecoration(color: color, shape: BoxShape.circle, boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.15),
              blurRadius: 8.0,
            )
          ]),
        ),
        SizedBox(
          height: 12.0,
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white),
        ),
        Text(
          value,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}

class ImageCard extends StatelessWidget {
  final List<String> imageSrc;

  ImageCard({@required this.imageSrc});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      height: 800,
      items: imageSrc.map((i) {
        return Container(
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(0.0)),
            child: Image.network(
              i,
              fit: BoxFit.fitHeight,
              width: 1000,
            ),
          ),
        );
      }).toList(),
    );
  }
}
