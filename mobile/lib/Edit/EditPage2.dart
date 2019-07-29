import 'package:flutter/material.dart';
import 'package:mobile/States/ItemDetailEditPageState.dart';
import 'package:mobile/utils/utils.dart';
import 'package:provider/provider.dart';

import 'CardTheme.dart';
import 'details/AuthorDetail.dart';
import 'details/CategoryDetail.dart';
import 'details/DetailPositionDetail.dart';
import 'details/LocationDetail.dart';
import 'details/SeriesDetail.dart';

class EditPageTwo extends StatefulWidget {
  final Widget submitBtn;
  final bool canSave;

  EditPageTwo({this.submitBtn, this.canSave = false});

  @override
  _EditPageTwoState createState() =>
      _EditPageTwoState(submitBtn: this.submitBtn, canSave: canSave);
}

class _EditPageTwoState extends State<EditPageTwo> {
  final Widget submitBtn;
  final bool canSave;

  _EditPageTwoState({this.submitBtn, this.canSave});

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
    return CardSelectorTheme(
      child: Row(
        children: <Widget>[
          Expanded(
            child: DropdownButtonFormField(
              validator: isSelected,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color.fromRGBO(64, 75, 90, .8),
                labelText: "Select Author",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              value: settingsState.selectedAuthor,
              onChanged: (value) {
                settingsState.selectedAuthor = value;
                settingsState.update();
              },
              items: settingsState.authors.map<DropdownMenuItem>((author) {
                return DropdownMenuItem(
                  value: author.id,
                  child: Text(
                    author.name,
                    style: TextStyle(color: Colors.white),
                  ),
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
      ),
    );
  }

  Widget categorySelector() {
    ItemDetailEditPageState settingsState =
        Provider.of<ItemDetailEditPageState>(context);
    return CardSelectorTheme(
      child: Row(
        children: <Widget>[
          Expanded(
            child: DropdownButtonFormField(
              validator: isSelected,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color.fromRGBO(64, 75, 90, .8),
                labelText: "Select Category",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              value: settingsState.selectedCategory,
              onChanged: (value) {
                settingsState.selectedCategory = value;
                settingsState.update();
              },
              items: settingsState.categories.map<DropdownMenuItem>((category) {
                return DropdownMenuItem(
                  value: category.id,
                  child: Text(
                    category.name,
                    style: TextStyle(color: Colors.white),
                  ),
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
      ),
    );
  }

  Widget seriesSelector() {
    ItemDetailEditPageState settingsState =
        Provider.of<ItemDetailEditPageState>(context);
    return CardSelectorTheme(
      child: Row(
        children: <Widget>[
          Expanded(
            child: DropdownButtonFormField(
              validator: isSelected,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color.fromRGBO(64, 75, 90, .8),
                labelText: "Select Series",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              value: settingsState.selectedSeries,
              onChanged: (value) {
                settingsState.selectedSeries = value;
                settingsState.update();
              },
              items: settingsState.series.map<DropdownMenuItem>((s) {
                return DropdownMenuItem(
                  value: s.id,
                  child: SizedBox(
                      width: 134,
                      child: Text(
                        s.name,
                        style: TextStyle(color: Colors.white),
                      )),
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
      ),
    );
  }

  Widget positionSelector() {
    ItemDetailEditPageState settingsState =
        Provider.of<ItemDetailEditPageState>(context);
    return CardSelectorTheme(
      child: Row(
        children: <Widget>[
          Expanded(
            child: DropdownButtonFormField(
              validator: isSelected,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color.fromRGBO(64, 75, 90, .8),
                labelText: "Select position",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              value: settingsState.selectedPosition,
              onChanged: (value) {
                settingsState.selectedPosition = value;
                settingsState.update();
              },
              items: settingsState.positions.map<DropdownMenuItem>((position) {
                return DropdownMenuItem(
                  value: position.id,
                  child: Text(
                    position.name,
                    style: TextStyle(color: Colors.white),
                  ),
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
      ),
    );
  }

  Widget locationSelector() {
    ItemDetailEditPageState settingsState =
        Provider.of<ItemDetailEditPageState>(context);
    return CardSelectorTheme(
      child: Row(
        children: <Widget>[
          Expanded(
            child: DropdownButtonFormField(
              validator: isSelected,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color.fromRGBO(64, 75, 90, .8),
                labelText: "Select Location",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              value: settingsState.selectedLocation,
              onChanged: (value) {
                settingsState.selectedLocation = value;
                settingsState.update();
              },
              items: settingsState.locations.map<DropdownMenuItem>((location) {
                return DropdownMenuItem(
                  value: location.id,
                  child: SizedBox(
                    child: Text(
                      location.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                    width: 134,
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: ListView(
          children: <Widget>[
            authorSelector(),
            seriesSelector(),
            categorySelector(),
            locationSelector(),
            positionSelector(),
            submitBtn
          ],
        ),
      ),
    );
  }
}
