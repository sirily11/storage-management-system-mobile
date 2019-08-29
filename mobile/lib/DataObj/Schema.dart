class SchemaValue {
  dynamic value;
  dynamic label;
  SchemaValue({this.value, this.label});
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

  /// only works in nested objecy
  List<Schema> childern;

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
    return Schema(
        type: json['type'],
        isReadOnly: json['read_only'],
        isRequired: json['required'],
        label: json['label'],
        maxLength: json['max_length']);
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
