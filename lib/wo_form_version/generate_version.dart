// version_gen.dart
import 'dart:io';
import 'package:yaml/yaml.dart';

void main() {
  final pubspecLock = File('pubspec.lock').readAsStringSync();
  final doc = loadYaml(pubspecLock);
  // ignore: avoid_dynamic_calls
  final firebaseVersion = doc['packages']['wo_form']['version'];
  final output = '''
const woFormVersion = 'v$firebaseVersion';
''';
  File('lib/wo_form_version/generated_version.dart').writeAsStringSync(output);
}
