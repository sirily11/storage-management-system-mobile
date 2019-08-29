import 'dart:convert';
import 'dart:io';

import 'package:mobile/DataObj/Decodeable.dart';
import 'package:mobile/DataObj/StorageItem.dart';
import 'package:mobile/utils/utils.dart';
import 'package:http/http.dart' as http;

class Uploader<T> {
  final http.Client client;

  Uploader({this.client});

  Future<String> getAPIURL() async {
    if (T == Category) {
      return await getURL("category/");
    } else if (T == Series) {
      return await getURL("series/");
    } else if (T == Author) {
      return await getURL("author/");
    } else if (T == Location) {
      return await getURL("location/");
    } else if (T == Position) {
      return await getURL("detail-position/");
    } else {
      throw Exception("No such url");
    }
  }

  /// Convert json to object
  Decodeable _castObject(dynamic json) {
    if (T == Category) {
      return Category.fromJson(json);
    } else if (T == Series) {
      return Series.fromJson(json);
    } else if (T == Author) {
      return Author.fromJson(json);
    } else if (T == Location) {
      return Location.fromJson(json);
    } else if (T == Position) {
      return Position.fromJson(json);
    } else {
      throw Exception("Cannot convert object");
    }
  }

  /// Create new entry
  Future create(Map<String, dynamic> object) async {
    if (client == null) {
      throw Exception("Client should not be null");
    }
    String url = await getAPIURL();
    var jsonBody = json.encode(object);
    final response = await client.post(url,
        body: jsonBody,
        headers: {HttpHeaders.contentTypeHeader: "application/json"});

    if (response.statusCode == 201) {
      Utf8Decoder decode = Utf8Decoder();
      var data = json.decode(decode.convert(response.bodyBytes));
      return _castObject(data) as T;
    }
    return null;
  }


  /// update current entry
  Future update(Map<String, dynamic> object) async {
    if (client == null) {
      throw Exception("Client should not be null");
    }
    String url = await getAPIURL();
    var jsonBody = json.encode(object);
    final response = await client.patch("$url${object['id']}/",
        body: jsonBody,
        headers: {HttpHeaders.contentTypeHeader: "application/json"});

    if (response.statusCode == 200) {
      Utf8Decoder decode = Utf8Decoder();
      var data = json.decode(decode.convert(response.bodyBytes));
      return _castObject(data) as T;
    }
    return null;
  }

  /// update current entry
  Future delete(int id) async {
    if (client == null) {
      throw Exception("Client should not be null");
    }
    String url = await getAPIURL();
    final response = await client.delete("$url$id/",
        headers: {HttpHeaders.contentTypeHeader: "application/json"});

    return;
  }
}
