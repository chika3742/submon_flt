import "dart:ui";

import "package:drift/drift.dart";
import "package:drift_flutter/drift_flutter.dart";

import "../constants/schema_ver.dart";
import "../types/enums.dart";

part "db.g.dart";

class Submissions extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get details => text()();
  DateTimeColumn get due => dateTime()();
  BoolColumn get dueDateOnly => boolean().withDefault(Constant(true))();
  BoolColumn get done => boolean().withDefault(Constant(false))();
  BoolColumn get important => boolean().withDefault(Constant(false))();
  IntColumn get repeat => intEnum<RepeatType>().withDefault(Constant(RepeatType.none.index))();
  IntColumn get color => integer().map(ColorConverter()).withDefault(Constant(0xFFFFFFFF /* white */))();
  TextColumn get googleTasksTaskId => text().nullable()();
  BoolColumn get repeatSubmissionCreated => boolean().nullable()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

class Digestives extends Table {
  TextColumn get id => text()();
  TextColumn get submissionId => text().references(Submissions, #id)();
  BoolColumn get done => boolean().withDefault(Constant(false))();
  DateTimeColumn get startAt => dateTime()();
  IntColumn get minute => integer()();
  TextColumn get column => text()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

class TimetableTables extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

class TimetableCells extends Table {
  IntColumn get cellId => integer()();
  TextColumn get tableId => text().references(TimetableTables, #id)();
  TextColumn get subject => text()();
  TextColumn get teacher => text()();
  TextColumn get room => text()();
  IntColumn get note => integer()();

  @override
  Set<Column<Object>>? get primaryKey => {cellId, tableId};
}

class TimetableClassTime extends Table {
  IntColumn get periodIndex => integer()();
  TextColumn get startAt => text()();
  TextColumn get endAt => text()();

  @override
  Set<Column<Object>>? get primaryKey => {periodIndex};
}

class ColorConverter extends TypeConverter<Color, int> {
  @override
  Color fromSql(int fromDb) {
    return Color(fromDb);
  }

  @override
  int toSql(Color value) {
    return value.value;
  }
}

@DriftDatabase(
  tables: [
    Submissions,
    Digestives,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => schemaVer;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: "main_db");
  }
}
