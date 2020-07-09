import 'dart:convert';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:mock_web_server/mock_web_server.dart';
import 'package:test/test.dart';


void main() {
  group("Storage app", () {
    FlutterDriver driver;
    MockWebServer server;
    String serverAddress;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
      server = new MockWebServer();

      // await server.start();
      // serverAddress = server.url;
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test("Open Drawer", () async {
      // server.enqueue(body: JsonEncoder().convert(settingsResponse));
      // server.enqueue(body: JsonEncoder().convert(itemsResponse));

      await driver.tap(find.byTooltip("Open navigation menu"));
      await Future.delayed(Duration(seconds: 1));
      await driver.tap(find.byValueKey("Settings"));
      await Future.delayed(Duration(seconds: 1));
      await driver.tap(find.byValueKey("URL Field"));

      await driver.enterText(
        "http://test.com",
      );

      await driver.tap(find.text("Save"));
      await driver.tap(find.text("Save"));

      await driver.tap(find.byTooltip("Open navigation menu"));
      await driver.tap(find.text("Home"));
      
    });
  });
}
