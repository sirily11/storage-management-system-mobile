import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile/DataObj/StorageItem.dart';
import 'package:mobile/States/ItemDetailEditPageState.dart';
import 'package:mobile/utils.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SeriesEditDetail extends StatelessWidget {
  final bool isEdit;
  static final _formKey = GlobalKey<FormState>();
  String seriesName;
  String seriesDescription;

  SeriesEditDetail({this.isEdit = false});

  update(context) async {
    ItemDetailEditPageState settings =
    Provider.of<ItemDetailEditPageState>(context);
    try {
      var newSeries = await editSeries(Series(name: seriesName, description: seriesDescription, id: settings.selectedSeries));
      settings.series.removeWhere((author) => author.id == newSeries.id);
      settings.series.add(newSeries);
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
      var series = await addSeries(
          Series(name: seriesName, description: seriesDescription));
      settings.series.add(series);
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
        title: isEdit ? Text("Edit Series") : Text("Add Series"),
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
            },
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
                  decoration: InputDecoration(labelText: "Series name"),
                  initialValue: isEdit
                      ? settings.series
                          .where(
                              (s) => s.id == settings.selectedSeries)
                          .toList()[0]
                          .name
                      : null,
                  validator: isEmpty,
                  onSaved: (value) => seriesName = value,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Series description"),
                  initialValue: isEdit
                      ? settings.series
                      .where(
                          (s) => s.id == settings.selectedSeries)
                      .toList()[0]
                      .description
                      : null,
                  minLines: 3,
                  maxLines: 15,
                  onSaved: (value) => seriesDescription = value,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    settings.isLoading
                        ? CircularProgressIndicator()
                        : Container(),
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
