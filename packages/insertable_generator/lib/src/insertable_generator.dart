import "package:analyzer/dart/analysis/utilities.dart";
import "package:analyzer/dart/ast/ast.dart";
import "package:analyzer/dart/element/element.dart";
import "package:build/build.dart";
import "package:insertable_annotation/insertable_annotation.dart";
import "package:source_gen/source_gen.dart";

class InsertableGenerator extends GeneratorForAnnotation<GenerateInsertable> {
  const InsertableGenerator() : super(inPackage: "insertable_annotation");

  @override
  Future<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        "@generateInsertable can only be used on classes.",
        element: element,
      );
    }

    final ClassDeclaration classDeclaration = await _findClassDeclaration(
      buildStep: buildStep,
      className: element.displayName,
    );
    final ConstructorDeclaration constructorDeclaration =
        _findRedirectingFactoryConstructor(classDeclaration);

    final List<_InsertableField> fields = <_InsertableField>[];
    for (final FormalParameter parameter
        in constructorDeclaration.parameters.parameters) {
      if (!parameter.isNamed) {
        throw InvalidGenerationSourceError(
          "Only named factory parameters are supported by @generateInsertable.",
          node: parameter,
        );
      }
      if (_hasInsertableIgnore(parameter)) {
        continue;
      }

      final String name = _parameterName(parameter);
      final String type = _parameterType(parameter);
      final String? defaultValueCode = _findDefaultValueCode(parameter);
      final bool isRequired = _isRequiredParameter(parameter);
      if (!isRequired && defaultValueCode == null && !type.endsWith("?")) {
        throw InvalidGenerationSourceError(
          "Optional non-nullable parameter `$name` must declare @Default(...) "
          "or be marked required to generate an Insertable class.",
          node: parameter,
        );
      }

      fields.add(
        _InsertableField(
          name: name,
          type: type,
          isRequired: isRequired && defaultValueCode == null,
          defaultValueCode: defaultValueCode,
        ),
      );
    }

    return _generateClassCode(
      className: "${element.name}Insertable",
      fields: fields,
    );
  }

  Future<ClassDeclaration> _findClassDeclaration({
    required BuildStep buildStep,
    required String className,
  }) async {
    final parseResult = parseString(
      content: await buildStep.readAsString(buildStep.inputId),
      path: buildStep.inputId.path,
    );

    for (final CompilationUnitMember declaration in parseResult.unit.declarations) {
      if (declaration is ClassDeclaration &&
          declaration.name.lexeme == className) {
        return declaration;
      }
    }

    throw InvalidGenerationSourceError(
      "Could not resolve class declaration for $className.",
    );
  }

  ConstructorDeclaration _findRedirectingFactoryConstructor(
    ClassDeclaration classDeclaration,
  ) {
    ConstructorDeclaration? redirectingFactory;
    for (final ClassMember member in classDeclaration.members) {
      if (member is! ConstructorDeclaration) {
        continue;
      }
      if (member.factoryKeyword == null ||
          member.name != null ||
          member.redirectedConstructor == null) {
        continue;
      }
      if (redirectingFactory != null) {
        throw InvalidGenerationSourceError(
          "Only one unnamed redirecting factory is supported for "
          "@generateInsertable.",
          node: classDeclaration,
        );
      }
      redirectingFactory = member;
    }

    if (redirectingFactory == null) {
      throw InvalidGenerationSourceError(
        "Could not find an unnamed redirecting factory constructor on "
        "${classDeclaration.name.lexeme}.",
        node: classDeclaration,
      );
    }

    return redirectingFactory;
  }

  String _parameterName(FormalParameter parameter) {
    final FormalParameter rootParameter = _unwrapParameter(parameter);

    return switch (rootParameter) {
      SimpleFormalParameter(name: final nameToken) when nameToken != null =>
        nameToken.lexeme,
      FieldFormalParameter(name: final nameToken) => nameToken.lexeme,
      SuperFormalParameter(name: final nameToken) => nameToken.lexeme,
      _ => throw InvalidGenerationSourceError(
          "Unsupported parameter declaration `${rootParameter.toSource()}`.",
          node: rootParameter,
        ),
    };
  }

  String _parameterType(FormalParameter parameter) {
    final FormalParameter rootParameter = _unwrapParameter(parameter);
    final TypeAnnotation? typeAnnotation = switch (rootParameter) {
      SimpleFormalParameter(type: final type) => type,
      FieldFormalParameter(type: final type) => type,
      SuperFormalParameter(type: final type) => type,
      _ => null,
    };
    if (typeAnnotation == null) {
      throw InvalidGenerationSourceError(
        "Parameter `${_parameterName(parameter)}` must declare an explicit type.",
        node: rootParameter,
      );
    }

    return typeAnnotation.toSource();
  }

  bool _isRequiredParameter(FormalParameter parameter) {
    return _unwrapParameter(parameter).requiredKeyword != null;
  }

  bool _hasInsertableIgnore(FormalParameter parameter) {
    return _annotationsOf(parameter).any((Annotation annotation) {
      final String name = _annotationName(annotation);
      return name == "insertableIgnore" || name == "InsertableIgnore";
    });
  }

  String? _findDefaultValueCode(FormalParameter parameter) {
    for (final Annotation annotation in _annotationsOf(parameter)) {
      if (_annotationName(annotation) != "Default") {
        continue;
      }

      final ArgumentList? arguments = annotation.arguments;
      if (arguments == null || arguments.arguments.length != 1) {
        throw InvalidGenerationSourceError(
          "@Default(...) on Insertable parameters must have exactly one argument.",
          node: annotation,
        );
      }
      return arguments.arguments.single.toSource();
    }

    return null;
  }

  Iterable<Annotation> _annotationsOf(FormalParameter parameter) sync* {
    if (parameter.metadata.isNotEmpty) {
      yield* parameter.metadata;
    }

    final FormalParameter rootParameter = _unwrapParameter(parameter);
    if (!identical(rootParameter, parameter) && rootParameter.metadata.isNotEmpty) {
      yield* rootParameter.metadata;
    }
  }

  FormalParameter _unwrapParameter(FormalParameter parameter) {
    return parameter is DefaultFormalParameter ? parameter.parameter : parameter;
  }

  String _annotationName(Annotation annotation) {
    return annotation.name.toSource().split(".").last;
  }

  String _generateClassCode({
    required String className,
    required List<_InsertableField> fields,
  }) {
    final StringBuffer buffer = StringBuffer()
      ..writeln("class $className {")
      ..writeln("  const $className({");

    for (final _InsertableField field in fields) {
      final String prefix = field.isRequired ? "required " : "";
      final String defaultClause = field.defaultValueCode != null
          ? " = ${field.defaultValueCode}"
          : "";
      buffer.writeln("    ${prefix}this.${field.name}$defaultClause,");
    }

    buffer
      ..writeln("  });")
      ..writeln();

    for (final _InsertableField field in fields) {
      buffer.writeln("  final ${field.type} ${field.name};");
    }

    if (fields.isNotEmpty) {
      buffer.writeln();
    }

    buffer
      ..writeln("  @override")
      ..write("  bool operator ==(Object other) => ");

    if (fields.isEmpty) {
      buffer.writeln("identical(this, other) || other is $className;");
    } else {
      buffer
        ..writeln("identical(this, other) ||")
        ..writeln("      other is $className &&");
      for (var index = 0; index < fields.length; index++) {
        final _InsertableField field = fields[index];
        final String suffix = index == fields.length - 1 ? ";" : " &&";
        buffer.writeln("          ${field.name} == other.${field.name}$suffix");
      }
    }

    buffer
      ..writeln()
      ..writeln("  @override");

    if (fields.isEmpty) {
      buffer.writeln("  int get hashCode => runtimeType.hashCode;");
    } else if (fields.length == 1) {
      buffer.writeln("  int get hashCode => ${fields.single.name}.hashCode;");
    } else if (fields.length <= 20) {
      buffer.writeln(
        "  int get hashCode => Object.hash(${fields.map((field) => field.name).join(", ")});",
      );
    } else {
      buffer.writeln(
        "  int get hashCode => Object.hashAll([${fields.map((field) => field.name).join(", ")}]);",
      );
    }

    buffer
      ..writeln()
      ..writeln("  @override")
      ..write("  String toString() => ");

    if (fields.isEmpty) {
      buffer.writeln("\"$className()\";");
    } else {
      final String values = fields
          .map((field) => "${field.name}: \$${field.name}")
          .join(", ");
      buffer.writeln("\"$className($values)\";");
    }

    buffer.writeln("}");

    return buffer.toString();
  }
}

class _InsertableField {
  const _InsertableField({
    required this.name,
    required this.type,
    required this.isRequired,
    required this.defaultValueCode,
  });

  final String name;
  final String type;
  final bool isRequired;
  final String? defaultValueCode;
}
