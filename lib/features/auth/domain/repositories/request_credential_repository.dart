import "../../../../core/result/result.dart";
import "../models/app_credential.dart";
import "../models/auth_failure.dart";

abstract interface class RequestCredentialRepository {
  const RequestCredentialRepository();

  /// Returns `null` if canceled.
  ResultFuture<AppCredential?, AuthFailure> request();
}
