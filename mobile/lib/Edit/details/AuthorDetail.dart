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

  update(context) async {}

  add(context) async {
    ItemDetailEditPageState settings =
        Provider.of<ItemDetailEditPageState>(context);
    _formKey.currentState.save();
    try {
      var newAuthor = await addAuthor(
          Author(name: authorName, description: authorDescription));
      settings.authors.add(newAuthor);
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



    return Scaffold(
      appBar: AppBar(
        title: isEdit ? Text("Edit author") : Text("Add author"),
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
                  maxLines: 15,
                  validator: isEmpty,
                  onSaved: (value) => authorDescription = value,
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
