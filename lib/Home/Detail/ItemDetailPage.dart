import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:storage_management_mobile/Home/ConfirmDialog.dart';
import 'package:storage_management_mobile/Home/Detail/quantityEditPannel.dart';
import 'package:storage_management_mobile/utils/utils.dart';
import '../../DataObj/StorageItem.dart';
import '../../Edit/NewEditPage.dart';
import '../../ItemImage/NewImageScreen.dart';
import '../../States/ItemProvider.dart';
import 'ItemCard.dart';
import 'SubDetail/AuthorDetail.dart';
import 'SubDetail/LocationDetail.dart';
import 'SubDetail/PositionDetail.dart';
import 'SubDetail/SeriesDetail.dart';

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

  ItemDetailPageState({this.id, this.name, this.series, this.author});

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 20), () async {
      ItemProvider detailState =
          Provider.of<ItemProvider>(context, listen: false);
      await detailState.fetchData(id: this.id);
    });
  }

  navigationTo(Path navTo) {
    ItemProvider detailState =
        Provider.of<ItemProvider>(context, listen: false);
    Navigator.of(context).push(MaterialWithModalsPageRoute(builder: (context) {
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

  Widget _panel([ScrollController sc]) {
    ItemProvider detailState =
        Provider.of<ItemProvider>(context, listen: false);
    StorageItemDetail item = detailState.item;
    return SingleChildScrollView(
      controller: sc,
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
          Text(
            item.name,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 24.0,
            ),
          ),
          Text(getTime(item.createAt)),
          _bodypanel(),
        ],
      ),
    );
  }

  Widget _bodypanel() {
    ItemProvider detailState =
        Provider.of<ItemProvider>(context, listen: false);
    StorageItemDetail item = detailState.item;
    return Column(
      children: <Widget>[
        Card(
          child: Container(
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
                  ),
                  ButtonInfo(
                    label: "Quantity",
                    icon: Icons.shopping_cart,
                    color: Colors.red,
                    value: item.quantity.toString(),
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
        ),
        QuantityEdit(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    ItemProvider detailState = Provider.of<ItemProvider>(context);
    var item = detailState.item;
    return Scaffold(
      key: detailState.scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        actions: <Widget>[
          IconButton(
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
                        data: itemDetailState.item.uuid,
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
            icon: Icon(Icons.print),
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialWithModalsPageRoute(builder: (ctx) {
                  return ImageScreen(
                    id: id,
                  );
                }),
              );
              ItemProvider detailState =
                  Provider.of<ItemProvider>(context, listen: false);
              await detailState.fetchData(id: this.id);
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        child: Icon(
          Icons.edit,
          color: Colors.white,
        ),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                    child: new Wrap(
                  children: <Widget>[
                    ListTile(
                        leading: new Icon(Icons.refresh),
                        title: new Text('刷新'),
                        onTap: () async {
                          Navigator.pop(context);
                          await detailState.fetchData(id: this.id);
                        }),
                    ListTile(
                      leading: Icon(Icons.add),
                      title: Text("编辑新的物品"),
                      onTap: () async {
                        ItemProvider detailState =
                            Provider.of<ItemProvider>(context, listen: false);
                        Map<String, dynamic> values = detailState.item.toJSON();
                        // init edit info
                        // put current author, series info into the setting state
                        await Navigator.push(
                          context,
                          MaterialWithModalsPageRoute(
                            builder: (context) {
                              return NewEditPage(
                                values: values,
                                id: detailState.item.id,
                              );
                            },
                          ),
                        );

                        await detailState.fetchData(id: this.id);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: new Icon(Icons.clear),
                      title: new Text('Cancel'),
                      onTap: () => Navigator.pop(context),
                    ),
                  ],
                ));
              });
        },
      ),
      body: item == null
          ? Container()
          : LayoutBuilder(
              builder: (context, constrains) {
                if (constrains.maxWidth > 760) {
                  return buildLargeScreen(item, context);
                }
                return buildMobile(item, context);
              },
            ),
    );
  }

  Widget buildLargeScreen(StorageItemDetail item, BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 9,
          child: Card(
            child: Theme(
              data: Theme.of(context).copyWith(
                  cardColor: Theme.of(context).scaffoldBackgroundColor),
              child: _panel(),
            ),
          ),
        ),
        Expanded(
          flex: 7,
          child: item.images != null && item.images.length > 0
              ? ImageGrid(
                  imageSrc: item.images,
                )
              : Center(
                  child: Image.asset(
                    "assets/database.png",
                    height: 240,
                    color: Theme.of(context).accentColor,
                  ),
                ),
        )
      ],
    );
  }

  Widget buildMobile(StorageItemDetail item, BuildContext context) {
    return Stack(
      children: <Widget>[
        item.images != null && item.images.length > 0
            ? ImageCard(
                imageSrc: item.images,
              )
            : Center(
                child: Image.asset(
                  "assets/database.png",
                  height: 240,
                  color: Theme.of(context).accentColor,
                ),
              ),
        SlidingUpPanel(
          backdropEnabled: true,
          minHeight: MediaQuery.of(context).size.height * 0.2,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          color: Theme.of(context).scaffoldBackgroundColor,
          parallaxEnabled: true,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18.0),
            topRight: Radius.circular(18.0),
          ),
          panelBuilder: (ScrollController sc) => _panel(sc),
        )
      ],
    );
  }
}

class ButtonInfo extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final Function onClick;

  ButtonInfo(
      {@required this.label,
      @required this.icon,
      @required this.color,
      @required this.value,
      this.onClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (this.onClick != null) {
          this.onClick();
        }
      },
      child: Column(
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
          ),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}

class ImageCard extends StatelessWidget {
  final List<ImageObject> imageSrc;

  ImageCard({@required this.imageSrc});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      enableInfiniteScroll: false,
      height: MediaQuery.of(context).size.height - 300,
      items: imageSrc.map((i) {
        return Container(
          child: Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(0.0)),
                child: Image.network(
                  i.image,
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height,
                  // width: 1000,
                ),
              ),
              Positioned(
                right: 0,
                child: IconButton(
                  onPressed: () async {
                    ItemProvider pageState =
                        Provider.of(context, listen: false);
                    await pageState.deleteImage(i.id);
                  },
                  icon: Icon(Icons.clear),
                ),
              )
            ],
          ),
        );
      }).toList(),
    );
  }
}

class ImageGrid extends StatelessWidget {
  final List<ImageObject> imageSrc;

  ImageGrid({@required this.imageSrc});

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      itemCount: imageSrc.length,
      staggeredTileBuilder: (index) => StaggeredTile.fit(1),
      itemBuilder: (context, index) {
        var i = imageSrc[index];
        return GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (c) => Dialog(
                child: Container(
                  child: Image.network(i.image),
                ),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(0.0)),
            child: Stack(
              children: <Widget>[
                Image.network(
                  i.image,
                  fit: BoxFit.contain,
                  // width: 1000,
                ),
                Positioned(
                  right: 0,
                  child: IconButton(
                    onPressed: () async {
                      ItemProvider pageState =
                          Provider.of(context, listen: false);
                      showDialog(
                        context: context,
                        builder: (_) => ConfirmDialog(
                          title: "Do you want to delete?",
                          content: "Cannot undo this action",
                          onConfirm: () async {
                            await pageState.deleteImage(i.id);
                          },
                        ),
                      );
                    },
                    icon: Icon(Icons.clear),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
