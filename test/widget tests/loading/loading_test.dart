import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storage_management_mobile/States/HomeProvider.dart';
import 'package:storage_management_mobile/States/ItemProvider.dart';
import 'package:storage_management_mobile/States/LoginProvider.dart';
import 'package:storage_management_mobile/States/urls.dart';
import 'package:storage_management_mobile/pages/Loading/LoadingScreen.dart';

import '../home/homepage_test.dart';

void main() {
  group("Load Screen", () {
    Dio dio = MockDio();
    final loadingFinder = find.byKey(Key("Loading progress"));
    final homeFinder = find.byKey(Key("Homepage"));

    setUpAll(() {
      when(dio.post(any, data: anyNamed("data"))).thenAnswer(
        (realInvocation) async => Response(
          data: {"access": "abc"},
        ),
      );
    });

    testWidgets(
      "Test not login",
      (WidgetTester tester) async {
        // SharedPreferences.setMockInitialValues(
        //   {"username": "abc", "password": "abc", serverPath: "abce"},
        // );
        SharedPreferences.setMockInitialValues({});
        HomeProvider homeProvider = HomeProvider(networkProvider: dio);
        ItemProvider itemProvider = ItemProvider(networkProvider: dio);
        LoginProvider loginProvider = LoginProvider(networkProvider: dio);

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => homeProvider,
              ),
              ChangeNotifierProvider(
                create: (context) => itemProvider,
              ),
              ChangeNotifierProvider(
                create: (context) => loginProvider,
              ),
            ],
            child: MaterialApp(
              home: LoadingScreen(),
            ),
          ),
        );
        expect(homeFinder, findsNothing);
        expect(loadingFinder, findsOneWidget);
        await tester.pumpAndSettle(Duration(seconds: 3));
        expect(homeFinder, findsOneWidget);
      },
    );

    testWidgets(
      "Test logined",
      (WidgetTester tester) async {
        SharedPreferences.setMockInitialValues(
          {"username": "abc", "password": "abc"},
        );
        SharedPreferences.setMockInitialValues({});
        HomeProvider homeProvider = HomeProvider(networkProvider: dio);
        ItemProvider itemProvider = ItemProvider(networkProvider: dio);
        LoginProvider loginProvider = LoginProvider(networkProvider: dio);

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => homeProvider,
              ),
              ChangeNotifierProvider(
                create: (context) => itemProvider,
              ),
              ChangeNotifierProvider(
                create: (context) => loginProvider,
              ),
            ],
            child: MaterialApp(
              home: LoadingScreen(),
            ),
          ),
        );
        expect(homeFinder, findsNothing);
        expect(loadingFinder, findsOneWidget);
        await tester.pumpAndSettle(Duration(seconds: 3));
        expect(homeFinder, findsOneWidget);
      },
    );
  });
}
