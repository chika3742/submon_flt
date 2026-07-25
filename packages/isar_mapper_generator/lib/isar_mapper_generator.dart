import "package:build/build.dart";
import "package:source_gen/source_gen.dart";

import "src/isar_mapper_generator.dart";

Builder isarMapperBuilder(BuilderOptions options) {
  return SharedPartBuilder([IsarMapperGenerator()], "isar_mapper");
}
