import 'package:isar/isar.dart';
import 'package:submon/isar_db/isar_provider.dart';

part '../generated/isar_db/isar_timetable_class_time.g.dart';

@Collection()
class TimetableClassTime {
  @Id()
  late int period;
  late int start;
  late int end;

  TimetableClassTime();
}

class TimetableClassTimeProvider extends IsarProvider<TimetableClassTime> {
  @override
  Future<void> deleteFirestore(int id) {
    // TODO: implement deleteFirestore
    throw UnimplementedError();
  }

  @override
  Future<void> setFirestore(TimetableClassTime data) {
    // TODO: implement setFirestore
    throw UnimplementedError();
  }

  @override
  Future<void> use(
      Future<void> Function(TimetableClassTime provider) callback) {
    // TODO: implement use
    throw UnimplementedError();
  }
}
