import 'package:flutter/material.dart';
import 'package:mobile/DataObj/Schema.dart';

class JSONTextFormField extends StatelessWidget {
  final Schema jsonSchema;
  JSONTextFormField({@required this.jsonSchema});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
          initialValue: jsonSchema.value.value,
          maxLines: jsonSchema.maxLength > 128 ? 8 : 1,
          minLines: jsonSchema.maxLength > 128 ? 8 : 1,
          style: TextStyle(color: Colors.white),
          onSaved: (value) {
            jsonSchema.value.value = value;
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Color.fromRGBO(64, 75, 90, .8),
            labelText: jsonSchema.label,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.white, width: 0.0)),
          )),
    );
  }
}
