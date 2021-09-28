import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' show LocationData;

import 'package:provider/provider.dart';
import 'package:storage_management_mobile/DataObj/StorageItem.dart';
import 'package:storage_management_mobile/States/ItemProvider.dart';
import 'package:storage_management_mobile/States/LocationProvider.dart';
import 'package:storage_management_mobile/States/LoginProvider.dart';
import 'DetailedCard.dart';

// import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationDetail extends StatefulWidget {
  final Location location;

  LocationDetail(this.location);

  @override
  _LocationDetailState createState() => _LocationDetailState();
}

class _LocationDetailState extends State<LocationDetail> {
  double latitude;
  double longitude;

  @override
  void initState() {
    super.initState();
    this.latitude = widget.location.latitude;
    this.longitude = widget.location.longitude;
  }

  @override
  Widget build(BuildContext context) {
    ItemProvider itemProvider = Provider.of(context);
    LoginProvider loginProvider = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Location"),
        actions: <Widget>[
          if (loginProvider.hasLogined)
            IconButton(
              tooltip: "Update location",
              icon: Icon(Icons.location_on),
              onPressed: () async {
                LocationProvider locationProvider =
                    Provider.of(context, listen: false);
                LocationData locationData =
                    await locationProvider.getLocation();

                if (locationData != null) {
                  await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      key: Key("Update Location"),
                      title: Text("Update Location"),
                      content: Text("Use Location"),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Cancel"),
                        ),
                        FlatButton(
                          onPressed: () async {
                            await itemProvider.updateLocation(
                              latitude: locationData.latitude,
                              longitude: locationData.longitude,
                            );

                            setState(() {
                              latitude = locationData.latitude;
                              longitude = locationData.longitude;
                            });
                            Navigator.pop(context);
                          },
                          child: Text("OK"),
                        )
                      ],
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      key: Key("Error"),
                      title: Text("Cannot Get Location"),
                      content: Text("Cannot Get Location"),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("OK"),
                        )
                      ],
                    ),
                  );
                }
              },
            )
        ],
      ),
      body: ListView(
        children: <Widget>[
          // if (latitude != null)
          //   Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Container(
          //       key: Key("Map"),
          //       height: 300,
          //       child: ClipRRect(
          //         borderRadius: BorderRadius.circular(10),
          //         child: GoogleMap(
          //           myLocationButtonEnabled: false,
          //           initialCameraPosition: CameraPosition(
          //             target: LatLng(latitude, longitude),
          //             zoom: 11,
          //           ),
          //           markers: [
          //             Marker(
          //               markerId: MarkerId("1"),
          //               position: LatLng(latitude, longitude),
          //             )
          //           ].toSet(),
          //         ),
          //       ),
          //     ),
          //   ),
          DetailedCard(title: "Country", subtitle: widget.location?.country),
          DetailedCard(title: "City", subtitle: widget.location?.city),
          DetailedCard(title: "Street", subtitle: widget.location?.street),
          DetailedCard(title: "Building", subtitle: widget.location?.building),
          DetailedCard(title: "Unit", subtitle: widget.location?.unit),
          DetailedCard(title: "Room", subtitle: widget.location?.room_number)
        ],
      ),
    );
  }
}
