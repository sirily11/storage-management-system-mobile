class Schema {
  String type;
  String key;
  bool isRequired;
  bool isReadOnly;
  String label;
  var value;
  int maxLength;

  Schema(
      {this.key,
      this.type,
      this.isReadOnly,
      this.isRequired,
      this.label,
      this.maxLength,
      this.value});

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
