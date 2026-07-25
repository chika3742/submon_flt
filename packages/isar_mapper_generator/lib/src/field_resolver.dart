import "package:analyzer/dart/constant/value.dart";
import "package:analyzer/dart/element/element.dart";
import "package:analyzer/dart/element/type.dart";
import "package:isar_mapper_annotation/isar_mapper_annotation.dart";
import "package:source_gen/source_gen.dart";

const TypeChecker convertDomainFieldChecker = TypeChecker.typeNamed(
  ConvertDomainField,
  inPackage: "isar_mapper_annotation",
);
const TypeChecker domainFieldConverterChecker = TypeChecker.typeNamed(
  DomainFieldConverter,
  inPackage: "isar_mapper_annotation",
);

class ConstructorParameterSpec {
  const ConstructorParameterSpec({
    required this.name,
    required this.type,
    required this.isRequired,
    required this.defaultValueCode,
    required this.isInsertableIgnored,
  });

  final String name;
  final String type;
  final bool isRequired;
  final String? defaultValueCode;
  final bool isInsertableIgnored;
}

class ClassFieldSpec {
  const ClassFieldSpec({
    required this.name,
    required this.type,
    required this.hasInitializer,
    required this.isLate,
    required this.hasSetter,
    required this.converterClassName,
  });

  factory ClassFieldSpec.fromElement(FieldElement field) {
    final DartObject? converterAnnotation =
        convertDomainFieldChecker.firstAnnotationOfExact(
          field,
          throwOnUnresolved: false,
        );

    return ClassFieldSpec(
      name: field.displayName,
      type: field.type.getDisplayString(),
      hasInitializer: field.hasInitializer,
      isLate: field.isLate,
      hasSetter: field.setter != null,
      converterClassName: _converterClassNameOf(
        annotation: converterAnnotation,
        field: field,
      ),
    );
  }

  final String name;
  final String type;
  final bool hasInitializer;
  final bool isLate;
  final bool hasSetter;
  final String? converterClassName;

  bool get isNullable => type.endsWith("?");

  bool get requiresAssignment => !isNullable && isLate && !hasInitializer;
}

ClassFieldSpec classFieldFromParameter(ConstructorParameterSpec parameter) {
  return ClassFieldSpec(
    name: parameter.name,
    type: parameter.type,
    hasInitializer: parameter.defaultValueCode != null,
    isLate: false,
    hasSetter: true,
    converterClassName: null,
  );
}

class AssignmentSpec {
  const AssignmentSpec({
    required this.target,
    required this.expression,
  });

  final String target;
  final String expression;
}

class ConstructorArgumentSpec {
  const ConstructorArgumentSpec({
    required this.name,
    required this.expression,
  });

  final String name;
  final String expression;
}

class MapperSpec {
  const MapperSpec({
    required this.isarClassName,
    required this.domainClassName,
    required this.toDomainArguments,
    required this.fromDomainAssignments,
    required this.insertableClassName,
    required this.fromInsertableAssignments,
  });

  final String isarClassName;
  final String domainClassName;
  final List<ConstructorArgumentSpec> toDomainArguments;
  final List<AssignmentSpec> fromDomainAssignments;
  final String? insertableClassName;
  final List<AssignmentSpec> fromInsertableAssignments;

  bool get hasInsertable => insertableClassName != null;
}

