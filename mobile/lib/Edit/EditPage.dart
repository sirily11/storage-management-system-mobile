import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile/Edit/details/AuthorDetail.dart';
import 'package:mobile/States/ItemDetailEditPageState.dart';
import 'package:mobile/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditPage extends StatefulWidget {
  final bool isEditMode;

  EditPage({this.isEditMode = false});

  @override
  State<StatefulWidget> createState() {
    return EditPageState();
  }
}

class EditPageState extends State<EditPage> {
  final bool isEditMode;
  final _formKey = GlobalKey<FormState>();
  final itemNameController = TextEditingController();
  final itemDescriptionController = TextEditingController();
  String value = "";

  EditPageState({this.isEditMode});

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    final prefs = await SharedPreferences.getInstance();
  }

  Widget priceColRowWidget() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
            child: TextFormField(
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
      if (page == "author") {
        return AuthorDetail(
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
            decoration: InputDecoration(labelText: "Select series"),
            value: settingsState.selectedAuthor,
            onChanged: (value) {
              settingsState.selectedAuthor = value;
              settingsState.update();
            },
            items: settingsState.series.map<DropdownMenuItem>((category) {
              return DropdownMenuItem(
                value: category.id,
                child: Text(category.name),
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

  Widget seriesSelector() {
    ItemDetailEditPageState settingsState =
        Provider.of<ItemDetailEditPageState>(context);
    return Row(
      children: <Widget>[
        Expanded(
          child: DropdownButtonFormField(
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

  Widget positionSelector() {
    ItemDetailEditPageState settingsState =
        Provider.of<ItemDetailEditPageState>(context);
    return Row(
      children: <Widget>[
        Expanded(
          child: DropdownButtonFormField(
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

  Widget locationSelector() {
    ItemDetailEditPageState settingsState =
        Provider.of<ItemDetailEditPageState>(context);
    return Row(
      children: <Widget>[
        Expanded(
          child: DropdownButtonFormField(
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

  Widget formList() {
    return ListView(
      children: <Widget>[
        TextFormField(
          controller: itemNameController,
          validator: isEmpty,
          decoration: InputDecoration(labelText: "Item Name"),
        ),
        TextFormField(
            controller: itemDescriptionController,
            validator: isEmpty,
            decoration: InputDecoration(labelText: "Item Description"),
            minLines: 3,
            maxLines: 3),
        priceColRowWidget(),
        authorSelector()
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
        appBar: AppBar(
          title: Text("Add new item"),
        ),
        body: Container(
          child: Form(
            key: _formKey,
            child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: formList()),
          ),
        ),
      ),
    );
  }
}
