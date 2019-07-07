import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile/DataObj/StorageItem.dart';
import 'package:mobile/States/ItemDetailEditPageState.dart';
import 'package:mobile/utils/utils.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class LocationDetailEditPage extends StatelessWidget {
  final bool isEdit;
  static final _formKey = GlobalKey<FormState>();
  String city;
  String street;
  String country;
  String building;
  String unit;
  String roomNumber;

  LocationDetailEditPage({this.isEdit = false});

  update(context) async {}

  add(context) async {
    ItemDetailEditPageState settings =
        Provider.of<ItemDetailEditPageState>(context);
    _formKey.currentState.save();
    try {
      var location = await addLocation(Location(
          country: country,
          city: city,
          street: street,
          building: building,
          unit: unit,
          room_number: roomNumber));
      settings.locations.add(location);
      Navigator.pop(context);
    } on Exception catch (err) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(err.toString()),
        duration: Duration(seconds: 1),
      ));
    } finally {
      settings.isLoading = false;
      settings.update();
    }
  }

  @override
  Widget build(BuildContext context) {
    ItemDetailEditPageState settings =
        Provider.of<ItemDetailEditPageState>(context);

    return Scaffold(
      appBar: AppBar(
        title: isEdit ? Text("Edit Loction") : Text("Add Location"),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: "Country"),
                  initialValue: isEdit
                      ? settings.locations
                          .where((location) =>
                              location.id == settings.selectedLocation)
                          .toList()[0]
                          .country
                      : null,
                  validator: isEmpty,
                  onSaved: (value) => city = value,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "City"),
                  initialValue: isEdit
                      ? settings.locations
                          .where((location) =>
                              location.id == settings.selectedLocation)
                          .toList()[0]
                          .city
                      : null,
                  validator: isEmpty,
                  onSaved: (value) => country = value,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Street"),
                  initialValue: isEdit
                      ? settings.locations
                          .where((location) =>
                              location.id == settings.selectedLocation)
                          .toList()[0]
                          .street
                      : null,
                  validator: isEmpty,
                  onSaved: (value) => street = value,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Building"),
                  initialValue: isEdit
                      ? settings.locations
                          .where((location) =>
                              location.id == settings.selectedLocation)
                          .toList()[0]
                          .building
                      : null,
                  validator: isEmpty,
                  onSaved: (value) => building = value,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Unit"),
                  initialValue: isEdit
                      ? settings.locations
                          .where((location) =>
                              location.id == settings.selectedLocation)
                          .toList()[0]
                          .unit
                      : null,
                  validator: isEmpty,
                  onSaved: (value) => unit = value,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Room Number"),
                  initialValue: isEdit
                      ? settings.locations
                          .where((location) =>
                              location.id == settings.selectedLocation)
                          .toList()[0]
                          .room_number
                      : null,
                  validator: isEmpty,
                  onSaved: (value) => roomNumber = value,
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
