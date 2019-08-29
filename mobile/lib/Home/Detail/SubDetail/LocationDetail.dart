import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile/DataObj/StorageItem.dart';
import 'package:mobile/Home/Detail/SubDetail/DetailedCard.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationDetail extends StatelessWidget {
  final Location location;
  // GoogleMapController mapController;

  // final LatLng _center = const LatLng(45.521563, -122.677433);

  // void _onMapCreated(GoogleMapController controller) {
  //   mapController = controller;
  // }

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
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: AppBar(
        title: Text("Location"),
      ),
      // body: GoogleMap(
      //   onMapCreated: _onMapCreated,
      //   initialCameraPosition: CameraPosition(
      //     target: _center,
      //     zoom: 11.0,
      //   ),
      // )
      body: ListView(
        children: <Widget>[
          DetailedCard(title: "Country", subtitle: location.country),
          DetailedCard(title: "City", subtitle: location.city),
          DetailedCard(title: "Street", subtitle: location.street),
          DetailedCard(title: "Building", subtitle: location.building),
          DetailedCard(title: "Unit", subtitle: location.unit),
          DetailedCard(title: "Room", subtitle: location.room_number)
        ],
      ),
    );
  }
}
