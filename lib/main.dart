import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wo_form_example/app.dart';

Future<void> main() async {
  await dotenv.load(fileName: 'assets/dotenv');

  runApp(const WoFormExamplesApp());
}
