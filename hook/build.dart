import 'dart:io';

import 'package:code_assets/code_assets.dart';
import 'package:hooks/hooks.dart';

const glfwVersion = '3.4';

const supportedOperatingSystems = {OS.windows, OS.linux};
const supportedArchitectures = {Architecture.x64};

String dylibFilename(OS os, Architecture arch) => os.dylibFileName('glfw_${os.name}_${arch.name}');

Uri uriForArtifact(OS os, Architecture arch) => Uri.parse(
  'https://github.com/gliscowo/dart_glfw/releases/download/natives-$glfwVersion/${dylibFilename(os, arch)}',
);

Future<void> main(List<String> args) async {
  await build(args, (input, output) async {
    final os = input.config.code.targetOS;
    final arch = input.config.code.targetArchitecture;

    if (!supportedOperatingSystems.contains(os)) {
      throw Exception('${input.packageName} does not support ${os.name}');
    }

    if (!supportedArchitectures.contains(arch)) {
      throw Exception('${input.packageName} does not support ${arch.name}');
    }

    final uri = uriForArtifact(os, arch);
    final libFile = File.fromUri(input.outputDirectory.resolve(dylibFilename(os, arch)));

    final response = await HttpClient().getUrl(uri).then((value) => value.close());
    await response.pipe(libFile.openWrite());

    output.assets.code.add(
      CodeAsset(package: input.packageName, name: 'glfw', linkMode: DynamicLoadingBundled(), file: libFile.uri),
    );
  });
}
