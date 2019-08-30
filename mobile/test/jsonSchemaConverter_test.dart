// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/DataObj/StorageItem.dart';
import 'package:mobile/Edit/JSONForm/ShemaConverter.dart';
import 'package:mobile/utils/Uploader.dart';
import 'package:mobile/utils/utils.dart';
import 'package:mockito/mockito.dart';
import 'package:mobile/DataObj/Schema.dart';

void main() {
  group("test schema converter", () {
    test("Not nested schema", () async {
      Map<String, dynamic> jsonSchema = {
        "id": {
          "type": "integer",
          "required": false,
          "read_only": true,
          "label": "ID"
        },
        "name": {
          "type": "string",
          "required": false,
          "read_only": false,
          "label": "Book Name",
          "max_length": 1024
        }
      };
      Map<String, dynamic> values = {
        "name": {"id": 1, "name": "test"}
      };
      SchemaConverter converter =
          SchemaConverter(schema: jsonSchema, defaultValues: values);
      SchemaList result = converter.convert();
      expect(result.id, values['id']);
      expect(result.schemaList.length, 1);
      expect(result.schemaList[0].maxLength, 1024);
      expect(result.schemaList[0].label, "Book Name");
      expect(result.schemaList[0].type, "string");
      expect(result.schemaList[0].value.label, "test");
    });
    test("Nested schema", () async {
      Map<String, dynamic> jsonSchema = {
        "author_name": {
          "type": "nested object",
          "required": false,
          "read_only": true,
          "label": "Author name",
          "children": {
            "id": {
              "type": "integer",
              "required": false,
              "read_only": true,
              "label": "ID"
            },
            "name": {
              "type": "string",
              "required": false,
              "read_only": false,
              "label": "Name",
              "max_length": 128
            },
            "description": {
              "type": "string",
              "required": false,
              "read_only": false,
              "label": "Description",
              "max_length": 1024
            }
          }
        }
      };
      Map<String, dynamic> values = {
        "id": 1,
        "author_name": {"id": 1, "name": "Test3", "description": "Test"},
      };
      SchemaConverter converter =
          SchemaConverter(schema: jsonSchema, defaultValues: values);
      SchemaList result = converter.convert();
      expect(result.id, values['id']);
      expect(result.schemaList.length, 1);
      expect(result.schemaList[0].key, "author_name");
      expect(result.schemaList[0].value.label, "Test3");
      expect(result.schemaList[0].value.value, 1);

      var json = result.toJSON();
      expect(json['author_name'], 1);
    });

    test("Nested schema with children parse", () async {
      Map<String, dynamic> jsonSchema = {
        "author_name": {
          "type": "nested object",
          "required": false,
          "read_only": true,
          "label": "Author name",
          "children": {
            "id": {
              "type": "integer",
              "required": false,
              "read_only": true,
              "label": "ID"
            },
            "name": {
              "type": "string",
              "required": false,
              "read_only": false,
              "label": "Name",
              "max_length": 128
            },
            "description": {
              "type": "string",
              "required": false,
              "read_only": false,
              "label": "Description",
              "max_length": 1024
            }
          }
        }
      };
      Map<String, dynamic> values = {
        "id": 1,
        "author_name": {"id": 1, "name": "Test3", "description": "Test"},
      };
      SchemaConverter converter =
          SchemaConverter(schema: jsonSchema, defaultValues: values);
      SchemaList result = converter.convert();
      expect(result.schemaList[0].childern.schemaList.length, 2);

      var json = result.toJSON();
      expect(json['author_name'], 1);
    });

    test("Nested schema with children and selection", () async {
      Map<String, dynamic> jsonSchema = {
        "author_name": {
          "type": "nested object",
          "required": false,
          "read_only": true,
          "label": "Author name",
          "children": {
            "id": {
              "type": "integer",
              "required": false,
              "read_only": true,
              "label": "ID"
            },
            "name": {
              "type": "string",
              "required": false,
              "read_only": false,
              "label": "Name",
              "max_length": 128
            },
            "description": {
              "type": "string",
              "required": false,
              "read_only": false,
              "label": "Description",
              "max_length": 1024
            }
          }
        }
      };
      Map<String, dynamic> values = {
        "id": 1,
        "author_name": {"id": 1, "name": "Test3", "description": "Test"},
      };

      Map<String, dynamic> selections = {
        "author_name": [
          {"id": 1, "name": "Test3", "description": "Test"},
          {"id": 2, "name": "Test4"}
        ]
      };
      SchemaConverter converter = SchemaConverter(
          schema: jsonSchema, defaultValues: values, selections: selections);
      SchemaList result = converter.convert();
      expect(result.schemaList[0].selections.length, 2);
      expect(result.schemaList[0].selections[1].value, 2);
      expect(result.schemaList[0].selections[1].label, "Test4");
    });
  });
}
