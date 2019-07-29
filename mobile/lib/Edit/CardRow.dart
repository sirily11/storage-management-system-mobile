import 'package:flutter/material.dart';
import 'package:mobile/utils/utils.dart';

class CardRow extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isMultiline;
  final bool isNumber;

  CardRow(
      {this.controller,
      this.label,
      this.isMultiline = false,
      this.isNumber = false});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: new ThemeData(
        hintColor: Colors.white,
        focusColor: Colors.white,
        accentColor: Colors.white,
        primaryColor: Colors.orange[300],
        primaryColorDark: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: TextFormField(
            controller: controller,
            style: TextStyle(color: Colors.white),
            validator: isEmpty,
            keyboardType: isNumber ? TextInputType.number : null,
            maxLines: isMultiline ? 3 : 1,
            decoration: InputDecoration(
              filled: true,
              fillColor: Color.fromRGBO(64, 75, 90, .8),
              labelText: label,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.white, width: 0.0)),
            )),
      ),
    );
  }
}


