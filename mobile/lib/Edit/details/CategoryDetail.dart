import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile/DataObj/StorageItem.dart';
import 'package:mobile/States/ItemDetailEditPageState.dart';
import 'package:mobile/utils/utils.dart';
import 'package:provider/provider.dart';

class CategoryDetail extends StatelessWidget {
  final bool isEdit;
  static final _formKey = GlobalKey<FormState>();
  String categoryName;

  CategoryDetail({this.isEdit = false});

  update(context) async {}

  add(context) async {
    ItemDetailEditPageState settings =
        Provider.of<ItemDetailEditPageState>(context);
    _formKey.currentState.save();
    try {
      var newCategory = await addCategory(
          Category(name: categoryName)
      );
      settings.categories.add(newCategory);
      Navigator.pop(context);
    } on Exception catch (err) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(err.toString()),
        duration: Duration(seconds: 1),
      ));
    }
    settings.isLoading = false;
    settings.update();
  }

  @override
  Widget build(BuildContext context) {
    ItemDetailEditPageState settings =
        Provider.of<ItemDetailEditPageState>(context);
    print(settings.selectedCategory);

    return Scaffold(
      appBar: AppBar(
        title: isEdit ? Text("Edit author") : Text("Add Category"),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: "Category name"),
                  initialValue: isEdit
                      ? settings.categories
                          .where(
                              (category) => category.id == settings.selectedCategory)
                          .toList()[0]
                          .name
                      : null,
                  validator: isEmpty,
                  onSaved: (value) => categoryName = value,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    settings.isLoading
                        ? CircularProgressIndicator()
                        : Container(),
                    RaisedButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          settings.isLoading = true;
                          settings.update();
                          if (isEdit) {
                            await update(context);
                          } else {
                            await add(context);
                          }
                        }
                      },
                      child: Text("Push to server"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
