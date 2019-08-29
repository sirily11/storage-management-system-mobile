import 'package:flutter/widgets.dart';
import 'package:mobile/DataObj/Schema.dart';

class SchemaConverter {
  /// structure of the schema
  /// {
  /// "id": {
  ///     "type": "integer",
  ///     "required": false,
  ///     "read_only": true,
  ///     "label": "ID"
  ///   }
  /// }
  Map<String, dynamic> schema;

  /// Structure of the value
  /// {
  ///  "author": {
  ///     "id": 1,
  ///     "name": "test2",
  ///     "description": "test"
  ///   }
  /// }
  Map<String, dynamic> defaultValues;

  /// structure of the selection
  /// {
  ///  "categories": [
  ///      {
  ///          "id": 1,
  ///          "name": "test"
  ///      }
  ///  ]
  /// }
  Map<String, dynamic> selections;

  SchemaConverter(
      {@required this.schema, @required this.defaultValues, this.selections});

  /// Schema should have its own name property if it is a nested object
  /// Nested object
  /// {'description' : { 'name': 'hello', 'value': 1 }}
  /// otherwise
  /// {'description' : 'hello' }
  SchemaList convert() {
    SchemaList schemaList = SchemaList();
    List<Schema> _schemaList = [];
    schemaList.id = defaultValues['id'];
    for (String key in schema.keys) {
      if (key != 'id') {
        Schema s = Schema.fromJson(schema[key]);
        s.key = key;
        if (s.type == "nested object") {
          // add selected value
          s.value = SchemaValue(
              label: defaultValues[key]['name'],
              value: defaultValues[key]['id']);
          // add selection
          if (selections != null && selections[key] != null) {
            List<SchemaValue> selectionList = [];
            for (var data in selections[key]) {
              SchemaValue value = SchemaValue.fromJSON(data);
              selectionList.add(value);
            }
            s.selections = selectionList;
          }
        } else {
          s.value = SchemaValue(
              value: defaultValues[key]['name'],
              label: defaultValues[key]['name']);
        }
        _schemaList.add(s);
      }
    }
    schemaList.schemaList = _schemaList;
    return schemaList;
  }
}
