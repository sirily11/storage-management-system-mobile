import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storage_management_mobile/DataObj/StorageItem.dart';
import 'package:storage_management_mobile/States/HomeProvider.dart';

class CategorySelector extends StatefulWidget {
  @override
  _CategorySelectorState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    HomeProvider homeProvider = Provider.of(context);

    var widgets = {
      0: buildCategories(homeProvider),
      1: buildLocaions(homeProvider),
      2: buildPositions(homeProvider)
    };

    return AlertDialog(
      title: Text("Select"),
      content: Container(
          width: double.maxFinite,
          height: 300,
          child: Column(
            children: <Widget>[
              CupertinoSlidingSegmentedControl(
                groupValue: index,
                onValueChanged: (v) {
                  setState(() {
                    index = v;
                  });
                },
                children: {
                  0: Text("Categories"),
                  1: Text("Locations"),
                  2: Text("Positions")
                },
              ),
              Expanded(
                child: widgets[index],
              )
            ],
          )),
      actions: <Widget>[
        FlatButton(
          child: Text("ok"),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );
  }

  Widget buildCategories(HomeProvider homeProvider) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: homeProvider.settingObj.categories.length,
        itemBuilder: (c, i) {
          var category = homeProvider.settingObj.categories[i];
          return RadioListTile<Category>(
            value: category,
            groupValue: homeProvider.selectedCategory,
            onChanged: (selected) {
              homeProvider.selectedCategory = selected;
            },
            title: Text(category.name),
          );
        });
  }

  Widget buildLocaions(HomeProvider homeProvider) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: homeProvider.settingObj.locations.length,
        itemBuilder: (c, i) {
          var location = homeProvider.settingObj.locations[i];
          return RadioListTile<Location>(
            value: location,
            groupValue: homeProvider.selectedLocation,
            onChanged: (selected) {
              homeProvider.selectedLocation = selected;
            },
            title: Text(location.name),
          );
        });
  }

  Widget buildPositions(HomeProvider homeProvider) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: homeProvider.settingObj.positions.length,
        itemBuilder: (c, i) {
          var position = homeProvider.settingObj.positions[i];
          return RadioListTile<Position>(
            value: position,
            groupValue: homeProvider.selectedPosition,
            onChanged: (selected) {
              homeProvider.selectedPosition = selected;
            },
            title: Text(position.name),
          );
        });
  }
}
