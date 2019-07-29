import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile/DataObj/StorageItem.dart';
import 'package:mobile/Edit/CardRow.dart';
import 'package:mobile/Edit/CardTheme.dart';
import 'package:mobile/Edit/EditPage2.dart';
import 'package:mobile/Edit/details/AuthorDetail.dart';
import 'package:mobile/Edit/details/CategoryDetail.dart';
import 'package:mobile/Edit/details/DetailPositionDetail.dart';
import 'package:mobile/Edit/details/LocationDetail.dart';
import 'package:mobile/Edit/details/SeriesDetail.dart';
import 'package:mobile/States/ItemDetailEditPageState.dart';
import 'package:mobile/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditPage extends StatefulWidget {
  final bool isEditMode;
  final int id;
  final StorageItemDetail item;

  Function addItem;
  Function updateItem;

  EditPage(
      {this.isEditMode = false,
      this.addItem,
      this.id,
      this.item,
      this.updateItem});

  @override
  State<StatefulWidget> createState() {
    return EditPageState(
        addItemToHome: this.addItem,
        isEditMode: isEditMode,
        id: id,
        item: item,
        updateDetailPageItem: this.updateItem);
  }
}

class EditPageState extends State<EditPage>
    with SingleTickerProviderStateMixin {
  final bool isEditMode;
  final int id;
  Function addItemToHome;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final itemNameController = TextEditingController();
  final itemDescriptionController = TextEditingController();
  final priceController = TextEditingController();
  final columnController = TextEditingController();
  final rowController = TextEditingController();
  final qrController = TextEditingController();
  TabController tabController;
  bool canSave = false;

  final StorageItemDetail item;
  final Function updateDetailPageItem;

  String value = "";

  EditPageState(
      {this.isEditMode = false,
      this.addItemToHome,
      this.id,
      this.item,
      this.updateDetailPageItem});

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    if (item != null) {
      priceController.text = item.price.toString();
      itemNameController.text = item.name;
      itemDescriptionController.text = item.description;
      columnController.text = item.column.toString();
      rowController.text = item.row.toString();
      qrController.text = item.qrCode;
    }
  }

  Widget priceColRowWidget() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
            child: CardRow(
              controller: priceController,
              label: "Price",
              isNumber: true,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: CardRow(
              controller: columnController,
              isNumber: true,
              label: "Column",
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
            child: CardRow(
              label: "Row",
              controller: rowController,
              isNumber: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget unitSelector() {
    ItemDetailEditPageState settingsState =
        Provider.of<ItemDetailEditPageState>(context);
    return Row(
      children: <Widget>[
        Expanded(
          child: CardSelectorTheme(
            child: DropdownButtonFormField(
              validator: isSelected,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color.fromRGBO(64, 75, 90, .8),
                labelText: "Select unit",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              value: settingsState.unit,
              onChanged: (value) {
                settingsState.unit = value;
                settingsState.update();
              },
              items: currencyUnit.map<DropdownMenuItem>((c) {
                return DropdownMenuItem(
                  value: c,
                  child: SizedBox(
                    child: Text(
                      c.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                    width: 140,
                  ),
                );
              }).toList(),
            ),
          ),
        )
      ],
    );
  }

  Widget submitButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
      child: RaisedButton(
        color: Colors.blue,
        child: Text(
          isEditMode ? "Update item" : "Add item",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: !canSave
            ? null
            : () async {
                if (canSave) {
                  if (this.isEditMode) {
                    await update();
                  } else {
                    await addNewItem();
                  }
                }
              },
      ),
    );
  }

  Future addNewItem() async {
    try {
      ItemDetailEditPageState settings =
          Provider.of<ItemDetailEditPageState>(context);
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Adding item"),
      ));
      StorageItemAbstract item = await addItem(StorageItemDetail(
          name: itemNameController.text,
          description: itemDescriptionController.text,
          price: double.parse(priceController.text),
          column: int.parse(columnController.text),
          row: int.parse(rowController.text),
          qrCode: qrController.text,
          unit: settings.unit,
          author: Author(id: settings.selectedAuthor),
          series: Series(id: settings.selectedSeries),
          category: Category(id: settings.selectedCategory),
          position: Position(id: settings.selectedPosition),
          location: Location(id: settings.selectedLocation)));
      addItemToHome(item);
      Navigator.of(context).pop();
    } on Exception catch (err) {
      print(err);
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(err.toString()),
      ));
    }
  }

  Future update() async {
    try {
      ItemDetailEditPageState settings =
          Provider.of<ItemDetailEditPageState>(context);
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Updating item"),
      ));
      StorageItemDetail item = await UpdateItem(StorageItemDetail(
          id: id,
          name: itemNameController.text,
          description: itemDescriptionController.text,
          price: double.parse(priceController.text),
          column: int.parse(columnController.text),
          row: int.parse(rowController.text),
          qrCode: qrController.text,
          author: Author(id: settings.selectedAuthor),
          series: Series(id: settings.selectedSeries),
          category: Category(id: settings.selectedCategory),
          position: Position(id: settings.selectedPosition),
          unit: settings.unit,
          location: Location(id: settings.selectedLocation)));
      updateDetailPageItem(item);
      Navigator.of(context).pop();
    } on Exception catch (err) {
      print(err);
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(err.toString()),
      ));
    }
  }

  Future scan() async {
    ItemDetailEditPageState settings =
        Provider.of<ItemDetailEditPageState>(context);
    try {
      String barcode = await BarcodeScanner.scan();
      settings.qrCode = barcode;
      setState(() {
        qrController.text = barcode;
        settings.update();
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Unable to access camera"),
        ));
      }
    } on FormatException {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("No qr has been scanned"),
      ));
    }
  }

  Widget qrField() {
    ItemDetailEditPageState settingsState =
        Provider.of<ItemDetailEditPageState>(context);
    return Row(
      children: <Widget>[
        Expanded(
          flex: 8,
          child: CardRow(label: "QRField", controller: qrController),
        ),
        Expanded(
          flex: 2,
          child: IconButton(
            icon: Icon(
              Icons.camera_alt,
              color: Colors.white,
            ),
            onPressed: () async {
              await scan();
            },
          ),
        ),
      ],
    );
  }

  Widget formList() {
    ItemDetailEditPageState settingsState =
        Provider.of<ItemDetailEditPageState>(context);
    return ListView(
      children: <Widget>[
        CardRow(
          controller: itemNameController,
          label: "Item Name",
        ),
        CardRow(
          controller: itemDescriptionController,
          label: "Item Description",
          isMultiline: true,
        ),
        qrField(),
        priceColRowWidget(),
        unitSelector(),
        nextPageBtn()
      ],
    );
  }

  Widget nextPageBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(1, 1, 20, 1),
          child: ClipOval(
            child: Material(
              color: Colors.blue, // button color
              child: InkWell(
                onTapDown: (e) {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    tabController.index = 1;
                  }
                },
                splashColor: Colors.red, // inkwell color
                child: SizedBox(
                    width: 56,
                    height: 56,
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    )),
                onTap: () {},
              ),
            ),
          ),
        ),
      ],
    );
    // return Padding(
    //   padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
    // child: IconButton(
    //   color: Colors.white,
    //   icon: Icon(Icons.arrow_forward),
    //   onPressed: () async {
    //     if (_formKey.currentState.validate()) {
    //       _formKey.currentState.save();
    //       tabController.index = 1;
    //     }
    //   },
    // ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    ItemDetailEditPageState settings =
        Provider.of<ItemDetailEditPageState>(context);
    return GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
            backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text(isEditMode ? "Update item" : "Add new item"),
              bottom: TabBar(
                controller: tabController,
                tabs: <Widget>[
                  Tab(
                    text: "设置商品信息",
                  ),
                  Tab(
                    text: "选择商品种类",
                  )
                ],
              ),
            ),
            body: Form(
              key: _formKey,
              child: TabBarView(
                controller: tabController,
                children: <Widget>[
                  formList(),
                  EditPageTwo(
                    canSave: canSave,
                    submitBtn: this.submitButton(),
                  )
                ],
              ),
            )));
  }
}
