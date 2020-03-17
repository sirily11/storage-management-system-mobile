import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storage_management_mobile/DataObj/StorageItem.dart';
import 'package:storage_management_mobile/States/HomeProvider.dart';

class CategorySelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HomeProvider homeProvider = Provider.of(context);
    return AlertDialog(
      title: Text("Select category"),
      content: Container(
        width: double.maxFinite,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: homeProvider.categories.length,
            itemBuilder: (c, i) {
              var category = homeProvider.categories[i];
              return RadioListTile<Category>(
                value: category,
                groupValue: homeProvider.selectedCategory,
                onChanged: (selected) {
                  homeProvider.selectedCategory = selected;
                },
                title: Text(category.name),
              );
            }),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("ok"),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );
  }
}
