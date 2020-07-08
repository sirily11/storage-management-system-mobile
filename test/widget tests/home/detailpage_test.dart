import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:storage_management_mobile/DataObj/StorageItem.dart';
import 'package:storage_management_mobile/States/ItemProvider.dart';
import 'package:storage_management_mobile/States/LoginProvider.dart';
import 'package:storage_management_mobile/pages/Home/Detail/ItemDetailPage.dart';
import 'package:storage_management_mobile/pages/Home/Detail/SubDetail/PositionDetail.dart';

import 'data/response.dart';

class MockDio extends Mock implements Dio {}

void main() {
  final detailAddKey = Key("Add detail image");
  final imageAddKey = Key("Add Image");
  final editKey = Key("Edit");
  final positionPrintKey = Key("Print position");
  final qrKey = Key("Qrimage");
  final TestWidgetsFlutterBinding binding =
      TestWidgetsFlutterBinding.ensureInitialized();
  group("Detial page test", () {
    Dio dio = MockDio();

    setUpAll(() {
      when(dio.get(any)).thenAnswer(
        (realInvocation) async => Response(data: detailResponse),
      );
    });

    testWidgets(
      "Not login",
      (WidgetTester tester) async {
        ItemProvider itemProvider = ItemProvider(networkProvider: dio);
        LoginProvider loginProvider = LoginProvider(networkProvider: dio);
        loginProvider.hasLogined = false;

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => itemProvider,
              ),
              ChangeNotifierProvider(
                create: (context) => loginProvider,
              )
            ],
            child: MaterialApp(
              home: ItemDetailPage(
                id: 1,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text("pc"), findsWidgets);
        expect(find.byKey(editKey), findsNothing);
        expect(find.byKey(imageAddKey), findsNothing);
        expect(find.text("500.0 USD"), findsOneWidget);
        expect(find.text("1"), findsWidgets);
        expect(find.text("Position"), findsOneWidget);
        await tester.tap(find.text("Position"));
        await tester.pumpAndSettle();
        expect(find.text("Position"), findsOneWidget);
        expect(find.byKey(detailAddKey), findsNothing);
      },
    );

    testWidgets(
      "login",
      (WidgetTester tester) async {
        ItemProvider itemProvider = ItemProvider(networkProvider: dio);
        LoginProvider loginProvider = LoginProvider(networkProvider: dio);
        loginProvider.hasLogined = true;

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => itemProvider,
              ),
              ChangeNotifierProvider(
                create: (context) => loginProvider,
              )
            ],
            child: MaterialApp(
              home: ItemDetailPage(
                id: 1,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text("pc"), findsWidgets);
        expect(find.byKey(imageAddKey), findsOneWidget);
        expect(find.byKey(editKey), findsOneWidget);
        expect(find.text("500.0 USD"), findsOneWidget);
        expect(find.text("1"), findsWidgets);
        expect(find.text("Position"), findsOneWidget);
        await tester.tap(find.text("Position"));
        await tester.pumpAndSettle();
        expect(find.text("Position"), findsOneWidget);
        expect(find.byKey(detailAddKey), findsOneWidget);
      },
    );

    testWidgets(
      "Not login small size",
      (WidgetTester tester) async {
        binding.window.physicalSizeTestValue = Size(400, 1000);
        binding.window.devicePixelRatioTestValue = 1.0;

        ItemProvider itemProvider = ItemProvider(networkProvider: dio);
        LoginProvider loginProvider = LoginProvider(networkProvider: dio);
        loginProvider.hasLogined = false;

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => itemProvider,
              ),
              ChangeNotifierProvider(
                create: (context) => loginProvider,
              )
            ],
            child: MaterialApp(
              home: ItemDetailPage(
                id: 1,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text("pc"), findsWidgets);
        expect(find.byKey(editKey), findsNothing);
        expect(find.byKey(imageAddKey), findsNothing);
        expect(find.text("500.0 USD"), findsOneWidget);
        expect(find.text("1"), findsWidgets);
        expect(find.text("Position"), findsOneWidget);
        await tester.tap(find.text("Position"));
        await tester.pumpAndSettle();
        expect(find.text("Position"), findsOneWidget);
        expect(find.byKey(detailAddKey), findsNothing);
      },
    );

    testWidgets(
      "login small size",
      (WidgetTester tester) async {
        binding.window.physicalSizeTestValue = Size(400, 1000);
        binding.window.devicePixelRatioTestValue = 1.0;

        ItemProvider itemProvider = ItemProvider(networkProvider: dio);
        LoginProvider loginProvider = LoginProvider(networkProvider: dio);
        loginProvider.hasLogined = true;

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => itemProvider,
              ),
              ChangeNotifierProvider(
                create: (context) => loginProvider,
              )
            ],
            child: MaterialApp(
              home: ItemDetailPage(
                id: 1,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(loginProvider.hasLogined, true);
        expect(find.text("pc"), findsWidgets);
        expect(find.byKey(imageAddKey), findsOneWidget);
        expect(find.byKey(editKey), findsOneWidget);
        expect(find.text("500.0 USD"), findsOneWidget);
        expect(find.text("1"), findsWidgets);
        expect(find.text("Position"), findsOneWidget);
        await tester.tap(find.text("Position"));
        await tester.pumpAndSettle();
      },
    );
  });

  group("Position Test", () {
    Dio dio = MockDio();

    setUpAll(() {
      when(dio.get(any)).thenAnswer(
        (realInvocation) async => Response(data: detailResponse),
      );
    });

    testWidgets(
      "Not login",
      (WidgetTester tester) async {
        ItemProvider itemProvider = ItemProvider(networkProvider: dio);
        LoginProvider loginProvider = LoginProvider(networkProvider: dio);
        loginProvider.hasLogined = false;

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => itemProvider,
              ),
              ChangeNotifierProvider(
                create: (context) => loginProvider,
              )
            ],
            child: MaterialApp(
              home: PositionDetail(
                Position(id: 1, name: "Test", uuid: "abcde"),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text("Position"), findsOneWidget);
        expect(find.byKey(detailAddKey), findsNothing);
        await tester.tap(find.byKey(positionPrintKey));
        await tester.pumpAndSettle();
        expect(find.byKey(qrKey), findsOneWidget);
      },
    );

    testWidgets(
      "login",
      (WidgetTester tester) async {
        ItemProvider itemProvider = ItemProvider(networkProvider: dio);
        LoginProvider loginProvider = LoginProvider(networkProvider: dio);
        loginProvider.hasLogined = true;

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => itemProvider,
              ),
              ChangeNotifierProvider(
                create: (context) => loginProvider,
              )
            ],
            child: MaterialApp(
              home: PositionDetail(
                Position(id: 1, name: "Test", uuid: "abcde"),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text("Position"), findsOneWidget);
        expect(find.byKey(detailAddKey), findsOneWidget);
        await tester.tap(find.byKey(positionPrintKey));
        await tester.pumpAndSettle();
        expect(find.byKey(qrKey), findsOneWidget);
      },
    );
  });
}
