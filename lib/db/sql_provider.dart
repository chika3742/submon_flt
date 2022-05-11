import 'package:sqflite/sqflite.dart';
import 'package:submon/db/submission.dart';
import 'package:submon/db/timetable.dart';

const schemaVer = 4;

abstract class SqlProvider<T> {
  SqlProvider({Database? db}) {
    if (db != null) {
      this.db = db;
    }
  }

  late Database db;

  /// Gets SQL Column list with [SqlField]
  List<SqlField> columns();

  List<String> _getColumnNameList() {
    return columns().map((e) => e.fieldName).toList();
  }

  /// Gets name of table.
  String tableName();

  /// Converts from map to database object.
  T mapToObj(Map<String, dynamic> map);

  /// Converts from database object to map.
  Map<String, Object?> objToMap(T data);

  /// Opens database.
  Future<void> open() async {
    db = await openDatabase("main.db",
        version: schemaVer,
        onUpgrade: migrate,
        onDowngrade: onDatabaseDowngradeDelete);
    var createSql = "create table if not exists ${tableName()} ( ";
    columns().forEach((element) {
      createSql += "${element.fieldName} ";
      switch (element.type) {
        case DataType.string:
          createSql += "text ";
          break;
        case DataType.integer:
        case DataType.bool:
          createSql += "integer ";
          break;
        case DataType.real:
          createSql += "real ";
          break;
      }
      if (element.isPrimaryKey) {
        createSql += "primary key autoincrement, ";
      } else if (element.isNonNull) {
        createSql += "not null, ";
      } else {
        createSql += ", ";
      }
    });

    createSql = createSql.replaceRange(createSql.lastIndexOf(","), null, ")");

    await db.execute(createSql);
  }

  /// Obtains single item.
  Future<T?> get(int id) async {
    var maps = await db.query(tableName(),
        columns: _getColumnNameList(), where: "id = ?", whereArgs: [id]);

    if (maps.isNotEmpty) {
      return mapToObj(maps.first);
    } else {
      return null;
    }
  }

  /// Obtains item list.
  Future<List<T>> getAll({String? where, List<dynamic>? whereArgs}) async {
    var maps = await db.query(tableName(),
        columns: _getColumnNameList(), where: where, whereArgs: whereArgs);
    return maps.map((e) => mapToObj(e)).toList();
  }

  /// Inserts item to both local DB and Firestore.
  Future<T> insert(T data) async {
    (data as dynamic).id = await db.insert(tableName(), objToMap(data),
        conflictAlgorithm: ConflictAlgorithm.replace);
    setFirestore(data);
    return data;
  }

  /// Inserts item to local DB.
  Future<T> insertLocalOnly(T data) async {
    (data as dynamic).id = await db.insert(tableName(), objToMap(data),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return data;
  }

  Future<int> update(T data) async {
    setFirestore(data);
    return await db.update(tableName(), objToMap(data),
        where: "id = ?", whereArgs: [(data as dynamic).id]);
  }

  Future<int> delete(int id) async {
    deleteFirestore(id);
    return await db.delete(tableName(), where: "id = ?", whereArgs: [id]);
  }

  Future<void> deleteAll() async {
    deleteAllFirestore();
    await deleteAllLocal();
  }

  Future<void> deleteAllLocal() async {
    await db.execute("delete from ${tableName()}");
  }

  Future<void> setAllLocally(List<Map<String, dynamic>> list) async {
    await deleteAllLocal();
    await Future.forEach<Map<String, dynamic>>(list, (element) async {
      await db.insert(tableName(), objToMap(mapToObj(element)),
          conflictAlgorithm: ConflictAlgorithm.replace);
    });
  }

  Future<void> setFirestore(T data);

  Future<void> deleteFirestore(int id);

  void deleteAllFirestore();

  /// Currently unused.
  void setAllFirestore(List<Map<String, dynamic>> list);

  Future<void> use(dynamic Function(SqlProvider<T> provider) fn) async {
    await open();
    await fn(this);
    // await close();
  }

  static Future<void> clearAllTables() async {
    await deleteDatabase("main.db");
  }

  Future close() => db.close();
}

Future<void> migrate(Database db, int oldVersion, int newVersion) async {
  // MIGRATE FIRESTORE TOO
  if (oldVersion == 1) {
    await db.execute(
        "alter table $tableTimetable add column $colNote integer not null default ''");
    oldVersion++;
  }
  if (oldVersion == 2) {
    await db.execute(
        "alter table $tableSubmission add column $colGoogleTasksTaskId string");
    oldVersion++;
  }
  if (oldVersion == 3) {
    await db.execute(
        "alter table $tableSubmission add column $colCanvasPlannableId string");
    oldVersion++;
  }
}

class SqlField {
  SqlField(this.fieldName, this.type,
      {this.isPrimaryKey = false, this.isNonNull = true});

  final String fieldName;
  final DataType type;
  final bool isPrimaryKey;
  final bool isNonNull;
}

enum DataType { string, integer, bool, real }
