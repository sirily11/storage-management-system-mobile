import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile/DataObj/StorageItem.dart';
import 'package:mobile/Edit/details/GenericDetail.dart';
import 'package:mobile/States/ItemDetailEditPageState.dart';
import 'package:mobile/utils/utils.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class PositionDetail extends StatelessWidget with CreateAndUpdate {
  final bool isEdit;
  static final _formKey = GlobalKey<FormState>();
  String positionName;
  String positionDescription;

  PositionDetail({this.isEdit = false});

  @override
  Widget build(BuildContext context) {
    ItemDetailEditPageState settings =
        Provider.of<ItemDetailEditPageState>(context);

    return Scaffold(
      appBar: AppBar(
        title: isEdit ? Text("Edit Position") : Text("Add position"),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: "Position"),
                  initialValue: isEdit
                      ? settings.positions
                          .where((position) =>
                              position.id == settings.selectedPosition)
                          .toList()[0]
                          .name
                      : null,
                  validator: isEmpty,
                  onSaved: (value) => positionName = value,
                ),
                TextFormField(
                  decoration:
                      InputDecoration(labelText: "Position description"),
                  initialValue: isEdit
                      ? settings.positions
                          .where((position) =>
                              position.id == settings.selectedPosition)
                          .toList()[0]
                          .description
                      : null,
                  minLines: 3,
                  maxLines: 15,
                  validator: isEmpty,
                  onSaved: (value) => positionDescription = value,
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
                            await update(
                                context,
                                Position(
                                    name: positionName,
                                    description: positionDescription,
                                    id: settings.selectedPosition));
                          } else {
                            await add(
                                context,
                                Position(
                                    name: positionName,
                                    description: positionDescription));
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
