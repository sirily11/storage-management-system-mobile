import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile/DataObj/StorageItem.dart';
import 'package:mobile/Edit/EditPage.dart';
import 'package:mobile/Home/Detail/ItemDetailPage.dart';
import 'package:mobile/Home/ItemDisplay.dart';
import 'package:mobile/States/ItemDetailEditPageState.dart';
import 'package:mobile/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:barcode_scan/barcode_scan.dart';

import 'DrawerNav.dart';

class Homepage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<Homepage>
    with SingleTickerProviderStateMixin {
  List<StorageItemAbstract> items = [];
  TabController _tabController;
  String errorMessage;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  addItem(StorageItemAbstract item) {
    setState(() {
      items.add(item);
    });
  }

  Future fetchData() async {
    try {
      setState(() {
        errorMessage = null;
      });
      List<StorageItemAbstract> items = await fetchItems();
      setState(() {
        this.items = items;
      });
      final settings = await fetchSetting();
      setState(() {
        _tabController =
            new TabController(length: settings.categories.length, vsync: this);
      });

      ItemDetailEditPageState settingsState =
          Provider.of<ItemDetailEditPageState>(context);
      settingsState.updateAll(
          positions: settings.positions,
          locations: settings.locations,
          series: settings.series,
          authors: settings.authors,
          categories: settings.categories);
    } on Exception catch (err) {
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
            item.id,
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
  }

  @override
  Widget build(BuildContext context) {
    ItemDetailEditPageState settingsState =
        Provider.of<ItemDetailEditPageState>(context);

    if (_tabController == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
          title: errorMessage == null
              ? Text("Storage Management")
              : Text(errorMessage),
        ),
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        drawer: new HomepageDrawer(),
        body: Center(
          child: Icon(
            Icons.pages,
            color: Colors.white,
            size: 100,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      // key: _scaffoldKey,
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
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: settingsState.categories
              .map((c) => Tab(
                    text: c.name,
                  ))
              .toList(),
        ),
      ),
      body: Container(
        child: RefreshIndicator(
          onRefresh: () async {
            await fetchData();
          },
          child: TabBarView(
            controller: _tabController,
            children: settingsState.categories.map((c) {
              var fItems =
                  items.where((i) => i.categoryName == c.name).toList();
              return ItemDisplay(fItems, _scaffoldKey, remove);
            }).toList(),
          ),
        ),
      ),
      drawer: new HomepageDrawer(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return EditPage(
              addItem: addItem,
            );
          }));
        },
      ),
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
                  result[i].id,
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
