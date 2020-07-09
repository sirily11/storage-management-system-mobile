import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storage_management_mobile/DataObj/StorageItem.dart';
import 'package:storage_management_mobile/States/LoginProvider.dart';
import 'package:storage_management_mobile/States/urls.dart';
import 'package:storage_management_mobile/pages/Home/Detail/ItemDetailPage.dart';
import 'package:storage_management_mobile/pages/SearchListPage/SearchListPage.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;

class ItemProvider with ChangeNotifier {
  StorageItemDetail item;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey qrKey = new GlobalKey();
  String baseURL;
  Dio dio;

  ItemProvider({Dio networkProvider}) {
    this.dio = networkProvider ?? Dio();
    this.initURL();
  }

  Future<void> initURL() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    this.baseURL = preferences.getString("server") ?? "";
    notifyListeners();
  }

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
      var url = "$baseURL$itemURL/$id";
      final response = await this.dio.get(url);
      var item = StorageItemDetail.fromJson(response.data);
      Future.delayed(Duration(milliseconds: 500), () {
        controller.close();
      });
      return item;
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
      var url = "$baseURL$itemImageURL/$id/";
      var header = await LoginProvider.getLoginAccessKey();
      var response = await this.dio.delete(
            url,
            options: Options(headers: header),
          );
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
          height: 140,
          width: 140,
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
      var url = "$baseURL/storage_management/searchByQR?qr=$qrCode";
      final response = await this.dio.get(url);
      if (response.data is List) {
        /// qr code is a detail position
        List<StorageItemAbstract> items = (response.data as List)
            .map((i) => StorageItemAbstract.fromJson(i))
            .toList();
        try {
          await CupertinoScaffold.showCupertinoModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            expand: true,
            builder: (context, controller) => SearchListPage(
              items: items,
            ),
          );
        } catch (err) {
          await showCupertinoModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            expand: true,
            builder: (context, controller) => SearchListPage(
              items: items,
            ),
          );
        }
      } else {
        StorageItemAbstract item = StorageItemAbstract.fromJson(response.data);
        Navigator.of(context).push(
          MaterialWithModalsPageRoute(builder: (context) {
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

  Future<void> modifyQuantity(int value) async {
    try {
      var url = "$baseURL$itemURL/${item.id}/";
      var header = await LoginProvider.getLoginAccessKey();
      var response = await this.dio.patch(
            url,
            data: {"quantity": value},
            options: Options(headers: header),
          );
      item.quantity = value;
      notifyListeners();
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  Future<void> updateLocation({
    @required double latitude,
    @required double longitude,
  }) async {
    var url = "$baseURL$locationURL/${item.location.id}/";
    var header = await LoginProvider.getLoginAccessKey();
    await this.dio.patch(
          url,
          data: {"latitude": latitude, "longitude": longitude},
          options: Options(headers: header),
        );
    await this._fetchItem(item.id);
  }

  static Future<File> pickImage(ImageSource source) async {
    var imagePicker = ImagePicker();
    PickedFile image = await imagePicker.getImage(source: source);
    File imageFile = File(image.path);
    return imageFile;
  }
}
