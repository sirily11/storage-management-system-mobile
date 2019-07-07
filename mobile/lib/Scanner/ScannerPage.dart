import 'package:flutter/material.dart';
import 'package:mobile/Home/DrawerNav.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

class ScannerPage extends StatefulWidget {
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<ScannerPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // 0 means not connected, 1 means connected
  int _status = 1;
  // QRCode
  String qrCode;


  connectToWebsocket() async {
      var channel = IOWebSocketChannel.connect("ws")
  }

  Future scanQR() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        this.qrCode = barcode;
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Unable to access camera"),
          duration: Duration(seconds: 3),
        ));
      }
    } on FormatException {
      //   _scaffoldKey.currentState.showSnackBar(SnackBar(
      //     content: Text("No qr has been scanned"),
      //     duration: Duration(seconds: 3),
      //   ));
    } on Exception catch (err) {
      print("error");
      //   _scaffoldKey.currentState.showSnackBar(SnackBar(
      //     content: Text("Item not found"),
      //     duration: Duration(seconds: 3),
      //   ));
    }
  }

  MaterialColor renderColor() {
    switch (this._status) {
      case 1:
        return Colors.green;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(),
        drawer: HomepageDrawer(),
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(children: <Widget>[
                  FloatingActionButton(
                    onPressed: () async {
                      if (_status == 0) {
                        return null;
                      }
                      return await scanQR();
                    },
                    backgroundColor: renderColor(),
                    child: Icon(Icons.photo_camera),
                  ),
                  this._status == 0
                      ? SizedBox(
                          height: 58,
                          width: 58,
                          child: CircularProgressIndicator())
                      : SizedBox(height: 58, width: 58, child: Container())
                ]),
                Image.asset(
                  "assets/barcode.png",
                  height: 100,
                  width: 500,
                ),
                this.qrCode != null ? Text(qrCode) : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
