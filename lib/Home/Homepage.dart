import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:barcode_scan/barcode_scan.dart';

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
  List<StorageItemAbstract> items = [];
  TabController _tabController;
  String errorMessage;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100), () async {
      await fetchData();
    });
  }

  addItem(StorageItemAbstract item) {
    print(item);
    setState(() {
      items.add(item);
    });
  }

  PersistentBottomSheetController _sheetController() {
    return _scaffoldKey.currentState.showBottomSheet((context) {
      return Container(
        color: Color.fromRGBO(64, 75, 96, .9),
        height: 80,
        child: Column(
          children: <Widget>[
            ListTile(
              title: Center(
                child: Text(
                  "Loading...",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              subtitle: LinearProgressIndicator(),
            )
          ],
        ),
      );
    });
  }

  Future fetchData() async {
    PersistentBottomSheetController controller = _sheetController();
    try {
      setState(() {
        errorMessage = null;
      });
      List<StorageItemAbstract> items = await fetchItems();
      final c = await fetchCategories();
      setState(() {
        _tabController = new TabController(length: c.length, vsync: this);
        categories = c;
      });
      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          controller.close();
          this.items = items;
        });
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("数据已获取"),
          duration: Duration(seconds: 2),
        ));
      });
    } on Exception catch (err) {
      print(err);
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(err.toString()),
      ));
      setState(() {
        errorMessage = err.toString();
      });
    }
  }

  Future scanQR() async {
    try {
      String barcode = await BarcodeScanner.scan();
      StorageItemAbstract item = await searchByQR(barcode);
      print("QR: $barcode, id:${item.id}");
      if (item.id != null) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ItemDetailPage(
            id: item.id,
            name: item.name,
            author: item.authorName,
            series: item.seriesName,
          );
        }));
      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Unable to access camera"),
          duration: Duration(seconds: 3),
        ));
      }
    } on FormatException {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("No qr has been scanned"),
        duration: Duration(seconds: 3),
      ));
    } on Exception catch (err) {
      print("error");
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Item not found"),
        duration: Duration(seconds: 3),
      ));
    }
  }

  remove(StorageItemAbstract item) {
    setState(() {
      items.remove(item);
    });
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("物品已经删除"),
    ));
  }

  @override
  Widget build(BuildContext context) {
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
              children: categories.map((c) {
                var fItems =
                    items.where((i) => i.categoryName == c.name).toList();
                return RefreshIndicator(
                  onRefresh: () async {
                    await this.fetchData();
                  },
                  child: ItemDisplay(
                    items: fItems,
                    removeItemById: remove,
                  ),
                );
              }).toList(),
            ),
          );

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        title: errorMessage == null
            ? Text("Storage Management")
            : Text(errorMessage),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                  context: context, delegate: CustomSearchDelegate(items));
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
                tabs: categories
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
        color: Theme.of(context).iconTheme.color,
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
                        fetchData();
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
