import "package:analyzer/dart/analysis/utilities.dart";
import "package:analyzer/dart/ast/ast.dart";
import "package:analyzer/dart/element/element.dart";
import "package:analyzer/dart/element/type.dart";
import "package:build/build.dart";
import "package:isar_mapper_annotation/isar_mapper_annotation.dart";
import "package:source_gen/source_gen.dart";

import "code_emitters.dart";
import "field_resolver.dart";

class IsarMapperGenerator extends GeneratorForAnnotation<IsarMap> {
  const IsarMapperGenerator()
      : super(inPackage: "isar_mapper_annotation");

  @override
  Future<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        "@IsarMap can only be used on classes.",
        element: element,
      );
    }

    final ClassElement domainElement = _requireClassElement(
      annotation.read("domain").typeValue,
      "domain",
      element,
    );
    final ClassDeclaration isarClassDeclaration = await _parseClassDeclaration(
      buildStep: buildStep,
      classElement: element,
    );
    final String? insertableClassNameFromAst = _findIsarMapInsertableName(
      isarClassDeclaration,
    );
    final DartType? insertableType = annotation.peek("insertable")?.isNull == true
        ? null
        : annotation.peek("insertable")?.typeValue;
    final ClassElement? insertableElement = insertableType == null
        ? null
        : _requireClassElement(insertableType, "insertable", element);

    final ClassDeclaration domainClassDeclaration = await _parseClassDeclaration(
      buildStep: buildStep,
      classElement: domainElement,
    );
    final List<ConstructorParameterSpec> domainParameters =
        _parseDomainParametersFromDeclaration(domainClassDeclaration);
    final List<ClassFieldSpec> insertableFields;
    if (insertableElement != null) {
      insertableFields = resolveClassFields(insertableElement);
    } else if (insertableClassNameFromAst != null) {
      insertableFields = domainParameters
          .where(
            (ConstructorParameterSpec parameter) => !parameter.isInsertableIgnored,
          )
          .map(classFieldFromParameter)
          .toList();
    } else {
      insertableFields = const <ClassFieldSpec>[];
    }
    final MapperSpec spec = resolveMapperSpec(
      isarClassName: element.displayName,
      domainClassName: domainElement.displayName,
      isarFields: resolveClassFields(element),
      domainParameters: domainParameters,
      insertableClassName:
          insertableElement?.displayName ?? insertableClassNameFromAst,
      insertableFields: insertableFields,
    );

    return emitMapperCode(spec);
  }

  ClassElement _requireClassElement(
    DartType type,
    String fieldName,
    Element annotatedElement,
  ) {
    final Element? typeElement = type.element;
    if (typeElement is! ClassElement) {
      throw InvalidGenerationSourceError(
        "@IsarMap `$fieldName` must reference a class.",
        element: annotatedElement,
      );
    }

    return typeElement;
  }

  List<ConstructorParameterSpec> _parseDomainParametersFromDeclaration(
    ClassDeclaration classDeclaration,
  ) {
    final ConstructorDeclaration constructorDeclaration =
        _findRedirectingFactoryConstructor(classDeclaration);

    return constructorDeclaration.parameters.parameters
        .map(_parameterFromAst)
        .toList();
  }

  ClassDeclaration _findClassDeclaration(
    CompilationUnit unit,
    String className,
  ) {
    for (final CompilationUnitMember declaration in unit.declarations) {
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
          "Only one unnamed redirecting factory is supported for @IsarMap domains.",
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

  ConstructorParameterSpec _parameterFromAst(FormalParameter parameter) {
    if (!parameter.isNamed) {
      throw InvalidGenerationSourceError(
        "Only named factory parameters are supported for @IsarMap domains.",
        node: parameter,
      );
    }

    final FormalParameter root = parameter is DefaultFormalParameter
        ? parameter.parameter
        : parameter;
    final TypeAnnotation? typeAnnotation = switch (root) {
      SimpleFormalParameter(type: final type) => type,
      FieldFormalParameter(type: final type) => type,
      SuperFormalParameter(type: final type) => type,
      _ => null,
    };
    if (typeAnnotation == null) {
      throw InvalidGenerationSourceError(
        "Parameter `${_parameterName(parameter)}` must declare an explicit type.",
        node: root,
      );
    }

    return ConstructorParameterSpec(
      name: _parameterName(parameter),
      type: typeAnnotation.toSource(),
      isRequired: root.requiredKeyword != null,
      defaultValueCode: _defaultValueCode(parameter),
      isInsertableIgnored: _hasInsertableIgnore(parameter),
    );
  }

  String _parameterName(FormalParameter parameter) {
    final FormalParameter root = parameter is DefaultFormalParameter
        ? parameter.parameter
        : parameter;

    return switch (root) {
      SimpleFormalParameter(name: final nameToken) when nameToken != null =>
        nameToken.lexeme,
      FieldFormalParameter(name: final nameToken) => nameToken.lexeme,
      SuperFormalParameter(name: final nameToken) => nameToken.lexeme,
      _ => throw InvalidGenerationSourceError(
          "Unsupported parameter declaration `${root.toSource()}`.",
          node: root,
        ),
    };
  }

  String? _defaultValueCode(FormalParameter parameter) {
    for (final Annotation annotation in _annotationsOf(parameter)) {
      if (annotation.name.toSource().split(".").last != "Default") {
        continue;
      }
      final ArgumentList? arguments = annotation.arguments;
      if (arguments == null || arguments.arguments.length != 1) {
        throw InvalidGenerationSourceError(
          "@Default(...) must have exactly one argument.",
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

    if (parameter is DefaultFormalParameter &&
        parameter.parameter.metadata.isNotEmpty) {
      yield* parameter.parameter.metadata;
    }
  }

  Future<ClassDeclaration> _parseClassDeclaration({
    required BuildStep buildStep,
    required ClassElement classElement,
  }) async {
    final AssetId assetId = await buildStep.resolver.assetIdForElement(
      classElement,
    );
    final parseResult = parseString(
      content: await buildStep.readAsString(assetId),
      path: assetId.path,
    );

    return _findClassDeclaration(parseResult.unit, classElement.displayName);
  }

  String? _findIsarMapInsertableName(ClassDeclaration classDeclaration) {
    for (final Annotation annotation in classDeclaration.metadata) {
      if (annotation.name.toSource().split(".").last != "IsarMap") {
        continue;
      }
      final ArgumentList? arguments = annotation.arguments;
      if (arguments == null) {
        return null;
      }
      for (final Expression argument in arguments.arguments) {
        if (argument is NamedExpression &&
            argument.name.label.name == "insertable") {
          return argument.expression.toSource();
        }
      }
    }

    return null;
  }

  bool _hasInsertableIgnore(FormalParameter parameter) {
    for (final Annotation annotation in _annotationsOf(parameter)) {
      final String name = annotation.name.toSource().split(".").last;
      if (name == "insertableIgnore" || name == "InsertableIgnore") {
        return true;
      }
    }

    return false;
  }
}
