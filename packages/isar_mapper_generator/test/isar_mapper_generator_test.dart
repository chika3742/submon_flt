import "package:build/build.dart";
import "package:build_test/build_test.dart";
import "package:isar_mapper_generator/isar_mapper_generator.dart";
import "package:test/test.dart";

void main() {
  const String packageName = "isar_mapper_generator";
  const String annotationLib = """
class IsarMap {
  const IsarMap({required this.domain, this.insertable});

  final Type domain;
  final Type? insertable;
}

abstract class DomainFieldConverter<DomainT, IsarT> {
  const DomainFieldConverter();

  IsarT fromDomain(DomainT value);
  DomainT toDomain(IsarT value);
}

class ConvertDomainField<
  Converter extends DomainFieldConverter<Object?, Object?>
> {
  const ConvertDomainField();
}
""";

  group("isar mapper generator", () {
    test("generates extension-only mapping helpers", () async {
      await testBuilder(
        isarMapperBuilder(BuilderOptions.empty),
        <String, String>{
          "isar_mapper_annotation|lib/isar_mapper_annotation.dart": annotationLib,
          "$packageName|lib/simple.dart": """
library simple;

import "package:isar_mapper_annotation/isar_mapper_annotation.dart";

part "simple.g.dart";

@IsarMap(domain: SimpleDomain)
class SimpleIsar {
  int? id;
  late String title;
}

abstract class SimpleDomain {
  const factory SimpleDomain({
    required int id,
    required String title,
  }) = _SimpleDomain;
}

class _SimpleDomain implements SimpleDomain {
  const _SimpleDomain({
    required this.id,
    required this.title,
  });

  final int id;
  final String title;
}
""",
        },
        outputs: <String, Matcher>{
          "$packageName|lib/simple.isar_mapper.g.part": decodedMatches(
            allOf(
              contains("extension SimpleIsarToSimpleDomain on SimpleIsar"),
              contains("extension SimpleDomainToSimpleIsar on SimpleDomain"),
              contains("id: id!"),
              contains("..id = id"),
              contains("..title = title"),
              isNot(contains("mixin _\$SimpleIsarMapper")),
            ),
          ),
        },
      );
    });

    test("supports converter classes and insertables", () async {
      await testBuilder(
        isarMapperBuilder(BuilderOptions.empty),
        <String, String>{
          "isar_mapper_annotation|lib/isar_mapper_annotation.dart": annotationLib,
          "$packageName|lib/converter.dart": """
library converter;

import "package:isar_mapper_annotation/isar_mapper_annotation.dart";

part "converter.g.dart";

class ColorConverter implements DomainFieldConverter<String, int> {
  const ColorConverter();

  @override
  int fromDomain(String value) => value.length;

  @override
  String toDomain(int value) => "decoded-\$value";
}

@IsarMap(domain: ConverterDomain, insertable: ConverterInsertable)
class ConverterIsar {
  int? id;
  late String title;

  @ConvertDomainField<ColorConverter>()
  int color = 0;
}

abstract class ConverterDomain {
  const factory ConverterDomain({
    required int id,
    required String title,
    required String color,
  }) = _ConverterDomain;
}

class _ConverterDomain implements ConverterDomain {
  const _ConverterDomain({
    required this.id,
    required this.title,
    required this.color,
  });

  final int id;
  final String title;
  final String color;
}

class ConverterInsertable {
  const ConverterInsertable({
    required this.title,
    required this.color,
  });

  final String title;
  final String color;
}
""",
        },
        outputs: <String, Matcher>{
          "$packageName|lib/converter.isar_mapper.g.part": decodedMatches(
            allOf(
              contains(
                "color: const ColorConverter().toDomain(color)",
              ),
              contains(
                "..color = const ColorConverter().fromDomain(color)",
              ),
              contains(
                "extension ConverterInsertableToConverterIsar on ConverterInsertable",
              ),
              isNot(contains("_\$afterFromDomain")),
              isNot(contains("_\$toDomain({")),
            ),
          ),
        },
      );
    });

    test("skips getter-only fields", () async {
      await testBuilder(
        isarMapperBuilder(BuilderOptions.empty),
        <String, String>{
          "isar_mapper_annotation|lib/isar_mapper_annotation.dart": annotationLib,
          "$packageName|lib/getter_only.dart": """
library getter_only;

import "package:isar_mapper_annotation/isar_mapper_annotation.dart";

part "getter_only.g.dart";

@IsarMap(domain: GetterDomain)
class GetterIsar {
  int get id => count;
  late int count;
}

abstract class GetterDomain {
  const factory GetterDomain({
    required int count,
  }) = _GetterDomain;
}

class _GetterDomain implements GetterDomain {
  const _GetterDomain({required this.count});

  final int count;
}
""",
        },
        outputs: <String, Matcher>{
          "$packageName|lib/getter_only.isar_mapper.g.part": decodedMatches(
            allOf(
              contains("..count = count"),
              isNot(contains("..id =")),
            ),
          ),
        },
      );
    });

    test("fails on unmatched required domain parameter", () async {
      final List<String> logs = <String>[];

      await testBuilder(
        isarMapperBuilder(BuilderOptions.empty),
        <String, String>{
          "isar_mapper_annotation|lib/isar_mapper_annotation.dart": annotationLib,
          "$packageName|lib/invalid.dart": """
library invalid;

import "package:isar_mapper_annotation/isar_mapper_annotation.dart";

part "invalid.g.dart";

@IsarMap(domain: InvalidDomain)
class InvalidIsar {
  late String title;
}

abstract class InvalidDomain {
  const factory InvalidDomain({
    required String title,
    required String repeat,
  }) = _InvalidDomain;
}

class _InvalidDomain implements InvalidDomain {
  const _InvalidDomain({
    required this.title,
    required this.repeat,
  });

  final String title;
  final String repeat;
}
""",
        },
        onLog: (record) => logs.add(record.message),
      );

      expect(
        logs.any(
          (String log) => log.contains(
            "No Isar field matched required domain parameter `repeat`.",
          ),
        ),
        isTrue,
      );
    });
  });
}
