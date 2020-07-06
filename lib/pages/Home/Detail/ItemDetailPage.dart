import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:storage_management_mobile/DataObj/StorageItem.dart';
import 'package:storage_management_mobile/States/ItemProvider.dart';
import 'package:storage_management_mobile/States/LoginProvider.dart';
import 'package:storage_management_mobile/pages/Home/Detail/components/image/ImageCard.dart';
import 'package:storage_management_mobile/pages/Home/Detail/components/panel/BodyPanel.dart';
import 'package:storage_management_mobile/pages/Home/Detail/components/panel/MainPanel.dart';
import 'package:storage_management_mobile/pages/Home/Detail/components/quantityEditPannel.dart';
import 'package:storage_management_mobile/utils/utils.dart';
import '../../DataObj/StorageItem.dart';
import '../../Edit/NewEditPage.dart';
import '../../ItemImage/NewImageScreen.dart';
import '../ConfirmDialog.dart';
import 'components/image/ImageGrid.dart';
import 'components/item/ItemCard.dart';
import 'SubDetail/AuthorDetail.dart';
import 'SubDetail/LocationDetail.dart';
import 'SubDetail/PositionDetail.dart';
import 'SubDetail/SeriesDetail.dart';

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

  @override
  Widget build(BuildContext context) {
    ItemProvider detailState = Provider.of<ItemProvider>(context);
    LoginProvider loginProvider = Provider.of(context);

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
          if (loginProvider.hasLogined)
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
      floatingActionButton: loginProvider.hasLogined
          ? FloatingActionButton(
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
                                  Provider.of<ItemProvider>(context,
                                      listen: false);
                              Map<String, dynamic> values =
                                  detailState.item.toJSON();
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
            )
          : null,
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
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 9,
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Card(
              child: Theme(
                data: Theme.of(context).copyWith(
                    cardColor: Theme.of(context).scaffoldBackgroundColor),
                child: MainPanel(),
              ),
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
                child: Icon(
                  Icons.computer,
                  size: 300,
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
          panelBuilder: (ScrollController sc) => MainPanel(
            scrollController: sc,
          ),
        )
      ],
    );
  }
}
