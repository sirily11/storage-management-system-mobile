import 'package:flutter/widgets.dart';
import 'package:mobile/DataObj/Schema.dart';

class SchemaConverter {
  Map<String, dynamic> schema;
  Map<String, dynamic> defaultValues;

  SchemaConverter({@required this.schema, @required this.defaultValues});

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
          s.value = SchemaValue(
              label: defaultValues[key]['name'],
              value: defaultValues[key]['id']);
        } else {
          s.value = SchemaValue(value: defaultValues[key]);
        }
        _schemaList.add(s);
      }
    }
    schemaList.schemaList = _schemaList;
    return schemaList;
  }
}
