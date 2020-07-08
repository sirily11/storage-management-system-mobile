import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storage_management_mobile/DataObj/StorageItem.dart';
import 'package:storage_management_mobile/pages/Home/ItemDisplay.dart';

void main() {
  group("items tests", () {
    testWidgets(
      "Test 1",
      (WidgetTester tester) async {
        final List<StorageItemAbstract> items = [
          StorageItemAbstract(
            name: "Test 1",
          )
        ];
        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: ItemDisplay(
                items: items,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text("Test 1"), findsOneWidget);
      },
    );

    testWidgets(
      "Test 2",
      (WidgetTester tester) async {
        final List<StorageItemAbstract> items = [
          StorageItemAbstract(
            name: "Test 1",
          ),
          StorageItemAbstract(
            name: "Test 2",
          ),
          StorageItemAbstract(
            name: "Test 3",
          )
        ];
        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: ItemDisplay(
                items: items,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text("Test 1"), findsOneWidget);
        expect(find.text("Test 2"), findsOneWidget);
        expect(find.text("Test 3"), findsOneWidget);
      },
    );
  });
}
