import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:storage_management_mobile/DataObj/Setting.dart';
import 'package:storage_management_mobile/DataObj/StorageItem.dart';
import 'package:storage_management_mobile/States/HomeProvider.dart';
import 'package:storage_management_mobile/pages/Home/components/CategorySelector.dart';

void main() {
  group("category selector tests", () {
    testWidgets(
      "Test 1",
      (WidgetTester tester) async {
        final SettingObj settingObj = SettingObj(locations: [
          Location(name: "Test Location1"),
          Location(name: "Test Location2"),
        ], categories: [
          Category(name: "Test Category1"),
          Category(name: "Test Category2")
        ], positions: [
          Position(name: "Test Position1"),
          Position(name: "Test Position2"),
        ]);

        HomeProvider homeProvider = HomeProvider();
        homeProvider.settingObj = settingObj;

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => homeProvider,
              ),
            ],
            child: MaterialApp(
              home: Material(
                child: CategorySelector(),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text("Categories"), findsOneWidget);
        expect(find.text("Locations"), findsOneWidget);
        expect(find.text("Positions"), findsOneWidget);

        expect(find.text("Test Category1"), findsOneWidget);
        expect(find.text("Test Category2"), findsOneWidget);

        await tester.tap(find.text("Locations"));
        await tester.pumpAndSettle();
        expect(find.text("Test Location1"), findsOneWidget);
        expect(find.text("Test Location2"), findsOneWidget);

        await tester.tap(find.text("Positions"));
        await tester.pumpAndSettle();
        expect(find.text("Test Position1"), findsOneWidget);
        expect(find.text("Test Position2"), findsOneWidget);
      },
    );
  });
}
