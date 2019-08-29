import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/DataObj/StorageItem.dart';
import 'package:mobile/Edit/EditPage.dart';
import 'package:mobile/Home/Detail/FileView.dart';
import 'package:mobile/Home/Detail/ItemCard.dart';
import 'package:mobile/Home/Detail/SubDetail/AuthorDetail.dart';
import 'package:mobile/Home/Detail/SubDetail/LocationDetail.dart';
import 'package:mobile/Home/Detail/SubDetail/PositionDetail.dart';
import 'package:mobile/Home/Detail/SubDetail/SeriesDetail.dart';
import 'package:mobile/States/ItemDetailEditPageState.dart';
import 'package:mobile/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

enum Path { author, location, position, series }

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
  void initState() {
    super.initState();
    fetchItem().then((item) {
      setState(() {
        this.item = item;
      });
    });
  }

  Future<StorageItemDetail> fetchItem() async {
    try {
      var url = await getURL("item/$_id");
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

  navigationTo(Path navTo) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      switch (navTo) {
        case Path.author:
          return AuthorDetail(item.author);
        case Path.series:
          return SeriesDetail(item.series);
        case Path.location:
          return LocationDetail(item.location);
        case Path.position:
          return PositionDetail(item.position);
      }
    }));
  }

  updateDetailPageItem(StorageItemDetail item) {
    setState(() {
      this.item = item;
    });
  }

  Widget _panel() {
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
    if (item == null) {
      return CircularProgressIndicator();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        child: Icon(Icons.edit),
        onPressed: () {
          _edit(context);
        },
      ),
      body: Stack(
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
            minHeight: 70,
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

  void _edit(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      ItemDetailEditPageState settingsState =
          Provider.of<ItemDetailEditPageState>(context);
      settingsState.selectedAuthor = item.author.id;
      settingsState.selectedCategory = item.category.id;
      settingsState.selectedLocation = item.location.id;
      settingsState.selectedSeries = item.series.id;
      settingsState.selectedPosition = item.position.id;
      settingsState.unit = item.unit;
      return EditPage(
        isEditMode: true,
        id: _id,
        item: item,
        updateItem: updateDetailPageItem,
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
