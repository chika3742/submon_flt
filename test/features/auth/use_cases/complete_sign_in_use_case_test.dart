// Firestore's DocumentReference/DocumentSnapshot are sealed, but they must be
// implemented to mock them with mocktail. Also, the typed fallback function
// values cannot be function declarations, so suppress these lints.
// ignore_for_file: subtype_of_sealed_class, prefer_function_declarations_over_variables

import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:isar_community/isar.dart";
import "package:mocktail/mocktail.dart";
import "package:submon/features/auth/use_cases/complete_sign_in_use_case.dart";
import "package:submon/infrastructure/firestore_providers.dart";
import "package:submon/infrastructure/pref_provider.dart";
import "package:submon/src/pigeons.g.dart";
import "package:submon/user_config.dart";

class MockPref extends Mock implements PrefAccessor<int?> {}

/// Isar.writeTxn is a generic method that is hard to mock, so use a Fake.
/// writeTxn runs the callback and records that clear was called.
class FakeIsar extends Fake implements Isar {
  bool cleared = false;

  @override
  Future<T> writeTxn<T>(Future<T> Function() callback, {bool silent = false}) {
    return callback();
  }

  @override
  Future<void> clear() async {
    cleared = true;
  }
}

class MockMessagingApi extends Mock implements MessagingApi {}

class MockGeneralApi extends Mock implements GeneralApi {}

class MockUserConfigUpdater extends Mock implements FirestoreUserConfigUpdater {}

class MockUserDoc extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

class MockConvertedDoc extends Mock implements DocumentReference<UserConfig> {}

class MockSnapshot extends Mock implements DocumentSnapshot<UserConfig> {}

void main() {
  setUpAll(() {
    final FromFirestore<UserConfig> fromFirestore =
        (snapshot, options) => const UserConfig();
    final ToFirestore<UserConfig> toFirestore =
        (value, options) => <String, dynamic>{};
    final Future<void> Function() txnCallback = () async {};
    registerFallbackValue(fromFirestore);
    registerFallbackValue(toFirestore);
    registerFallbackValue(txnCallback);
  });

  late MockPref pref;
  late FakeIsar isar;
  late MockMessagingApi messagingApi;
  late MockGeneralApi generalApi;
  late MockUserConfigUpdater userConfigUpdater;

  setUp(() {
    pref = MockPref();
    isar = FakeIsar();
    messagingApi = MockMessagingApi();
    generalApi = MockGeneralApi();
    userConfigUpdater = MockUserConfigUpdater();

    when(() => pref.update(any())).thenReturn(null);
    when(() => messagingApi.getToken()).thenAnswer((_) async => "fcm-token");
    when(() => userConfigUpdater.saveNotificationToken(any()))
        .thenAnswer((_) async {});
    when(() => userConfigUpdater.initializeUser()).thenAnswer((_) async {});
    when(() => generalApi.updateWidgets()).thenAnswer((_) async {});
  });

  CompleteSignInUseCase buildUseCase(
      DocumentReference<Map<String, dynamic>>? userDoc) {
    return CompleteSignInUseCase(
      pref,
      isar,
      messagingApi,
      generalApi,
      userConfigUpdater,
      userDoc,
    );
  }

  test("_userDoc == null -> treats as existing user and runs common steps",
      () async {
    final result = await buildUseCase(null).execute();

    expect(result.newUser, isFalse);
    expect(result.notificationPermissionDenied, isFalse);
    verifyNever(() => userConfigUpdater.initializeUser());
    verify(() => pref.update(null)).called(1);
    expect(isar.cleared, isTrue); // clear is called inside writeTxn
    verify(() => userConfigUpdater.saveNotificationToken("fcm-token")).called(1);
    verify(() => generalApi.updateWidgets()).called(1);
  });

  test("permission-denied -> initializes a new user and newUser=true", () async {
    final userDoc = MockUserDoc();
    final convertedDoc = MockConvertedDoc();
    when(() => userDoc.withConverter<UserConfig>(
          fromFirestore: any(named: "fromFirestore"),
          toFirestore: any(named: "toFirestore"),
        )).thenReturn(convertedDoc);
    when(() => convertedDoc.get()).thenThrow(
      FirebaseException(plugin: "cloud_firestore", code: "permission-denied"),
    );

    final result = await buildUseCase(userDoc).execute();

    expect(result.newUser, isTrue);
    verify(() => userConfigUpdater.initializeUser()).called(1);
  });

  test("FirebaseException other than permission-denied -> CompleteSignInException",
      () async {
    final userDoc = MockUserDoc();
    final convertedDoc = MockConvertedDoc();
    when(() => userDoc.withConverter<UserConfig>(
          fromFirestore: any(named: "fromFirestore"),
          toFirestore: any(named: "toFirestore"),
        )).thenReturn(convertedDoc);
    when(() => convertedDoc.get()).thenThrow(
      FirebaseException(plugin: "cloud_firestore", code: "unavailable"),
    );

    expect(
      () => buildUseCase(userDoc).execute(),
      throwsA(isA<CompleteSignInException>()),
    );
    verifyNever(() => userConfigUpdater.initializeUser());
  });

  test("requests permission when userConfig has notifications; true when denied",
      () async {
    final userDoc = MockUserDoc();
    final convertedDoc = MockConvertedDoc();
    final snapshot = MockSnapshot();
    when(() => userDoc.withConverter<UserConfig>(
          fromFirestore: any(named: "fromFirestore"),
          toFirestore: any(named: "toFirestore"),
        )).thenReturn(convertedDoc);
    when(() => convertedDoc.get()).thenAnswer((_) async => snapshot);
    when(() => snapshot.data()).thenReturn(
      const UserConfig(reminderNotificationTime: TimeOfDay(hour: 8, minute: 0)),
    );
    when(() => messagingApi.requestNotificationPermission()).thenAnswer(
      (_) async => NotificationPermissionStateWrapper(
        value: NotificationPermissionState.denied,
      ),
    );

    final result = await buildUseCase(userDoc).execute();

    expect(result.newUser, isFalse);
    expect(result.notificationPermissionDenied, isTrue);
    verify(() => messagingApi.requestNotificationPermission()).called(1);
  });

  test("does not request permission when userConfig has none (denied=false)",
      () async {
    final userDoc = MockUserDoc();
    final convertedDoc = MockConvertedDoc();
    final snapshot = MockSnapshot();
    when(() => userDoc.withConverter<UserConfig>(
          fromFirestore: any(named: "fromFirestore"),
          toFirestore: any(named: "toFirestore"),
        )).thenReturn(convertedDoc);
    when(() => convertedDoc.get()).thenAnswer((_) async => snapshot);
    // UserConfig with no notification settings
    when(() => snapshot.data()).thenReturn(const UserConfig());

    final result = await buildUseCase(userDoc).execute();

    expect(result.newUser, isFalse);
    expect(result.notificationPermissionDenied, isFalse);
    verifyNever(() => messagingApi.requestNotificationPermission());
  });
}
