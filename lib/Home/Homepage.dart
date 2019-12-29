import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:provider/provider.dart';
import 'package:storage_management_mobile/States/HomeProvider.dart';
import 'package:storage_management_mobile/States/ItemDetailState.dart';

import '../DataObj/StorageItem.dart';
import '../Edit/NewEditPage.dart';
import '../utils/utils.dart';
import 'Detail/ItemDetailPage.dart';
import 'DrawerNav.dart';
import 'ItemDisplay.dart';

class Homepage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<Homepage> with TickerProviderStateMixin {
  TabController _tabController;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100), () async {
      await fetchData();
    });
  }

  Future scanQR() async {
    ItemDetailState state = Provider.of(context);
    HomeProvider homePageState = Provider.of(context);
    try {
      String barcode = await BarcodeScanner.scan();
      await state.fetchItemByQR(context, qrCode: barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
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
    HomeProvider provider = Provider.of(context);
    provider.scaffoldKey = scaffoldKey;
    await provider.fetchCategories();
    int index = _tabController?.index;
    _tabController = TabController(
        length: provider.categories.length,
        vsync: this,
        initialIndex: index ?? 0);
    await provider.fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    HomeProvider homeProvider = Provider.of(context);

    Widget _body = _tabController == null
        ? Center(
            child: Icon(
              Icons.pages,
              color: Colors.white,
              size: 100,
            ),
          )
        : Container(
            child: TabBarView(
              controller: _tabController,
              children: homeProvider.categories.map((c) {
                var fItems = homeProvider.items
                    .where((i) => i.categoryName == c.name)
                    .toList();
                return RefreshIndicator(
                  onRefresh: () async {
                    await this.fetchData();
                  },
                  child: ItemDisplay(
                    items: fItems,
                  ),
                );
              }).toList(),
            ),
          );

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
                  delegate: CustomSearchDelegate(homeProvider.items));
            },
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: scanQR,
          ),
        ],
        bottom: _tabController == null
            ? null
            : TabBar(
                controller: _tabController,
                isScrollable: true,
                tabs: homeProvider.categories
                    .map((c) => Tab(
                          text: c.name,
                        ))
                    .toList(),
              ),
      ),
      body: _body,
      drawer: new HomepageDrawer(),
      floatingActionButton: buildFloatingActionButton(context),
    );
  }

  Widget buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
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
                        await Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
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
    return buildSuggestions(context);
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

    return ListView.builder(
        itemCount: result.length,
        itemBuilder: (context, i) {
          return ListTile(
            title: Text(result[i].name),
            subtitle: Text(result[i].seriesName),
            trailing: Text(result[i].authorName),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
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
