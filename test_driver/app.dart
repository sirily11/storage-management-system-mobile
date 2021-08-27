// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_driver/driver_extension.dart';
// import 'package:mockito/mockito.dart';
// import 'package:provider/provider.dart';
// import 'package:storage_management_mobile/States/HomeProvider.dart';
// import 'package:storage_management_mobile/States/ItemProvider.dart';
// import 'package:storage_management_mobile/States/LoginProvider.dart';
// import 'package:storage_management_mobile/States/urls.dart';
// import 'package:storage_management_mobile/pages/Loading/LoadingScreen.dart';
// import '../test/widget tests/home/data/response.dart';

// class MockDio extends Mock implements Dio {}

// void main() {
//   // This line enables the extension.
//   enableFlutterDriverExtension();

//   Dio dio = MockDio();

//   when(dio.get("http://test.com$settingsURL"))
//       .thenAnswer((realInvocation) async => Response(data: settingsResponse));

//   when(dio.get("http://test.com$itemURL"))
//       .thenAnswer((realInvocation) async => Response(data: homeResponse));

//   // Call the `main()` function of the app, or call `runApp` with
//   // any widget you are interested in testing.
//   runApp(MultiProvider(
//     providers: [
//       ChangeNotifierProvider(
//         create: (_) => ItemProvider(networkProvider: dio),
//       ),
//       ChangeNotifierProvider(
//         create: (_) => HomeProvider(networkProvider: dio),
//       ),
//       ChangeNotifierProvider(
//         create: (_) => LoginProvider(networkProvider: dio),
//       )
//     ],
//     child: MaterialApp(
//       home: LoadingScreen(),
//     ),
//   ));
// }
