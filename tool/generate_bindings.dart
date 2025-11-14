import 'dart:io';

import 'package:ffigen/ffigen.dart';
import 'package:logging/logging.dart';

void main(List<String> args) {
  runGenerator('constants', stripEmptyLines: true);
  runGenerator('functions', stripEmptyLines: false);
}

final constantPattern = RegExp('GLFW_([A-Z0-9_]*)');

void runGenerator(String config, {required bool stripEmptyLines}) {
  final generator = YamlConfig.fromFile(File('tool/ffigen_$config.yaml'), Logger('ffigen')).configAdapter();
  generator.generate();

  final outFile = File.fromUri(generator.output.dartFile);

  var processed = outFile.readAsLinesSync().map(
    (line) => line.replaceAllMapped(constantPattern, (match) => 'glfw${screamingSnakeToPascal(match[1]!)}'),
  );

  if (stripEmptyLines) {
    processed = processed.where((element) => element.isNotEmpty);
  }

  outFile.writeAsStringSync(processed.join('\n'));
  Process.runSync('dart', ['format', outFile.path, '--page-width', '120']);
}

final underscorePattern = RegExp('_(.)');
String screamingSnakeToPascal(String input) {
  final camel = input.toLowerCase().replaceAllMapped(underscorePattern, (match) => match[1]!.toUpperCase());
  return camel[0].toUpperCase() + camel.substring(1);
}

String pascalToCamel(String input) {
  return input[0].toLowerCase() + input.substring(1);
}
