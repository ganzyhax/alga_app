import 'package:alga_app/app/app.dart';
import 'package:alga_app/app/services/location_service.dart';
import 'package:alga_app/app/utils/locator.dart';
import 'package:dgis_mobile_sdk_full/dgis.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(const AlgaApp());
}
