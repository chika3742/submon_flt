import "field_resolver.dart";

String emitMapperCode(MapperSpec spec) {
  final StringBuffer buffer = StringBuffer()
    ..writeln(
      "extension ${spec.isarClassName}To${spec.domainClassName} on ${spec.isarClassName} {",
    )
    ..writeln("  ${spec.domainClassName} toDomain() {")
    ..writeln("    return ${spec.domainClassName}(");

  for (final ConstructorArgumentSpec argument in spec.toDomainArguments) {
    buffer.writeln("      ${argument.name}: ${argument.expression},");
  }

  buffer
    ..writeln("    );")
    ..writeln("  }")
    ..writeln("}")
    ..writeln()
    ..writeln(
      "extension ${spec.domainClassName}To${spec.isarClassName} on ${spec.domainClassName} {",
    )
    ..writeln("  ${spec.isarClassName} toIsar() {")
    ..writeln("    return ${spec.isarClassName}()");

  for (final AssignmentSpec assignment in spec.fromDomainAssignments) {
    buffer.writeln("      ..${assignment.target} = ${assignment.expression}");
  }

  buffer
    ..writeln(";")
    ..writeln("  }")
    ..writeln("}");

  if (spec.hasInsertable) {
    buffer
      ..writeln()
      ..writeln(
        "extension ${spec.insertableClassName}To${spec.isarClassName} on ${spec.insertableClassName} {",
      )
      ..writeln("  ${spec.isarClassName} toIsar() {")
      ..writeln("    return ${spec.isarClassName}()");

    for (final AssignmentSpec assignment in spec.fromInsertableAssignments) {
      buffer.writeln("      ..${assignment.target} = ${assignment.expression}");
    }

    buffer
      ..writeln(";")
      ..writeln("  }")
      ..writeln("}");
  }

  return buffer.toString();
}
