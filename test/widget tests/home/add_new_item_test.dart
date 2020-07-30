import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storage_management_mobile/States/HomeProvider.dart';
import 'package:storage_management_mobile/States/LoginProvider.dart';
import 'package:storage_management_mobile/States/urls.dart';
import 'package:storage_management_mobile/pages/Edit/NewEditPage.dart';
import 'package:storage_management_mobile/pages/Home/Homepage.dart';

import 'data/response.dart';
import 'homepage_test.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  group("Add/edit item", () {
    Dio dio = MockDio();
    final itemName = find.byKey(Key("textfield-name"));
    final description = find.byKey(Key("textfield-description"));
    final submitBtn = find.text("Submit");

    setUpAll(() {
      SharedPreferences.setMockInitialValues({"access": "some access"});
      when(
        dio.request(any, options: anyNamed("options")),
      ).thenAnswer(
        (realInvocation) async => Response(data: schemaResponse),
      );

      when(dio.post(any, data: anyNamed("data"), options: anyNamed("options")))
          .thenAnswer(
        (realInvocation) async => Response(statusCode: 201),
      );

      when(dio.patch(any, data: anyNamed("data"), options: anyNamed("options")))
          .thenAnswer(
        (realInvocation) async => Response(statusCode: 201),
      );
    });

    test("init dio", () async {
      var response =
          await dio.request("$itemURL", options: Options(method: "OPTIONS"));
      var response2 =
          await dio.post("$itemURL", data: {}, options: Options(headers: {}));

      expect(response.data, schemaResponse);
      expect(response2.statusCode, 201);
    });

    testWidgets(
      "test add",
      (WidgetTester tester) async {
        //TODO: Added scroll
        HomeProvider homeProvider = HomeProvider(networkProvider: dio);
        final mockObserver = MockNavigatorObserver();

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => homeProvider,
              )
            ],
            child: MaterialApp(
              navigatorObservers: [mockObserver],
              home: NewEditPage(),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(itemName, findsOneWidget);
        expect(description, findsOneWidget);
        expect(submitBtn, findsOneWidget);

        await tester.enterText(itemName, "Test");
        await tester.enterText(description, "Test test");
        await tester.tap(submitBtn);
        await tester.pumpAndSettle();
        verify(mockObserver.didPop(any, any));
        verify(dio.post(any,
                data: anyNamed("data"), options: anyNamed("options")))
            .called(greaterThan(0));
      },
    );

    testWidgets(
      "edit widget",
      (WidgetTester tester) async {
        //TODO: Added scroll
        HomeProvider homeProvider = HomeProvider(networkProvider: dio);
        final mockObserver = MockNavigatorObserver();

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => homeProvider,
              )
            ],
            child: MaterialApp(
              navigatorObservers: [mockObserver],
              home: NewEditPage(
                id: 1,
                values: {"name": "hello", "description": "world"},
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text("hello"), findsOneWidget);
        expect(find.text("world"), findsOneWidget);
        await tester.drag(find.text("hello"), Offset(0, 500));
        await tester.pumpAndSettle();
        expect(submitBtn, findsOneWidget);
        await tester.tap(submitBtn);
        await tester.pumpAndSettle();
        // verify(mockObserver.didPop(any, any));
        // verify(dio.patch(any,
        //         data: anyNamed("data"), options: anyNamed("options")))
        //     .called(greaterThan(0));
      },
    );
  });
}