MapperSpec resolveMapperSpec({
  required String isarClassName,
  required String domainClassName,
  required List<ClassFieldSpec> isarFields,
  required List<ConstructorParameterSpec> domainParameters,
  required String? insertableClassName,
  required List<ClassFieldSpec> insertableFields,
}) {
  final Map<String, ConstructorParameterSpec> domainByName =
      <String, ConstructorParameterSpec>{
        for (final ConstructorParameterSpec parameter in domainParameters)
          parameter.name: parameter,
      };
  final Map<String, ClassFieldSpec> insertableByName = <String, ClassFieldSpec>{
    for (final ClassFieldSpec field in insertableFields) field.name: field,
  };

  final List<AssignmentSpec> fromDomainAssignments = <AssignmentSpec>[];
  final List<AssignmentSpec> fromInsertableAssignments = <AssignmentSpec>[];

  for (final ClassFieldSpec isarField in isarFields) {
    if (!isarField.hasSetter) {
      continue;
    }

    final ConstructorParameterSpec? domainField = domainByName[isarField.name];
    if (domainField == null) {
      if (isarField.requiresAssignment) {
        throw InvalidGenerationSourceError(
          "No domain field matched required Isar field `${isarField.name}`.",
        );
      }
    } else {
      fromDomainAssignments.add(
        AssignmentSpec(
          target: isarField.name,
          expression: _fromSourceExpression(
            sourceName: domainField.name,
            converterClassName: isarField.converterClassName,
          ),
        ),
      );
    }

    if (insertableClassName == null) {
      continue;
    }

    final ClassFieldSpec? insertableField = insertableByName[isarField.name];
    if (insertableField == null) {
      if (isarField.requiresAssignment) {
        throw InvalidGenerationSourceError(
          "No insertable field matched required Isar field `${isarField.name}`. "
              "Make Isar field optional or add the field to insertable.",
        );
      }
      continue;
    }

    fromInsertableAssignments.add(
      AssignmentSpec(
        target: isarField.name,
        expression: _fromSourceExpression(
          sourceName: insertableField.name,
          converterClassName: isarField.converterClassName,
        ),
      ),
    );
  }

  final List<ConstructorArgumentSpec> toDomainArguments =
      <ConstructorArgumentSpec>[];

  for (final ConstructorParameterSpec domainParameter in domainParameters) {
    final ClassFieldSpec? matchedIsarField = _findMappedField(
      isarFields: isarFields,
      domainFieldName: domainParameter.name,
    );
    if (matchedIsarField == null) {
      if (domainParameter.isRequired && domainParameter.defaultValueCode == null) {
        throw InvalidGenerationSourceError(
          "No Isar field matched required domain parameter `${domainParameter.name}`.",
        );
      }
      continue;
    }

    toDomainArguments.add(
      ConstructorArgumentSpec(
        name: domainParameter.name,
        expression: _toDomainExpression(
          isarField: matchedIsarField,
          targetType: domainParameter.type,
        ),
      ),
    );
  }

  return MapperSpec(
    isarClassName: isarClassName,
    domainClassName: domainClassName,
    toDomainArguments: toDomainArguments,
    fromDomainAssignments: fromDomainAssignments,
    insertableClassName: insertableClassName,
    fromInsertableAssignments: fromInsertableAssignments,
  );
}

List<ClassFieldSpec> resolveClassFields(InterfaceElement element) {
  return element.fields
      .where((FieldElement field) => !field.isStatic && !field.isSynthetic)
      .map(ClassFieldSpec.fromElement)
      .toList();
}

String _fromSourceExpression({
  required String sourceName,
  required String? converterClassName,
}) {
  if (converterClassName != null) {
    return "const $converterClassName().fromDomain($sourceName)";
  }

  return sourceName;
}

String _toDomainExpression({
  required ClassFieldSpec isarField,
  required String targetType,
}) {
  final String baseExpression = isarField.converterClassName != null
      ? "const ${isarField.converterClassName}().toDomain(${isarField.name})"
      : isarField.name;
  if (isarField.converterClassName != null) {
    return baseExpression;
  }
  if (isarField.type.endsWith("?") && !targetType.endsWith("?")) {
    return "$baseExpression!";
  }

  return baseExpression;
}

ClassFieldSpec? _findMappedField({
  required List<ClassFieldSpec> isarFields,
  required String domainFieldName,
}) {
  for (final ClassFieldSpec isarField in isarFields) {
    if (!isarField.hasSetter) {
      continue;
    }
    if (isarField.name == domainFieldName) {
      return isarField;
    }
  }

  return null;
}

String? _converterClassNameOf({
  required DartObject? annotation,
  required FieldElement field,
}) {
  if (annotation == null) {
    return null;
  }

  final DartType? annotationType = annotation.type;
  if (annotationType is! InterfaceType || annotationType.typeArguments.length != 1) {
    throw InvalidGenerationSourceError(
      "@ConvertDomainField must specify exactly one converter type.",
      element: field,
    );
  }

  final DartType converterType = annotationType.typeArguments.single;
  final Element? converterElement = converterType.element;
  if (converterElement is! ClassElement) {
    throw InvalidGenerationSourceError(
      "@ConvertDomainField must reference a converter class.",
      element: field,
    );
  }
  if (!domainFieldConverterChecker.isAssignableFromType(converterElement.thisType)) {
    throw InvalidGenerationSourceError(
      "${converterElement.displayName} must implement DomainFieldConverter.",
      element: field,
    );
  }

  final ConstructorElement? unnamedConstructor = converterElement.unnamedConstructor;
  if (unnamedConstructor == null ||
      !unnamedConstructor.isConst ||
      unnamedConstructor.formalParameters.isNotEmpty) {
    throw InvalidGenerationSourceError(
      "${converterElement.displayName} must declare a const unnamed constructor with no parameters.",
      element: field,
    );
  }

  return converterElement.displayName;
}
