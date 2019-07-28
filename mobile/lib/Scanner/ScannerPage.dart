import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile/DataObj/Message.dart';
import 'package:mobile/Home/DrawerNav.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:mobile/utils/utils.dart';

class ScannerPage extends StatefulWidget {
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<ScannerPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // 0 means not connected, 1 means connected
  int _status = 0;
  // QRCode
  String qrCode;
  //Websocket
  WebSocket _socket;
  final double width = 150;
  final double height = 150;

  @override
  initState() {
    super.initState();
    connectToWebsocket();
  }

  @override
  dispose() {
    _socket.close();
    super.dispose();
  }

  Future<Message> _onMessage(String data) async {
    var parsedData = json.decode(data);
    return Message.fromJson(parsedData);
  }

  connectToWebsocket() async {
    try {
      _socket = await WebSocket.connect(await getWebSocket());
      _socket.listen((dynamic data) async {
        Message message = await _onMessage(data);
        print("Message: ${message.type} ${message.from}");
        if (message.type == "disconnect") {
          setState(() {
            _status = 0;
          });
        } else if (message.type == "connect") {
          print("Setting state");
          setState(() {
            _status = 1;
          });
        }
      }, onError: (error) {
        print("Error");
        _socket.close();
        setState(() {
          _status = 0;
        });
      }, onDone: () {
        print("Connection closed");
        _socket.close();
        setState(() {
          _status = 0;
        });
      });
    } on Exception catch (err) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          "Cannot connect to the websocket server",
        ),
      ));
    }
  }

  Future scanQR() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        this.qrCode = barcode;
      });
      Message message =
          Message(body: barcode, type: "message", from: "scanner");
      _socket.add(json.encode(message));
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Unable to access camera"),
          duration: Duration(seconds: 3),
        ));
      }
    } on FormatException {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("No qr has been scanned"),
        duration: Duration(seconds: 3),
      ));
    } on Exception catch (err) {
      print("error");
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Item not found"),
        duration: Duration(seconds: 3),
      ));
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
        key: _scaffoldKey,
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () async {
                await this.connectToWebsocket();
              },
            )
          ],
          title:
              _status == 0 ? Text("Waiting for connection") : Text("Connected"),
        ),
        drawer: HomepageDrawer(),
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(children: <Widget>[
                  SizedBox(
                    width: width,
                    height: height,
                    child: FloatingActionButton(
                      onPressed: () async {
                        if (_status == 0) {
                          return null;
                        }
                        return await scanQR();
                      },
                      backgroundColor: renderColor(),
                      child: Image.asset(
                        "assets/barcode.png",
                        height: height / 1.7,
                        width: width,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  this._status == 0
                      ? SizedBox(
                          height: height,
                          width: width,
                          child: CircularProgressIndicator(
                            strokeWidth: 7,
                          ))
                      : SizedBox(height: 58, width: 58, child: Container())
                ]),
                this.qrCode != null ? Text(qrCode) : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
