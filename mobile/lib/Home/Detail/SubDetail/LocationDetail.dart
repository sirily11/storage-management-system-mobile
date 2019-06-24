import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile/DataObj/StorageItem.dart';

class LocationDetail extends StatelessWidget {
  final Location location;

  LocationDetail(this.location);

  Widget item(String label, String value) {
    return ListTile(
      title: Text(label),
      subtitle: Text(value == null ? "Empty" : value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Location"),
      ),
      body: ListView(
        children: <Widget>[
          item("Country", location.country),
          item("City", location.city),
          item("Street", location.street),
          item("Building", location.building),
          item("Unit", location.unit),
          item("Room", location.room_number)
        ],
      ),
    );
  }
}
