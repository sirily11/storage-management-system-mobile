import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/mockito.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storage_management_mobile/DataObj/StorageItem.dart';
import 'package:storage_management_mobile/States/ItemProvider.dart';
import 'package:storage_management_mobile/States/LocationProvider.dart';
import 'package:storage_management_mobile/States/LoginProvider.dart';
import 'package:storage_management_mobile/pages/Home/Detail/ItemDetailPage.dart';
import 'package:storage_management_mobile/pages/Home/Detail/SubDetail/AuthorDetail.dart';
import 'package:storage_management_mobile/pages/Home/Detail/SubDetail/LocationDetail.dart';
import 'package:storage_management_mobile/pages/Home/Detail/SubDetail/PositionDetail.dart';
import 'package:storage_management_mobile/pages/Home/Detail/SubDetail/SeriesDetail.dart';
import 'package:location/location.dart' as d;
import 'package:storage_management_mobile/pages/Loading/LoadingScreen.dart';
import '../home/data/response.dart';

class MockDio extends Mock implements Dio {}

class MockLocation extends Mock implements d.Location {}

class MockImagePicker extends Mock implements ImagePicker {}

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
        expect(find.byKey(Key("Quantity Edit Panel")), findsNothing);
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
        expect(find.byKey(Key("Quantity Edit Panel")), findsOneWidget);
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
        expect(find.byKey(Key("Quantity Edit Panel")), findsOneWidget);
        await tester.tap(find.text("Position"));
        await tester.pumpAndSettle();
      },
    );
  });

  group("Position Test", () {
    Dio dio = MockDio();
    ImagePicker imagePicker = MockImagePicker();

    setUpAll(() {
      SharedPreferences.setMockInitialValues({"access": "some access"});
      when(dio.get(any)).thenAnswer(
        (realInvocation) async => Response(data: detailResponse),
      );

      when(imagePicker.getImage(source: anyNamed("source"))).thenAnswer(
        (realInvocation) async => PickedFile("test.jpg"),
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
        await tester.tap(find.text("OK"));
      },
    );

    testWidgets(
      "login and add image",
      (WidgetTester tester) async {
        final position = Position(id: 1, name: "Test", uuid: "abcde");
        ItemProvider itemProvider =
            ItemProvider(networkProvider: dio, imagePicker: imagePicker);
        LoginProvider loginProvider = LoginProvider(networkProvider: dio);
        loginProvider.hasLogined = true;
        itemProvider.isTest = true;
        itemProvider.item = StorageItemDetail(position: position);

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
              home: PositionDetail(position),
            ),
          ),
        );

        await tester.pumpAndSettle();
        await tester.tap(find.byKey(detailAddKey));
        await tester.pumpAndSettle();
        await tester.tap(find.text("From Photo Library"));
        await tester.pumpAndSettle();
      },
    );
  });

  group("Author test", () {
    testWidgets(
      "Author Detail",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: AuthorDetail(
                Author(name: "Test", description: "Test Author"),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text("Test"), findsWidgets);
        expect(find.text("Test Author"), findsOneWidget);
      },
    );
  });

  group("Test Series", () {
    testWidgets(
      "Series Detail",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: SeriesDetail(
                Series(name: "Test", description: "Test Series"),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text("Test"), findsWidgets);
        expect(find.text("Test Series"), findsOneWidget);
      },
    );
  });

  group("Location test", () {
    Dio mockDio = MockDio();
    d.Location mockLocation = MockLocation();

    setUpAll(() {
      when(mockDio.get(any)).thenAnswer(
        (realInvocation) async => Response(data: detailResponse),
      );
      when(mockDio.patch(any,
              data: anyNamed("data"), options: anyNamed("options")))
          .thenAnswer(
        (realInvocation) async => Response(statusCode: 201),
      );
      SharedPreferences.setMockInitialValues({"access": "some access"});
    });

    testWidgets(
      "Location Detail Not Login",
      (WidgetTester tester) async {
        LoginProvider loginProvider = LoginProvider(networkProvider: mockDio);
        ItemProvider itemProvider = ItemProvider(networkProvider: mockDio);
        LocationProvider locationProvider = LocationProvider();
        loginProvider.hasLogined = false;

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => itemProvider,
              ),
              ChangeNotifierProvider(
                create: (context) => loginProvider,
              ),
              ChangeNotifierProvider(
                create: (context) => locationProvider,
              )
            ],
            child: MaterialApp(
              home: Material(
                child: LocationDetail(
                  Location(
                    country: "US",
                    city: "New York",
                    street: "Hello world",
                    building: "Test",
                    unit: "A",
                    room_number: "100",
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text("US", skipOffstage: false), findsWidgets);
        expect(find.text("New York", skipOffstage: false), findsWidgets);
        expect(find.text("Hello world", skipOffstage: false), findsWidgets);
        expect(find.text("Test", skipOffstage: false), findsWidgets);
        expect(find.text("A", skipOffstage: false), findsWidgets);
        expect(find.text("100", skipOffstage: false), findsWidgets);
        expect(find.byIcon(Icons.location_on), findsNothing);
        expect(find.byKey(Key("Map")), findsNothing);
      },
    );

    testWidgets(
      "Location Detail Logined",
      (WidgetTester tester) async {
        LoginProvider loginProvider = LoginProvider(networkProvider: mockDio);
        ItemProvider itemProvider = ItemProvider(networkProvider: mockDio);
        LocationProvider locationProvider = LocationProvider();
        loginProvider.hasLogined = true;

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => itemProvider,
              ),
              ChangeNotifierProvider(
                create: (context) => loginProvider,
              ),
              ChangeNotifierProvider(
                create: (context) => locationProvider,
              )
            ],
            child: MaterialApp(
              home: Material(
                child: LocationDetail(
                  Location(
                    country: "US",
                    city: "New York",
                    street: "Hello world",
                    building: "Test",
                    unit: "A",
                    room_number: "100",
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text("US", skipOffstage: false), findsWidgets);
        expect(find.text("New York", skipOffstage: false), findsWidgets);
        expect(find.text("Hello world", skipOffstage: false), findsWidgets);
        expect(find.text("Test", skipOffstage: false), findsWidgets);
        expect(find.text("A", skipOffstage: false), findsWidgets);
        expect(find.text("100", skipOffstage: false), findsWidgets);
        expect(find.byIcon(Icons.location_on), findsOneWidget);
        expect(find.byKey(Key("Map")), findsNothing);
      },
    );

    testWidgets(
      "Location Detail had Location detail",
      (WidgetTester tester) async {
        LoginProvider loginProvider = LoginProvider(networkProvider: mockDio);
        ItemProvider itemProvider = ItemProvider(networkProvider: mockDio);
        LocationProvider locationProvider = LocationProvider();

        loginProvider.hasLogined = true;

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => itemProvider,
              ),
              ChangeNotifierProvider(
                create: (context) => loginProvider,
              ),
              ChangeNotifierProvider(
                create: (context) => locationProvider,
              )
            ],
            child: MaterialApp(
              home: Material(
                child: LocationDetail(
                  Location(
                    country: "US",
                    city: "New York",
                    street: "Hello world",
                    building: "Test",
                    unit: "A",
                    room_number: "100",
                    latitude: 100,
                    longitude: 20,
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text("US", skipOffstage: false), findsWidgets);
        expect(find.text("New York", skipOffstage: false), findsWidgets);
        expect(find.text("Hello world", skipOffstage: false), findsWidgets);
        expect(find.text("Test", skipOffstage: false), findsWidgets);
        expect(find.text("A", skipOffstage: false), findsWidgets);
        expect(find.text("100", skipOffstage: false), findsWidgets);
        expect(find.byIcon(Icons.location_on), findsOneWidget);
        expect(find.byKey(Key("Map")), findsOneWidget);
      },
    );

    testWidgets(
      "Location Detail add location",
      (WidgetTester tester) async {
        when(mockLocation.hasPermission())
            .thenAnswer((realInvocation) async => d.PermissionStatus.granted);
        when(mockLocation.getLocation()).thenAnswer(
          (realInvocation) async =>
              d.LocationData.fromMap({"latitude": 10, "longitude": 10}),
        );

        final location = Location(
          country: "US",
          city: "New York",
          street: "Hello world",
          building: "Test",
          unit: "A",
          room_number: "100",
        );

        LoginProvider loginProvider = LoginProvider(networkProvider: mockDio);
        ItemProvider itemProvider = ItemProvider(networkProvider: mockDio);
        LocationProvider locationProvider =
            LocationProvider(location: mockLocation);
        loginProvider.hasLogined = true;
        itemProvider.item = StorageItemDetail(location: location);

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => itemProvider,
              ),
              ChangeNotifierProvider(
                create: (context) => loginProvider,
              ),
              ChangeNotifierProvider(
                create: (context) => locationProvider,
              )
            ],
            child: MaterialApp(
              home: Material(
                child: LocationDetail(location),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.byIcon(Icons.location_on), findsOneWidget);
        expect(find.byKey(Key("Map")), findsNothing);
        await tester.tap(find.byIcon(Icons.location_on));
        await tester.pumpAndSettle();
        expect(find.byKey(Key("Update Location")), findsOneWidget);
        await tester.tap(find.text("OK"));
        await tester.pumpAndSettle(Duration(seconds: 2));
        expect(find.byKey(Key("Map")), findsOneWidget);
      },
    );

    testWidgets(
      "Location Detail add location with error",
      (WidgetTester tester) async {
        when(mockLocation.hasPermission())
            .thenAnswer((realInvocation) async => d.PermissionStatus.granted);
        when(mockLocation.getLocation()).thenAnswer(
          (realInvocation) async => null,
        );

        final location = Location(
          country: "US",
          city: "New York",
          street: "Hello world",
          building: "Test",
          unit: "A",
          room_number: "100",
        );

        LoginProvider loginProvider = LoginProvider(networkProvider: mockDio);
        ItemProvider itemProvider = ItemProvider(networkProvider: mockDio);
        LocationProvider locationProvider =
            LocationProvider(location: mockLocation);
        loginProvider.hasLogined = true;
        itemProvider.item = StorageItemDetail(location: location);

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => itemProvider,
              ),
              ChangeNotifierProvider(
                create: (context) => loginProvider,
              ),
              ChangeNotifierProvider(
                create: (context) => locationProvider,
              )
            ],
            child: MaterialApp(
              home: Material(
                child: LocationDetail(location),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.byIcon(Icons.location_on), findsOneWidget);
        expect(find.byKey(Key("Map")), findsNothing);
        await tester.tap(find.byIcon(Icons.location_on));
        await tester.pumpAndSettle();
        expect(find.byKey(Key("Error")), findsOneWidget);
        await tester.tap(find.text("OK"));
        await tester.pumpAndSettle(Duration(seconds: 2));
        expect(find.byKey(Key("Map")), findsNothing);
      },
    );

    testWidgets(
      "Location Detail add location and cancel",
      (WidgetTester tester) async {
        when(mockLocation.hasPermission())
            .thenAnswer((realInvocation) async => d.PermissionStatus.granted);
        when(mockLocation.getLocation()).thenAnswer(
          (realInvocation) async =>
              d.LocationData.fromMap({"latitude": 10, "longitude": 10}),
        );

        final location = Location(
          country: "US",
          city: "New York",
          street: "Hello world",
          building: "Test",
          unit: "A",
          room_number: "100",
          latitude: 100,
          longitude: -20,
        );

        LoginProvider loginProvider = LoginProvider(networkProvider: mockDio);
        ItemProvider itemProvider = ItemProvider(networkProvider: mockDio);
        LocationProvider locationProvider =
            LocationProvider(location: mockLocation);
        loginProvider.hasLogined = true;
        itemProvider.item = StorageItemDetail(location: location);

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => itemProvider,
              ),
              ChangeNotifierProvider(
                create: (context) => loginProvider,
              ),
              ChangeNotifierProvider(
                create: (context) => locationProvider,
              )
            ],
            child: MaterialApp(
              home: Material(
                child: LocationDetail(location),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.byIcon(Icons.location_on), findsOneWidget);
        expect(find.byKey(Key("Map")), findsOneWidget);
        await tester.tap(find.byIcon(Icons.location_on));
        await tester.pumpAndSettle();
        expect(find.byKey(Key("Update Location")), findsOneWidget);
        await tester.tap(find.text("Cancel"));
        await tester.pumpAndSettle(Duration(seconds: 2));
        expect(find.byKey(Key("Map")), findsOneWidget);
      },
    );
  });
}
