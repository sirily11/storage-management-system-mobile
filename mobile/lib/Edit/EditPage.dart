import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile/DataObj/StorageItem.dart';
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

class EditPageState extends State<EditPage> {
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
            child: TextFormField(
              controller: priceController,
              validator: isEmpty,
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Price"),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextFormField(
              controller: columnController,
              validator: isEmpty,
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Column"),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
            child: TextFormField(
              controller: rowController,
              validator: isEmpty,
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Row"),
            ),
          ),
        ),
      ],
    );
  }

  Widget dropdownActions(
      {Function add, Function edit, Function remove, int editValue}) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: IconButton(
            disabledColor: Colors.grey,
            color: Colors.blue,
            icon: Icon(
              Icons.edit,
            ),
            onPressed: editValue != null ? edit : null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: IconButton(
            color: Colors.blueGrey,
            icon: Icon(
              Icons.add_circle,
            ),
            onPressed: add,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: IconButton(
            color: Colors.blueGrey,
            icon: Icon(
              Icons.remove_circle,
            ),
            onPressed: remove,
          ),
        )
      ],
    );
  }

  onAddSelection(String page, {bool isEdit = false}) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      switch (page) {
        case "author":
          return AuthorDetail(
            isEdit: isEdit,
          );
        case "category":
          return CategoryDetail(
            isEdit: isEdit,
          );
        case "series":
          return SeriesEditDetail(
            isEdit: isEdit,
          );
        case "position":
          return PositionDetail(
            isEdit: isEdit,
          );
        case "location":
          return LocationDetailEditPage(
            isEdit: isEdit,
          );
      }
    }));
  }

  Widget authorSelector() {
    ItemDetailEditPageState settingsState =
        Provider.of<ItemDetailEditPageState>(context);
    return Row(
      children: <Widget>[
        Expanded(
          child: DropdownButtonFormField(
            validator: isSelected,
            decoration: InputDecoration(labelText: "Select author"),
            value: settingsState.selectedAuthor,
            onChanged: (value) {
              settingsState.selectedAuthor = value;
              settingsState.update();
            },
            items: settingsState.authors.map<DropdownMenuItem>((author) {
              return DropdownMenuItem(
                value: author.id,
                child: Text(author.name),
              );
            }).toList(),
          ),
        ),
        Expanded(
            child: dropdownActions(
                editValue: settingsState.selectedAuthor,
                add: () => onAddSelection("author"),
                edit: () => onAddSelection("author", isEdit: true),
                remove: () {
                  settingsState.selectedAuthor = null;
                  settingsState.update();
                }))
      ],
    );
  }

  Widget categorySelector() {
    ItemDetailEditPageState settingsState =
        Provider.of<ItemDetailEditPageState>(context);
    return Row(
      children: <Widget>[
        Expanded(
          child: DropdownButtonFormField(
            validator: isSelected,
            decoration: InputDecoration(labelText: "Select categories"),
            value: settingsState.selectedCategory,
            onChanged: (value) {
              settingsState.selectedCategory = value;
              settingsState.update();
            },
            items: settingsState.categories.map<DropdownMenuItem>((category) {
              return DropdownMenuItem(
                value: category.id,
                child: Text(category.name),
              );
            }).toList(),
          ),
        ),
        Expanded(
            child: dropdownActions(
                editValue: settingsState.selectedCategory,
                add: () => onAddSelection("category"),
                edit: () => onAddSelection("category", isEdit: true),
                remove: () {
                  settingsState.selectedCategory = null;
                  settingsState.update();
                }))
      ],
    );
  }

  Widget seriesSelector() {
    ItemDetailEditPageState settingsState =
        Provider.of<ItemDetailEditPageState>(context);
    return Row(
      children: <Widget>[
        Expanded(
          child: DropdownButtonFormField(
            validator: isSelected,
            decoration: InputDecoration(labelText: "Select Series"),
            value: settingsState.selectedSeries,
            onChanged: (value) {
              settingsState.selectedSeries = value;
              settingsState.update();
            },
            items: settingsState.series.map<DropdownMenuItem>((s) {
              return DropdownMenuItem(
                value: s.id,
                child: Text(s.name),
              );
            }).toList(),
          ),
        ),
        Expanded(
            child: dropdownActions(
                editValue: settingsState.selectedSeries,
                add: () => onAddSelection("series"),
                edit: () => onAddSelection("series", isEdit: true),
                remove: () {
                  settingsState.selectedSeries = null;
                  settingsState.update();
                }))
      ],
    );
  }

  Widget positionSelector() {
    ItemDetailEditPageState settingsState =
        Provider.of<ItemDetailEditPageState>(context);
    return Row(
      children: <Widget>[
        Expanded(
          child: DropdownButtonFormField(
            validator: isSelected,
            decoration: InputDecoration(labelText: "Select Detail Position"),
            value: settingsState.selectedPosition,
            onChanged: (value) {
              settingsState.selectedPosition = value;
              settingsState.update();
            },
            items: settingsState.positions.map<DropdownMenuItem>((position) {
              return DropdownMenuItem(
                value: position.id,
                child: Text(position.name),
              );
            }).toList(),
          ),
        ),
        Expanded(
            child: dropdownActions(
                editValue: settingsState.selectedPosition,
                add: () => onAddSelection("position"),
                edit: () => onAddSelection("position", isEdit: true),
                remove: () {
                  settingsState.selectedPosition = null;
                  settingsState.update();
                }))
      ],
    );
  }

  Widget locationSelector() {
    ItemDetailEditPageState settingsState =
        Provider.of<ItemDetailEditPageState>(context);
    return Row(
      children: <Widget>[
        Expanded(
          child: DropdownButtonFormField(
            validator: isSelected,
            decoration: InputDecoration(labelText: "Select Location"),
            value: settingsState.selectedLocation,
            onChanged: (value) {
              settingsState.selectedLocation = value;
              settingsState.update();
            },
            items: settingsState.locations.map<DropdownMenuItem>((location) {
              return DropdownMenuItem(
                value: location.id,
                child: SizedBox(
                  child: Text(location.toString()),
                  width: 140,
                ),
              );
            }).toList(),
          ),
        ),
        Expanded(
            child: dropdownActions(
                editValue: settingsState.selectedLocation,
                add: () => onAddSelection("location"),
                edit: () => onAddSelection("location", isEdit: true),
                remove: () {
                  settingsState.selectedLocation = null;
                  settingsState.update();
                }))
      ],
    );
  }

  Widget unitSelector() {
    ItemDetailEditPageState settingsState =
        Provider.of<ItemDetailEditPageState>(context);
    return Row(
      children: <Widget>[
        Expanded(
          child: DropdownButtonFormField(
            validator: isSelected,
            decoration: InputDecoration(labelText: "Select Unit"),
            value: settingsState.unit,
            onChanged: (value) {
              settingsState.unit = value;
              settingsState.update();
            },
            items: currencyUnit.map<DropdownMenuItem>((c) {
              return DropdownMenuItem(
                value: c,
                child: SizedBox(
                  child: Text(c.toString()),
                  width: 140,
                ),
              );
            }).toList(),
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
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
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
          flex: 7,
          child: TextField(
            controller: qrController,
            decoration: InputDecoration(labelText: "QR Code"),
          ),
        ),
        Expanded(
          flex: 3,
          child: IconButton(
            icon: Icon(Icons.camera_alt),
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
        TextFormField(
            controller: itemNameController,
            validator: isEmpty,
            decoration: InputDecoration(labelText: "Item Name")),
        TextFormField(
            controller: itemDescriptionController,
            validator: isEmpty,
            decoration: InputDecoration(labelText: "Item Description"),
            minLines: 3,
            maxLines: 3),
        qrField(),
        priceColRowWidget(),
        unitSelector(),
        authorSelector(),
        categorySelector(),
        seriesSelector(),
        positionSelector(),
        locationSelector(),
        submitButton()
      ],
    );
  }

  tempSave() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("itemName", itemNameController.text);
  }

  @override
  Widget build(BuildContext context) {
    ItemDetailEditPageState settings =
        Provider.of<ItemDetailEditPageState>(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(isEditMode ? "Update item" : "Add new item"),
        ),
        body: Container(
          child: Form(
            key: _formKey,
            child: Scrollbar(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: formList()),
            ),
          ),
        ),
      ),
    );
  }
}
