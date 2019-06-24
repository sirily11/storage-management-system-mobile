import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/DataObj/StorageItem.dart';
import 'package:mobile/Home/Detail/ItemDetailPage.dart';
import 'package:mobile/Home/ItemDisplay.dart';
import 'package:mobile/utils.dart';

class Homepage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<Homepage> {
  List<StorageItemAbstract> items = [];

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    List<StorageItemAbstract> items = await fetchItems();
    setState(() {
      this.items = items;
    });
  }

  Future<List<StorageItemAbstract>> fetchItems() async {
    var url = getURL("item/");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      Utf8Decoder decode = Utf8Decoder();
      List<dynamic> data = json.decode(decode.convert(response.bodyBytes));
      List<StorageItemAbstract> list = [];
      data.forEach((data) {
        list.add(StorageItemAbstract.fromJson(data));
      });
      return list;
    } else {
      throw ("Failed to fetch");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Storage Management"),
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
            child: ItemDisplay(items),
            onRefresh: () async {
              var list = await fetchItems();
              setState(() {
                this.items = list;
              });
            },
          ),
        ));
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
