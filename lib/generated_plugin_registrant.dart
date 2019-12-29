//
// Generated file. Do not edit.
//
import 'dart:ui';

import 'package:firebase_core_web/firebase_core_web.dart';
import 'package:printing/printing_web.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void registerPlugins(PluginRegistry registry) {
  FirebaseCoreWeb.registerWith(registry.registrarFor(FirebaseCoreWeb));
  PrintingPlugin.registerWith(registry.registrarFor(PrintingPlugin));
  SharedPreferencesPlugin.registerWith(registry.registrarFor(SharedPreferencesPlugin));
  registry.registerMessageHandler();
}
