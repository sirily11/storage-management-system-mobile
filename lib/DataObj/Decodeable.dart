abstract class Decodeable<T> {
  int id;
  factory Decodeable.fromJson(Map<String, dynamic> json) {
    return null;
  }
  Map toJson() => null;
}
