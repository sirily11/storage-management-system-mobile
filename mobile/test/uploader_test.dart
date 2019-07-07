// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/DataObj/StorageItem.dart';
import 'package:mobile/utils/Uploader.dart';
import 'package:mobile/utils/utils.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

class MockClient extends Mock implements http.Client {}

void main() {
  group("Uploader test", () {
    test("Get correct category url", () {
      Category category = Category(id: 1, name: "Food");
      var url = Uploader<Category>().getAPIURL(category);
      expect(url, getURL("category/"));
    });

    test("Get correct Location url", () {
      Location object = Location(id: 1);
      var url = Uploader<Location>().getAPIURL(object);
      expect(url, getURL("location/"));
    });

    test("Get correct Author url", () {
      Author object = Author(id: 1);
      var url = Uploader<Author>().getAPIURL(object);
      expect(url, getURL("author/"));
    });

    test("Get correct Series url", () {
      Series object = Series(id: 1);
      var url = Uploader<Series>().getAPIURL(object);
      expect(url, getURL("series/"));
    });

    test("Get correct Position url", () {
      Position object = Position(id: 1);
      var url = Uploader<Position>().getAPIURL(object);
      expect(url, getURL("position/"));
    });
  });

  group("create test", () {
    test("create categorty", () async {
      Category category = Category(id: 1, name: "Food");
      final client = MockClient();
      when(client.post(getURL("category/"),
              body: json.encode(category),
              headers: {HttpHeaders.contentTypeHeader: "application/json"}))
          .thenAnswer(
              (_) async => http.Response('{"id" : ${category.id}}', 201));

      var newCategory =
          await Uploader<Category>(client: client).create(category);
      expect(newCategory.id, 1);
    });
  });
}
