import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:submon/isar_db/isar_digestive.dart';
import 'package:submon/isar_db/isar_memorization_card_group.dart';
import 'package:submon/isar_db/isar_submission.dart';
import 'package:submon/isar_db/isar_timetable.dart';
import 'package:submon/isar_db/isar_timetable_class_time.dart';
import 'package:submon/isar_db/isar_timetable_table.dart';
import 'package:submon/main.dart';
import 'package:submon/utils/ui.dart';
import 'package:submon/utils/utils.dart';

const schemaVersion = 5;

abstract class IsarProvider<T> {
  late Isar isar;

  IsarCollection<T> get collection => isar.getCollection<T>();

  Future<void> open() async {
    var instance = Isar.getInstance();
    if (instance != null) {
      isar = instance;
    } else {
      var dir = await getApplicationSupportDirectory();
      instance = await Isar.open(schemas: [
        SubmissionSchema,
        DigestiveSchema,
        TimetableSchema,
        TimetableClassTimeSchema,
        TimetableTableSchema,
        MemorizationCardGroupSchema,
      ], directory: dir.path);
      isar = instance;
    }
  }

  Future<void> use(Future<void> Function(dynamic provider) callback);

  ///
  /// オブジェクトを [id] で取得する。オブジェクトが存在しない場合は `null` を返す。
  ///
  Future<T?> get(int id) {
    return collection.get(id);
  }

  ///
  /// オブジェクト [data] を挿入または更新し、割り当てられた [id] を返す。Firestore上のデータも同様に挿入・更新する。
  ///
  Future<T> put(T data) async {
    _setFirestore(data);
    var id = await collection.put(data);
    return (data as dynamic)..id = id;
  }

  Future<void> delete(int id) {
    _deleteFirestore(id);
    return collection.delete(id);
  }

  ///
  /// オブジェクトのリスト [list] をすべて挿入または更新する。Firestore上のデータには影響を与えない。
  ///
  Future<void> putAllLocalOnly(List<T> list) {
    return collection.putAll(list);
  }

  Future<void> setFirestore(T data);

  Future<void> _setFirestore(T data) async {
    await _wrapUpdateFirestore(setFirestore(data));
  }

  Future<void> deleteFirestore(int id);

  Future<void> _deleteFirestore(int id) async {
    await _wrapUpdateFirestore(deleteFirestore(id));
  }

  Future<void> _wrapUpdateFirestore(Future future) async {
    await future.onError((e, st) {
      showSnackBar(Application.globalKey.currentContext!, "データの転送に失敗しました。");
      recordErrorToCrashlytics(e, st);
    });

    firestoreUpdated();
  }

  ///
  /// 本クラスからFirestoreのデータを更新した際に呼ばれる。
  ///
  void firestoreUpdated() {}

  ///
  /// 書き込みトランザクションを行う。
  ///
  Future<void> writeTransaction(Future<void> Function() transaction) {
    return isar.writeTxn((isar) async {
      await transaction();
    });
  }
}
