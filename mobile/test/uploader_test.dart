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
    test("Get correct category url", () async {
      Category category = Category(id: 1, name: "Food");
      var url = await Uploader<Category>().getAPIURL();
      expect(url, await getURL("category/"));
    });

    test("Get correct Location url", () async {
      Location object = Location(id: 1);
      var url = await Uploader<Location>().getAPIURL();
      expect(url, await getURL("location/"));
    });

    test("Get correct Author url", () async {
      Author object = Author(id: 1);
      var url = await Uploader<Author>().getAPIURL();
      expect(url, await getURL("author/"));
    });

    test("Get correct Series url", () async {
      Series object = Series(id: 1);
      var url = await Uploader<Series>().getAPIURL();
      expect(url, await getURL("series/"));
    });

    test("Get correct Position url", () async {
      Position object = Position(id: 1);
      var url = await Uploader<Position>().getAPIURL();
      expect(url, await getURL("detail-position/"));
    });
  });

  // group("create test", () {
  //   test("create categorty", () async {
  //     Category category = Category(id: 1, name: "Food");
  //     final client = MockClient();
  //     when(client.post(getURL("category/"),
  //             body: json.encode(category),
  //             headers: {HttpHeaders.contentTypeHeader: "application/json"}))
  //         .thenAnswer((_) async =>
  //             http.Response('{"id" : ${category.id}, "name": "Food"}', 201));

  //     var newCategory =
  //         await Uploader<Category>(client: client).create(category);
  //     expect(newCategory.id, 1);
  //     expect(newCategory.name, "Food");
  //   });

  //   test("create author", () async {
  //     Author author = Author(id: 3, name: "Harry");
  //     final client = MockClient();
  //     when(client.post(getURL("author/"),
  //             body: json.encode(author),
  //             headers: {HttpHeaders.contentTypeHeader: "application/json"}))
  //         .thenAnswer((_) async => http.Response(
  //             '{"id" : ${author.id}, "name": "${author.name}"}', 201));

  //     var newauthor = await Uploader<Author>(client: client).create(author);
  //     expect(newauthor.id, author.id);
  //     expect(newauthor.name, author.name);
  //   });
  // });
}
