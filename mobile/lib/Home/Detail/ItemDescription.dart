import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ItemDescription extends StatelessWidget{
  final String description;
  ItemDescription(this.description);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        maxLines: 3,
        decoration: InputDecoration(labelText: "Description"),
        initialValue: description,
      ),
    );
  }


}