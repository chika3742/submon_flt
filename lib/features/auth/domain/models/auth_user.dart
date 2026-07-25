import "package:freezed_annotation/freezed_annotation.dart";

import "social_provider.dart";

part "auth_user.freezed.dart";

@freezed
sealed class AuthUser with _$AuthUser {
  const factory AuthUser({
    required String? email,
    required bool hasEmailProvider,
    required List<SocialProvider> linkedProviders,
  }) = _AuthUser;
}
