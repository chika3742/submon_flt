#!/usr/bin/env fvm dart run

// Runs Pigeon code generation for native platform communication.

import "dart:async";
import "dart:io";

Future<void> main() async {
  final process = await Process.start(
    "fvm",
    ["dart", "run", "pigeon", "--input", "./pigeon/pigeons.dart"],
    workingDirectory: File(Platform.script.toFilePath()).parent.parent.path,
  );

  unawaited(process.stdout.pipe(stdout));
  unawaited(process.stderr.pipe(stderr));

  await process.exitCode;
}
