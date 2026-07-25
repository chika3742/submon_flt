import "../../../../core/result/result.dart";
import "../models/app_credential.dart";
import "../models/auth_failure.dart";
import "../models/auth_mode.dart";
import "../models/auth_user.dart";
import "../models/social_provider.dart";

abstract interface class AuthRepository {
  const AuthRepository();

  ResultFuture<void, AuthFailure> signIn(AppCredential credential);

  ResultFuture<void, AuthFailure> createTrialUser();

  ResultFuture<void, AuthFailure> reauthenticate(AppCredential credential);

  ResultFuture<void, AuthFailure> linkWithCredential(AppCredential credential);

  ResultFuture<void, AuthFailure> unlinkProvider(SocialProvider provider);

  ResultFuture<void, AuthFailure> sendSignInLinkToEmail(
    String email,
    AuthMode mode, [
    String? destinationAfterReAuth,
  ]);

  ResultFuture<void, AuthFailure> sendPasswordResetLink(String email);

  ResultFuture<void, AuthFailure> signOut();

  ResultFuture<void, AuthFailure> checkActionCode(String oobCode);

  ResultFuture<void, AuthFailure> verifyBeforeUpdateEmail(String newEmail);

  ResultFuture<void, AuthFailure> updateDisplayName(String displayName);

  ResultFuture<void, AuthFailure> deleteCurrentUser();

  Stream<AuthUser?> currentUser();
}
