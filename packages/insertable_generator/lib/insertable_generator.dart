import "package:build/build.dart";
import "package:source_gen/source_gen.dart";

import "src/insertable_generator.dart";

Builder insertableBuilder(BuilderOptions options) {
  return SharedPartBuilder([InsertableGenerator()], "insertable");
}
