import 'dart:convert';
import 'dart:io';

import 'package:mobile/DataObj/Decodeable.dart';
import 'package:mobile/DataObj/StorageItem.dart';
import 'package:mobile/utils/utils.dart';
import 'package:http/http.dart' as http;

class Uploader<T> {
  final http.Client client;

  Uploader({this.client});

  String getAPIURL(Decodeable object) {
    if (object is Category) {
      return getURL("category/");
    } else if (object is Series) {
      return getURL("series/");
    } else if (object is Author) {
      return getURL("author/");
    } else if (object is Location) {
      return getURL("location/");
    } else if (object is Position) {
      return getURL("detail-position/");
    }
  }

  Decodeable _castObject(dynamic json, Decodeable object) {
    if (object is Category) {
      return Category.fromJson(json);
    } else if (object is Series) {
      return Series.fromJson(json);
    } else if (object is Author) {
      return Author.fromJson(json);
    } else if (object is Location) {
      return Location.fromJson(json);
    } else if (object is Position) {
      return Position.fromJson(json);
    }
  }

  Future<T> create(Decodeable object) async {
    if (client == null) {
      throw Exception("Client should not be null");
    }
    String url = getAPIURL(object);
    var jsonBody = json.encode(object);
    final response = await client.post(url,
        body: jsonBody,
        headers: {HttpHeaders.contentTypeHeader: "application/json"});

    if (response.statusCode == 201) {
      Utf8Decoder decode = Utf8Decoder();
      var data = json.decode(decode.convert(response.bodyBytes));
      return _castObject(data, object) as T;
    }
    return null;
  }

  Future<T> update(Decodeable object) async {
    if (client == null) {
      throw Exception("Client should not be null");
    }
    String url = getAPIURL(object);
    var jsonBody = json.encode(object);
    final response = await client.patch("$url${object.id}/",
        body: jsonBody,
        headers: {HttpHeaders.contentTypeHeader: "application/json"});

    if (response.statusCode == 200) {
      Utf8Decoder decode = Utf8Decoder();
      var data = json.decode(decode.convert(response.bodyBytes));
      return _castObject(data, object) as T;
    }
    return null;
  }
}
