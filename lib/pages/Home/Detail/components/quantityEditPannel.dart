import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:storage_management_mobile/States/ItemProvider.dart';

class QuantityEdit extends StatefulWidget {
  @override
  _QuantityEditState createState() => _QuantityEditState();
}

class _QuantityEditState extends State<QuantityEdit> {
  int value = 0;
  bool hasModified = false;

  @override
  void initState() {
    super.initState();
    ItemProvider itemDetailState = Provider.of(context, listen: false);
    value = itemDetailState.item.quantity;
  }

  @override
  Widget build(BuildContext context) {
    ItemProvider itemDetailState = Provider.of(context);
    return Container(
      key: Key("Quantity Edit Panel"),
      width: MediaQuery.of(context).size.width,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    setState(() {
                      if (value > 0) {
                        hasModified = true;
                        value = value - 1;
                      }
                    });
                  },
                  child: Icon(Icons.remove),
                ),
                Expanded(
                  child: Align(
                    child: Text(
                      value.toString(),
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    setState(() {
                      hasModified = true;
                      value = value + 1;
                    });
                  },
                  child: Icon(Icons.add),
                ),
              ],
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 100),
              height: hasModified ? 30 : 0,
              child: FlatButton(
                key: Key("Set value"),
                onPressed: () async {
                  try {
                    await itemDetailState.modifyQuantity(value);
                    setState(() {
                      hasModified = false;
                    });
                  } catch (err) {
                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Update Quantity Error"),
                        content: Text("$err"),
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
                child: Text("Set Value"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
