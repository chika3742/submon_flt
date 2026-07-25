import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../infrastructure/core_providers.dart";
import "../../../infrastructure/firebase_providers.dart";
import "../../../infrastructure/firestore_error_notifier.dart";
import "../../../infrastructure/firestore_providers.dart";
import "timetable_class_time_repository.dart";
import "timetable_repository.dart";
import "timetable_table_repository.dart";

part "timetable_providers.g.dart";

@riverpod
TimetableRepository timetableRepository(Ref ref) {
  final isar = ref.watch(isarProvider).requireValue;
  final firestore =
      ref.watch(firestoreCollectionProvider("timetable").notifier);
  final crashlytics = ref.watch(crashlyticsProvider);
  return TimetableRepository(
    isar,
    firestore,
    crashlytics,
    ref.watch(firestoreErrorProvider.notifier),
  );
}

@riverpod
TimetableTableRepository timetableTableRepository(Ref ref) {
  final isar = ref.watch(isarProvider).requireValue;
  final firestore =
      ref.watch(firestoreCollectionProvider("timetable").notifier);
  final crashlytics = ref.watch(crashlyticsProvider);
  return TimetableTableRepository(
    isar,
    firestore,
    crashlytics,
    ref.watch(firestoreErrorProvider.notifier),
  );
}

@riverpod
TimetableClassTimeRepository timetableClassTimeRepository(Ref ref) {
  final isar = ref.watch(isarProvider).requireValue;
  final firestore =
      ref.watch(firestoreCollectionProvider("timetableClassTime").notifier);
  final crashlytics = ref.watch(crashlyticsProvider);
  return TimetableClassTimeRepository(
    isar,
    firestore,
    crashlytics,
    ref.watch(firestoreErrorProvider.notifier),
  );
}
