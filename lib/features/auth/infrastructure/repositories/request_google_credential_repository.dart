import "package:google_sign_in/google_sign_in.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../../core/result/result.dart";
import "../../../logging/domain/error_reporter.dart";
import "../../../logging/infrastructure/crashlytics.dart";
import "../../domain/models/app_credential.dart";
import "../../domain/models/auth_failure.dart";
import "../../domain/repositories/request_credential_repository.dart";

part "request_google_credential_repository.g.dart";

class RequestGoogleCredentialRepository implements RequestCredentialRepository {
  final ErrorReporter _reporter;

  RequestGoogleCredentialRepository(this._reporter);

  final _googleSignIn = GoogleSignIn.instance;

  @override
  ResultFuture<AppCredential?, AuthFailure> request() async {
    await _googleSignIn.signOut(); // sign out before signing in

    final GoogleSignInAccount googleUser;
    try {
      googleUser = await _googleSignIn.authenticate();
    } on GoogleSignInException catch (e, st) {
      switch (e.code) {
        case GoogleSignInExceptionCode.canceled:
          return Result.ok(null);
        default:
          _reporter.report(e, st);
          return Result.failed(AuthFailure(AuthFailureCode.unknown));
      }
    }

    return Result.ok(GoogleAppCredential(
      idToken: googleUser.authentication.idToken,
    ));
  }
}

@riverpod
RequestGoogleCredentialRepository requestGoogleCredentialRepository(Ref ref) {
  return RequestGoogleCredentialRepository(
    ref.watch(errorReporterProvider),
  );
}
