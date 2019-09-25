class Message {
  String type;
  String from;
  String body;

  Message({this.type, this.body, this.from});

  String toString() {
    return "$type $from $body";
  }

  Map<String, dynamic> toJson() => {'type': type, 'from': from, "body": body};

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(type: json['type'], from: json['from'], body: json['body']);
  }
}
