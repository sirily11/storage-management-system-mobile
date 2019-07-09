import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile/DataObj/StorageItem.dart';
import 'package:mobile/Edit/details/GenericDetail.dart';
import 'package:mobile/States/ItemDetailEditPageState.dart';
import 'package:mobile/utils/utils.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SeriesEditDetail extends StatelessWidget with CreateAndUpdate {
  final bool isEdit;
  static final _formKey = GlobalKey<FormState>();
  String seriesName;
  String seriesDescription;

  SeriesEditDetail({this.isEdit = false});

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
                  await update(
                      context,
                      Series(
                          name: seriesName,
                          description: seriesDescription,
                          id: settings.selectedSeries));
                } else {
                  await add(context,
                      Series(name: seriesName, description: seriesDescription));
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
                          .where((s) => s.id == settings.selectedSeries)
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
                          .where((s) => s.id == settings.selectedSeries)
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
