import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/DataObj/Setting.dart';
import 'package:mobile/DataObj/StorageItem.dart';
import 'package:mobile/Edit/EditPage.dart';
import 'package:mobile/Home/Detail/ItemDetailPage.dart';
import 'package:mobile/Home/ItemDisplay.dart';
import 'package:mobile/States/ItemDetailEditPageState.dart';
import 'package:mobile/utils.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<Homepage> {
  List<StorageItemAbstract> items = [];
  String errorMessage;

  @override
  void initState() {
    fetchData();
    super.initState();
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
      ItemDetailEditPageState settingsState =
      Provider.of<ItemDetailEditPageState>(context);
      settingsState.updateAll(
          positions: settings.positions,
          locations: settings.locations,
          series: settings.series,
          authors: settings.authors,
          categories: settings.categories);
    } on Exception catch (err) {
      setState(() {
        errorMessage = err.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget body = ItemDisplay(items);
    return Scaffold(
      appBar: AppBar(
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
          )
        ],
      ),
      body: Container(
        child: RefreshIndicator(
          child: body,
          onRefresh: () async {
            await fetchData();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return EditPage();
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
