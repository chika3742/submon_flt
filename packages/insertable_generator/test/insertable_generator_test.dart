import "package:build/build.dart";
import "package:build_test/build_test.dart";
import "package:insertable_generator/insertable_generator.dart";
import "package:test/test.dart";

void main() {
  const String packageName = "insertable_generator";

  group("insertable generator", () {
    test("generates a plain insertable class", () async {
      await testBuilder(
        insertableBuilder(BuilderOptions.empty),
        <String, String>{
          "insertable_annotation|lib/insertable_annotation.dart": """
class GenerateInsertable {
  const GenerateInsertable();
}

const generateInsertable = GenerateInsertable();

class InsertableIgnore {
  const InsertableIgnore();
}

const insertableIgnore = InsertableIgnore();
""",
          "$packageName|lib/simple.dart": """
library simple;

import "package:insertable_annotation/insertable_annotation.dart";

part "simple.g.dart";

@generateInsertable
abstract class SimpleDomain {
  const factory SimpleDomain({
    required String title,
    required int minute,
  }) = _SimpleDomain;
}

class _SimpleDomain implements SimpleDomain {
  const _SimpleDomain({
    required this.title,
    required this.minute,
  });

  final String title;
  final int minute;
}
""",
        },
        outputs: <String, Matcher>{
          "$packageName|lib/simple.insertable.g.part": decodedMatches(
            allOf(
              contains("class SimpleDomainInsertable"),
              contains("required this.title"),
              contains("required this.minute"),
              contains("Object.hash(title, minute)"),
            ),
          ),
        },
      );
    });

    test("respects ignore and default annotations", () async {
      await testBuilder(
        insertableBuilder(BuilderOptions.empty),
        <String, String>{
          "freezed_annotation|lib/freezed_annotation.dart": """
class Default {
  const Default(this.value);

  final Object? value;
}
""",
          "insertable_annotation|lib/insertable_annotation.dart": """
class GenerateInsertable {
  const GenerateInsertable();
}

const generateInsertable = GenerateInsertable();

class InsertableIgnore {
  const InsertableIgnore();
}

const insertableIgnore = InsertableIgnore();
""",
          "$packageName|lib/defaulted.dart": """
library defaulted;

import "package:freezed_annotation/freezed_annotation.dart";
import "package:insertable_annotation/insertable_annotation.dart";

part "defaulted.g.dart";

@generateInsertable
abstract class DefaultedDomain {
  const factory DefaultedDomain({
    @insertableIgnore required int id,
    required String title,
    @Default(true) bool done,
    required int? parentId,
  }) = _DefaultedDomain;
}

class _DefaultedDomain implements DefaultedDomain {
  const _DefaultedDomain({
    required this.id,
    required this.title,
    this.done = true,
    required this.parentId,
  });

  final int id;
  final String title;
  final bool done;
  final int? parentId;
}
""",
        },
        outputs: <String, Matcher>{
          "$packageName|lib/defaulted.insertable.g.part": decodedMatches(
            allOf(
              contains("class DefaultedDomainInsertable"),
              isNot(contains("this.id")),
              contains("this.done = true"),
              contains("required this.parentId"),
            ),
          ),
        },
      );
    });

    test("uses direct hashCode for single-field insertables", () async {
      await testBuilder(
        insertableBuilder(BuilderOptions.empty),
        <String, String>{
          "insertable_annotation|lib/insertable_annotation.dart": """
class GenerateInsertable {
  const GenerateInsertable();
}

const generateInsertable = GenerateInsertable();

class InsertableIgnore {
  const InsertableIgnore();
}

const insertableIgnore = InsertableIgnore();
""",
          "$packageName|lib/single.dart": """
library single;

import "package:insertable_annotation/insertable_annotation.dart";

part "single.g.dart";

@generateInsertable
abstract class SingleFieldDomain {
  const factory SingleFieldDomain({
    required String title,
  }) = _SingleFieldDomain;
}

class _SingleFieldDomain implements SingleFieldDomain {
  const _SingleFieldDomain({
    required this.title,
  });

  final String title;
}
""",
        },
        outputs: <String, Matcher>{
          "$packageName|lib/single.insertable.g.part": decodedMatches(
            allOf(
              contains("class SingleFieldDomainInsertable"),
              contains("int get hashCode => title.hashCode;"),
              isNot(contains("Object.hash(title)")),
            ),
          ),
        },
      );
    });

    test("fails without an unnamed redirecting factory", () async {
      final List<String> logs = <String>[];

      await testBuilder(
        insertableBuilder(BuilderOptions.empty),
        <String, String>{
          "insertable_annotation|lib/insertable_annotation.dart": """
class GenerateInsertable {
  const GenerateInsertable();
}

const generateInsertable = GenerateInsertable();

class InsertableIgnore {
  const InsertableIgnore();
}

const insertableIgnore = InsertableIgnore();
""",
          "$packageName|lib/invalid.dart": """
library invalid;

import "package:insertable_annotation/insertable_annotation.dart";

part "invalid.g.dart";

@generateInsertable
class InvalidDomain {
  const InvalidDomain({required this.title});

  final String title;
}
""",
        },
        onLog: (record) => logs.add(record.message),
      );

      expect(
        logs.any(
          (String log) => log.contains(
            "Could not find an unnamed redirecting factory constructor",
          ),
        ),
        isTrue,
      );
    });
  });
}
