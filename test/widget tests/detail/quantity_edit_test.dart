import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storage_management_mobile/DataObj/StorageItem.dart';
import 'package:storage_management_mobile/States/ItemProvider.dart';
import 'package:storage_management_mobile/pages/Home/Detail/components/quantityEditPannel.dart';

import '../home/homepage_test.dart';

void main() {
  group("Quantity Edit Test", () {
    Dio dio = MockDio();

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({"access": "some access"});
    });

    testWidgets(
      "Update quantity",
      (WidgetTester tester) async {
        when(
          dio.patch(
            any,
            data: anyNamed("data"),
            options: anyNamed("options"),
          ),
        ).thenAnswer(
          (realInvocation) async => Response(statusCode: 201),
        );
        ItemProvider provider = ItemProvider(networkProvider: dio);
        provider.item = StorageItemDetail(quantity: 1);

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => provider,
              )
            ],
            child: MaterialApp(
              home: Material(
                child: QuantityEdit(),
              ),
            ),
          ),
        );
        final setBtnFinder = find.byKey(Key("Set value"));
        await tester.pumpAndSettle();
        expect(find.text("1"), findsOneWidget);
        expect(tester.getSize(setBtnFinder).height, equals(0));
        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();
        expect(tester.getSize(setBtnFinder).height, greaterThan(0));
        expect(find.text("2"), findsOneWidget);
        await tester.tap(setBtnFinder);
        await tester.pumpAndSettle();
        expect(tester.getSize(setBtnFinder).height, equals(0));
        verify(
          dio.patch(
            any,
            data: anyNamed("data"),
            options: anyNamed("options"),
          ),
        ).called(greaterThan(0));
      },
    );

    testWidgets(
      "Update quantity with error",
      (WidgetTester tester) async {
        when(
          dio.patch(
            any,
            data: anyNamed("data"),
            options: anyNamed("options"),
          ),
        ).thenThrow(DioError);
        ItemProvider provider = ItemProvider(networkProvider: dio);
        provider.item = StorageItemDetail(quantity: 1);

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => provider,
              )
            ],
            child: MaterialApp(
              home: Material(
                child: QuantityEdit(),
              ),
            ),
          ),
        );
        final setBtnFinder = find.byKey(Key("Set value"));
        await tester.pumpAndSettle();
        expect(find.text("1"), findsOneWidget);
        expect(tester.getSize(setBtnFinder).height, equals(0));
        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();
        expect(tester.getSize(setBtnFinder).height, greaterThan(0));
        expect(find.text("2"), findsOneWidget);
        await tester.tap(setBtnFinder);
        await tester.pumpAndSettle();
        expect(find.text("Update Quantity Error"), findsOneWidget);
      },
    );
  });
}
