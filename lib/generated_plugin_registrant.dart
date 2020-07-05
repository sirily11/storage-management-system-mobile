//
// Generated file. Do not edit.
//

// ignore: unused_import
import 'dart:ui';

import 'package:firebase_core_web/firebase_core_web.dart';
import 'package:location_web/location_web.dart';
import 'package:printing/printing_web.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

// ignore: public_member_api_docs
void registerPlugins(PluginRegistry registry) {
  FirebaseCoreWeb.registerWith(registry.registrarFor(FirebaseCoreWeb));
  LocationWebPlugin.registerWith(registry.registrarFor(LocationWebPlugin));
  PrintingPlugin.registerWith(registry.registrarFor(PrintingPlugin));
  SharedPreferencesPlugin.registerWith(registry.registrarFor(SharedPreferencesPlugin));
  registry.registerMessageHandler();
}
