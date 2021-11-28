import 'package:sqflite/sqflite.dart';

abstract class SqlProvider<T> {
  late Database db;

  /// Gets SQL Column list with [SqlField]
  List<SqlField> columns();

  List<String> _getColumnNameList() {
    return columns().map((e) => e.fieldName).toList();
  }

  /// Gets database schema version.
  int schemaVersion();

  /// Gets name of table.
  String tableName();

  /// migrating process
  void migrate(Database db, int oldVersion, int newVersion);

  /// Converts from map to database object.
  T mapToObj(Map map);

  /// Converts from database object to map.
  Map<String, Object?> objToMap(T data);

  /// Opens database.
  Future<void> open() async {
    db = await openDatabase("main.db",
        version: schemaVersion(),
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
      }
      if (!element.isPrimaryKey) {
        createSql += "not null, ";
      } else {
        createSql += "primary key autoincrement, ";
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
  Future<List<T>> getList({String? where, List<dynamic>? whereArgs}) async {
    var maps = await db.query(tableName(),
        columns: _getColumnNameList(), where: where, whereArgs: whereArgs);
    return maps.map((e) => mapToObj(e)).toList();
  }

  Future<T> insert(T data) async {
    (data as dynamic).id = await db.insert(tableName(), objToMap(data),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return data;
  }

  Future<int> delete(int id) async {
    return await db.delete(tableName(), where: "id = ?", whereArgs: [id]);
  }

  Future<int> update(T data) async {
    return await db.update(tableName(), objToMap(data),
        where: "id = ?", whereArgs: [(data as dynamic).id]);
  }

  use(dynamic Function(SqlProvider<T> provider) fn) async {
    await open();
    await fn(this);
    await close();
  }

  Future close() => db.close();
}

class SqlField {
  SqlField(this.fieldName, this.type, {this.isPrimaryKey = false});

  final String fieldName;
  final DataType type;
  final bool isPrimaryKey;
}

enum DataType { string, integer, bool }
