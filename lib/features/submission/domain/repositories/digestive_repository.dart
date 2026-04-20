import "../models/digestive.dart";

abstract interface class DigestiveRepository {
  Stream<List<Digestive>> watchAll({int? submissionId});

  Stream<Digestive> watch(int id);

  Future<void> create(DigestiveInsertable digestive);

  Future<void> update(Digestive digestive);

  Future<void> delete(int id);

  Future<void> deleteBySubmissionId(int submissionId);
}
