import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:storage_management_mobile/DataObj/StorageItem.dart';
import 'package:storage_management_mobile/States/HomeProvider.dart';
import 'package:storage_management_mobile/States/LoginProvider.dart';
import 'package:storage_management_mobile/pages/Home/Homepage.dart';

import 'data/response.dart';

class MockDio extends Mock implements Dio {}

void main() {
  group("Home page test", () {
    Dio dio = MockDio();

    setUpAll(() {
      when(dio.post(any)).thenAnswer(
        (realInvocation) async => Response(
          data: {"access": "somekey"},
        ),
      );

      when(dio.get(any)).thenAnswer(
        (realInvocation) async => Response(data: homeResponse),
      );
    });

    testWidgets(
      "Not login",
      (WidgetTester tester) async {
        HomeProvider homeProvider = HomeProvider(networkProvider: dio);
        LoginProvider loginProvider = LoginProvider(networkProvider: dio);
        loginProvider.hasLogined = false;

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => homeProvider,
              ),
              ChangeNotifierProvider(
                create: (context) => loginProvider,
              )
            ],
            child: MaterialApp(
              home: Homepage(),
            ),
          ),
        );
        await tester.pumpAndSettle(
          Duration(seconds: 2),
        );
        expect(find.byKey(Key("Add Item")), findsNothing);
        expect(find.text("Computer"), findsOneWidget);
        await tester.tap(find.byKey(Key("Select Category")));
        await tester.pumpAndSettle();
        expect(find.text("Categories"), findsOneWidget);
      },
    );

    testWidgets(
      "Not login",
      (WidgetTester tester) async {
        HomeProvider homeProvider = HomeProvider(networkProvider: dio);
        LoginProvider loginProvider = LoginProvider(networkProvider: dio);
        loginProvider.hasLogined = true;

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => homeProvider,
              ),
              ChangeNotifierProvider(
                create: (context) => loginProvider,
              )
            ],
            child: MaterialApp(
              home: Homepage(),
            ),
          ),
        );
        await tester.pumpAndSettle(
          Duration(seconds: 2),
        );
        expect(find.byKey(Key("Add Item")), findsOneWidget);
        expect(find.text("Computer"), findsOneWidget);
        await tester.tap(find.byKey(Key("Select Category")));
        await tester.pumpAndSettle();
        expect(find.text("Categories"), findsOneWidget);
      },
    );
  });
}
