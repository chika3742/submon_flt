import 'package:isar/isar.dart';

part '../generated/isar_db/isar_memorization_card_group.g.dart';

@Collection()
class MemorizationCardGroup {
  Id? id;
  late String title;

  MemorizationCardGroup();
}
