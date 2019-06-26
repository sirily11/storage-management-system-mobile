import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile/DataObj/StorageItem.dart';
import 'package:mobile/States/ItemDetailEditPageState.dart';
import 'package:mobile/utils.dart';
import 'package:provider/provider.dart';

class AuthorDetail extends StatelessWidget {
  final bool isEdit;
  static final _formKey = GlobalKey<FormState>();
  String authorName;
  String authorDescription;

  AuthorDetail({this.isEdit = false});

  update(context) async {
    ItemDetailEditPageState settings =
    Provider.of<ItemDetailEditPageState>(context);
    try {
      var newAuthor = await editAuthor(Author(name: authorName, description: authorDescription, id: settings.selectedAuthor));
      settings.authors.removeWhere((author) => author.id == newAuthor.id);
      settings.authors.add(newAuthor);
      settings.isLoading = false;
      settings.update();
      Navigator.pop(context);
    } on Exception catch (err) {
      settings.isLoading = false;
      settings.update();
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(err.toString()),
        duration: Duration(seconds: 1),
      ));
    }
  }

  add(context) async {
    ItemDetailEditPageState settings =
    Provider.of<ItemDetailEditPageState>(context);
    try {
      var newAuthor = await addAuthor(
          Author(name: authorName, description: authorDescription));

      settings.authors.add(newAuthor);
      settings.isLoading = false;
      settings.update();
      Navigator.pop(context);
    } on Exception catch (err) {
      settings.isLoading = false;
      settings.update();
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(err.toString()),
        duration: Duration(seconds: 1),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    ItemDetailEditPageState settings =
    Provider.of<ItemDetailEditPageState>(context);

    return Scaffold(
      appBar: AppBar(
        title: isEdit ? Text("Edit author") : Text("Add author"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.file_upload),
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
              }
          )
        ],
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: "Author name"),
                  initialValue: isEdit
                      ? settings.authors
                      .where(
                          (author) => author.id == settings.selectedAuthor)
                      .toList()[0]
                      .name
                      : null,
                  validator: isEmpty,
                  onSaved: (value) => authorName = value,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Author description"),
                  initialValue: isEdit
                      ? settings.authors
                      .where(
                          (author) => author.id == settings.selectedAuthor)
                      .toList()[0]
                      .description
                      : null,
                  minLines: 3,
                  maxLines: 13,
                  onSaved: (value) => authorDescription = value,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    settings.isLoading
                        ? LinearProgressIndicator()
                        : Container()
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
