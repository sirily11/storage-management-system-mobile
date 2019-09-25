class SchemaValue {
  dynamic value;
  dynamic label;
  SchemaValue({this.value, this.label});
  factory SchemaValue.fromJSON(Map<String, dynamic> json) {
    return SchemaValue(value: json['id'], label: json['name']);
  }
}

class Schema {
  String type;

  /// json key
  String key;
  bool isRequired;
  bool isReadOnly;

  /// displayed label
  String label;

  /// json value
  SchemaValue value;
  int maxLength;

  /// only works in nested object
  SchemaList childern;

  /// only works in nested object
  List<SchemaValue> selections;

  Schema(
      {this.key,
      this.type,
      this.isReadOnly,
      this.isRequired,
      this.label,
      this.maxLength,
      this.value,
      this.childern});

  String toString() {
    return "$type $label";
  }

  factory Schema.fromJson(Map<String, dynamic> json) {
    List<Schema> childrenList = [];
    SchemaList list = SchemaList();
    if (json['children'] != null) {
      Map<String, dynamic> children = json['children'];
      for (String key in children.keys) {
        if (key != 'id') {
          Schema s = Schema.fromJson(children[key]);
          s.key = key;
          childrenList.add(s);
        }
      }
      list.schemaList = childrenList;
    }

    return Schema(
        type: json['type'],
        isReadOnly: json['read_only'],
        isRequired: json['required'],
        label: json['label'],
        maxLength: json['max_length'],
        childern: list);
  }
}

class SchemaList {
  List<Schema> schemaList = [];
  int id;

  /// Call this when submit
  Map<String, dynamic> toJSON() {
    Map<String, dynamic> map = {};
    for (var schema in schemaList) {
      map.putIfAbsent(schema.key, () => schema.value.value);
    }
    return map;
  }
}
