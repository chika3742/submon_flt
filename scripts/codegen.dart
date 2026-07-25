#!/usr/bin/env fvm dart run

// Runs build_runner builds with AOT builders. Use `codegen.dart watch` to watch
// file changes.

import "dart:async";
import "dart:io";

Future<void> main(List<String> arguments) async {
  final command = arguments.elementAtOrNull(0) ?? "build";

  final process = await Process.start(
    "fvm",
    ["dart", "run", "build_runner", command, "--delete-conflicting-outputs", "--force-aot"],
    workingDirectory: File(Platform.script.toFilePath()).parent.parent.path,
    mode: ProcessStartMode.inheritStdio,
  );

  exitCode = await process.exitCode;
}
