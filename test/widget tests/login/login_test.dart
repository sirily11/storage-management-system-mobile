import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storage_management_mobile/States/LoginProvider.dart';
import 'package:storage_management_mobile/pages/login/LoginPage.dart';

import '../home/homepage_test.dart';

void main() {
  group("Test login", () {
    Dio dio = MockDio();
    final usernameFinder = find.byKey(Key('textfield-username'));
    final passwordFinder = find.byKey(Key('textfield-password'));
    final submitFinder = find.text("Submit");
    final signoutBtnFinder = find.byKey(Key("Signout"));
    final errorDialogFinder = find.byKey(Key("Error"));

    setUpAll(() {
      SharedPreferences.setMockInitialValues({"access": ""});
    });

    test("Test Login", () async {
      when(dio.post(any, data: anyNamed("data"))).thenAnswer(
        (realInvocation) async => Response(
          statusCode: 200,
          data: {"access": "abcd"},
        ),
      );
      LoginProvider loginProvider = LoginProvider(networkProvider: dio);
      await loginProvider.signIn("test", "1234");
      expect(loginProvider.hasLogined, true);
    });

    test("Test Login Failed", () async {
      when(dio.post(any, data: anyNamed("data"))).thenThrow(DioError);
      LoginProvider loginProvider = LoginProvider(networkProvider: dio);
      try {
        await loginProvider.signIn("test", "1234");
      } catch (err) {}
      expect(loginProvider.hasLogined, false);
    });

    testWidgets(
      "Test Login UI",
      (WidgetTester tester) async {
        when(dio.post(any, data: anyNamed("data"))).thenAnswer(
          (realInvocation) async => Response(
            statusCode: 200,
            data: {"access": "abcd"},
          ),
        );
        LoginProvider loginProvider = LoginProvider(networkProvider: dio);

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => loginProvider,
              ),
            ],
            child: MaterialApp(
              home: LoginPage(),
            ),
          ),
        );

        await tester.enterText(usernameFinder, "test");
        await tester.enterText(passwordFinder, "test");
        await tester.tap(submitFinder);
        await tester.pumpAndSettle();
        expect(submitFinder, findsNothing);
        expect(signoutBtnFinder, findsOneWidget);
        await tester.tap(signoutBtnFinder);
        await tester.pumpAndSettle();
        expect(submitFinder, findsOneWidget);
        expect(signoutBtnFinder, findsNothing);
      },
    );

    testWidgets(
      "Test Login UI 2",
      (WidgetTester tester) async {
        when(dio.post(any, data: anyNamed("data"))).thenAnswer(
          (realInvocation) async => Response(
            statusCode: 200,
            data: {"access": "abcd"},
          ),
        );
        LoginProvider loginProvider = LoginProvider(networkProvider: dio);
        loginProvider.hasLogined = true;

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => loginProvider,
              ),
            ],
            child: MaterialApp(
              home: LoginPage(),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(submitFinder, findsNothing);
        expect(signoutBtnFinder, findsOneWidget);
        await tester.tap(signoutBtnFinder);
        await tester.pumpAndSettle();
        expect(submitFinder, findsOneWidget);
        expect(signoutBtnFinder, findsNothing);
      },
    );

    testWidgets(
      "Test Login UI with error",
      (WidgetTester tester) async {
        when(dio.post(any, data: anyNamed("data")))
            .thenThrow(DioError(error: "Password is wrong"));
        LoginProvider loginProvider = LoginProvider(networkProvider: dio);

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => loginProvider,
              ),
            ],
            child: MaterialApp(
              home: LoginPage(),
            ),
          ),
        );

        await tester.enterText(usernameFinder, "test");
        await tester.enterText(passwordFinder, "test");
        await tester.tap(submitFinder);
        await tester.pumpAndSettle();
        expect(errorDialogFinder, findsOneWidget);
        await tester.tap(find.text("OK"));
        await tester.pumpAndSettle();
        expect(submitFinder, findsOneWidget);
      },
    );
  });
}
