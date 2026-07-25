import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";
import "package:submon/features/auth/repositories/auth_repository.dart";
import "package:submon/features/auth/use_cases/sign_out_use_case.dart";
import "package:submon/infrastructure/firestore_providers.dart";
import "package:submon/src/pigeons.g.dart";

class MockAuthRepository extends Mock implements AuthRepository {}

class MockMessagingApi extends Mock implements MessagingApi {}

class MockGeneralApi extends Mock implements GeneralApi {}

class MockUserConfigUpdater extends Mock
    implements FirestoreUserConfigUpdater {}

void main() {
  late MockAuthRepository authRepo;
  late MockMessagingApi messagingApi;
  late MockGeneralApi generalApi;
  late MockUserConfigUpdater userConfigUpdater;
  late SignOutUseCase useCase;

  setUp(() {
    authRepo = MockAuthRepository();
    messagingApi = MockMessagingApi();
    generalApi = MockGeneralApi();
    userConfigUpdater = MockUserConfigUpdater();
    useCase =
        SignOutUseCase(authRepo, messagingApi, generalApi, userConfigUpdater);

    when(() => messagingApi.getToken()).thenAnswer((_) async => "token-1");
    when(() => userConfigUpdater.removeNotificationToken(any()))
        .thenAnswer((_) async {});
    when(() => authRepo.signOut()).thenAnswer((_) async {});
    when(() => generalApi.updateWidgets()).thenAnswer((_) async {});
  });

  test("runs token removal -> sign out -> widget update in order", () async {
    await useCase.execute();

    verifyInOrder([
      () => messagingApi.getToken(),
      () => userConfigUpdater.removeNotificationToken("token-1"),
      () => authRepo.signOut(),
      () => generalApi.updateWidgets(),
    ]);
  });
}
