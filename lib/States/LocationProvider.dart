import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationProvider with ChangeNotifier {
  Location location;

  LocationProvider({Location location}) {
    this.location = location ?? Location();
  }

  Future<LocationData> getLocation() async {
    var permission = await location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await location.requestPermission();
    }
    if (permission == PermissionStatus.granted) {
      var l = await location.getLocation();
      return l;
    }

    return null;
  }
}
