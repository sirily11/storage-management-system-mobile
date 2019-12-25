import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:file_chooser/file_chooser.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:storage_management_mobile/Home/Detail/ItemDetailPage.dart';
import 'package:storage_management_mobile/SearchListPage/SearchListPage.dart';

import '../DataObj/StorageItem.dart';
import '../utils/utils.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;

class ItemDetailState with ChangeNotifier {
  StorageItemDetail item;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey qrKey = new GlobalKey();

  PersistentBottomSheetController _sheetController() {
    return scaffoldKey.currentState.showBottomSheet((context) {
      return Container(
        color: Color.fromRGBO(64, 75, 96, .9),
        height: 80,
        child: Column(
          children: <Widget>[
            ListTile(
              title: Center(
                child: Text(
                  "Loading...",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              subtitle: LinearProgressIndicator(),
            )
          ],
        ),
      );
    });
  }

  Future<StorageItemDetail> _fetchItem(int id) async {
    var controller = _sheetController();
    try {
      var url = await getURL("item/$id");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        Utf8Decoder decode = Utf8Decoder();
        var data = json.decode(decode.convert(response.bodyBytes));
        var item = StorageItemDetail.fromJson(data);
        Future.delayed(Duration(milliseconds: 500), () {
          controller.close();
        });
        return item;
      } else {
        throw ("Error");
      }
    } on Exception catch (err) {
      print(err);
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Failed to fetch item details"),
      ));
      return null;
    }
  }

  Future deleteImage(int id) async {
    try {
      var url = await getURL("itemimage/$id/");
      var response = await Dio().delete(url);
      item.images.removeWhere((i) => i.id == id);
      notifyListeners();
    } catch (err) {
      print(err);
    }
  }

  Future<void> printPDF() async {
    final p = pdf.Document();
    RenderRepaintBoundary boundary = qrKey.currentContext.findRenderObject();
    var image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    final imageProvider = MemoryImage(pngBytes);
    final PdfImage i = await pdfImageFromImageProvider(
      pdf: p.document,
      image: imageProvider,
    );
    p.addPage(
      pdf.Page(
        pageFormat: PdfPageFormat.a4,
        build: (c) => pdf.Container(
          height: 240,
          width: 240,
          child: pdf.Image(i),
        ),
      ),
    );
    await Printing.layoutPdf(onLayout: (f) async => p.save());
  }

  /// Fetch data from  internet
  /// This will set up item
  ///
  /// @param id required
  Future fetchData({@required int id}) async {
    StorageItemDetail item = await _fetchItem(id);
    this.item = item;
    notifyListeners();
  }

  Future fetchItemByQR(BuildContext context, {String qrCode}) async {
    try {
      var url = await getURL("searchByQR?qr=$qrCode");
      final response = await Dio().get(url);
      if (response.data is List) {
        List<StorageItemAbstract> items = (response.data as List)
            .map((i) => StorageItemAbstract.fromJson(i))
            .toList();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (c) => SearchListPage(
              items: items,
            ),
          ),
        );
      } else {
        StorageItemAbstract item = StorageItemAbstract.fromJson(response.data);
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) {
            return ItemDetailPage(
              id: item.id,
              name: item.name,
              author: item.authorName,
              series: item.seriesName,
            );
          }),
        );
      }
    } catch (err) {
      throw Exception("No item");
    }
  }

  /// Update item
  updateItem(StorageItemDetail item) {
    this.item = item;
    notifyListeners();
  }
}
