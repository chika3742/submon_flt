import "../models/submission.dart";

abstract interface class SubmissionRepository {
  Stream<List<Submission>> watchAll({bool done = false});

  Stream<Submission> watch(int id);

  Future<void> create(SubmissionInsertable submission);

  Future<void> update(Submission submission);

  Future<void> delete(int id);
}
