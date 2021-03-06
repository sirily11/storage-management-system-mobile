import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:storage_management_mobile/DataObj/StorageItem.dart';
import 'package:storage_management_mobile/States/HomeProvider.dart';
import 'package:storage_management_mobile/States/ItemProvider.dart';
import 'package:storage_management_mobile/States/LoginProvider.dart';
import 'package:storage_management_mobile/pages/Home/components/CategorySelector.dart';
import '../Edit/NewEditPage.dart';
import 'Detail/ItemDetailPage.dart';
import 'components/DrawerNav.dart';
import 'ItemRow.dart';

class Homepage extends StatefulWidget {
  Homepage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<Homepage> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  Future scanQR() async {
    ItemProvider state = Provider.of(context, listen: false);
    HomeProvider homePageState = Provider.of(context, listen: false);
    try {
      var result = await BarcodeScanner.scan();
      String barCode = result.rawContent;
      if (barCode.isNotEmpty) {
        await state.fetchItemByQR(context, qrCode: barCode);
      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        homePageState.scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Unable to access camera"),
          duration: Duration(seconds: 3),
        ));
      }
    } on FormatException {
      homePageState.scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("No qr has been scaned"),
        duration: Duration(seconds: 3),
      ));
    } on Exception catch (err) {
      homePageState.scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Item not found"),
        duration: Duration(seconds: 3),
      ));
    }
  }

  Future fetchData() async {
    HomeProvider provider = Provider.of(context, listen: false);
    provider.scaffoldKey = scaffoldKey;
    if (provider.baseURL != "") {
      await provider.fetchSettings();
      await provider.fetchItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    HomeProvider homeProvider = Provider.of(context);

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Storage Management"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(homeProvider.items),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: scanQR,
          ),
          IconButton(
            key: Key("Select Category"),
            tooltip: "Select category",
            icon: Icon(Icons.category),
            onPressed: () async {
              try {
                await CupertinoScaffold.showCupertinoModalBottomSheet(
                  context: context,
                  builder: (c, s) => CategorySelector(),
                );
              } catch (err) {
                showCupertinoModalBottomSheet(
                  context: context,
                  builder: (c, s) => CategorySelector(),
                );
              }
            },
          )
        ],
      ),
      body: Scrollbar(
        child: EasyRefresh(
          key: Key("Refresher"),
          firstRefresh: true,
          header: ClassicalHeader(
            textColor: Theme.of(context).primaryTextTheme.bodyText1.color,
          ),
          footer: ClassicalFooter(
            textColor: Theme.of(context).primaryTextTheme.bodyText1.color,
          ),
          onRefresh: () async {
            await fetchData();
          },
          onLoad: homeProvider.next == null
              ? null
              : () async {
                  await homeProvider.fetchMore();
                },
          child: ListView.builder(
            itemCount: homeProvider.items.length,
            itemBuilder: (context, index) {
              var item = homeProvider.items[index];
              return ItemRow(
                item: item,
              );
            },
          ),
        ),
      ),
      drawer: new HomepageDrawer(),
      floatingActionButton: buildFloatingActionButton(context),
    );
  }

  Widget buildFloatingActionButton(BuildContext context) {
    LoginProvider loginProvider = Provider.of(context, listen: false);
    if (!loginProvider.hasLogined) {
      return null;
    }

    return FloatingActionButton(
      key: Key("Add Item"),
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      child: Icon(
        Icons.edit,
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
                          await fetchData();
                        }),
                    ListTile(
                      leading: Icon(Icons.add),
                      title: Text("添加新的物品"),
                      onTap: () async {
                        Navigator.pop(context);
                        await Navigator.of(context).push(
                            MaterialWithModalsPageRoute(builder: (context) {
                          return NewEditPage();
                        }));
                        await fetchData();
                      },
                    ),
                    ListTile(
                      leading: new Icon(Icons.clear),
                      title: new Text('Cancel'),
                      onTap: () => Navigator.pop(context),
                    ),
                  ],
                ),
              );
            });
      },
    );
  }
}

class CustomSearchDelegate extends SearchDelegate<List<StorageItemAbstract>> {
  final List<StorageItemAbstract> items;

  CustomSearchDelegate(this.items);

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      primaryColor: theme.appBarTheme.color,
      primaryIconTheme: theme.primaryIconTheme,
      primaryColorBrightness: theme.primaryColorBrightness,
      primaryTextTheme: theme.primaryTextTheme,
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    HomeProvider homeProvider = Provider.of(context, listen: false);
    return FutureBuilder(
      future: homeProvider.search(query),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        }
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return _renderResults(snapshot.data);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (items == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (query == "") {
      return Container();
    }

    var result = items.where((item) {
      return item.name.contains(query) ||
          item.seriesName.contains(query) ||
          item.authorName.contains(query);
    }).toList();

    return _renderResults(result);
  }

  ListView _renderResults(List<StorageItemAbstract> result) {
    return ListView.builder(
        itemCount: result.length,
        itemBuilder: (context, i) {
          return ListTile(
            title: Text(result[i].name),
            subtitle: Text(result[i].seriesName),
            trailing: Text(result[i].authorName),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialWithModalsPageRoute(builder: (context) {
                return ItemDetailPage(
                  id: result[i].id,
                  name: result[i].name,
                  author: result[i].authorName,
                  series: result[i].seriesName,
                );
              }));
            },
          );
        });
  }
}
