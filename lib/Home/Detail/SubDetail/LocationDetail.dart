import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as d;
import 'package:provider/provider.dart';
import 'package:storage_management_mobile/States/ItemProvider.dart';
import '../../../DataObj/StorageItem.dart';
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

  Widget item(String label, String value) {
    return ListTile(
      title: Text(label),
      subtitle: Text(value == null ? "Empty" : value),
    );
  }

  @override
  Widget build(BuildContext context) {
    ItemProvider itemProvider = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Location"),
        actions: <Widget>[
          IconButton(
            tooltip: "Update location",
            icon: Icon(Icons.location_on),
            onPressed: () async {
              d.Location location = new d.Location();
              var permission = await location.hasPermission();
              if (permission == d.PermissionStatus.denied) {
                permission = await location.requestPermission();
              }
              if (permission == d.PermissionStatus.granted) {
                var l = await location.getLocation();
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
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
                            latitude: l.latitude,
                            longitude: l.longitude,
                          );

                          setState(() {
                            latitude = l.latitude;
                            longitude = l.longitude;
                          });
                          Navigator.pop(context);
                        },
                        child: Text("ok"),
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
          if (latitude != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 300,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: GoogleMap(
                    myLocationButtonEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(latitude, longitude),
                      zoom: 11,
                    ),
                    markers: [
                      Marker(
                        markerId: MarkerId("1"),
                        position: LatLng(latitude, longitude),
                      )
                    ].toSet(),
                  ),
                ),
              ),
            ),
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
