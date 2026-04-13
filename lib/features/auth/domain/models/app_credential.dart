sealed class AppCredential {
  const AppCredential();
}

class GoogleAppCredential extends AppCredential {
  final String? idToken;

  const GoogleAppCredential({required this.idToken});
}

class AppleAppCredential extends AppCredential {
  final String accessToken;
  final String? idToken;
  final String rawNonce;

  const AppleAppCredential({
    required this.accessToken,
    required this.idToken,
    required this.rawNonce,
  });
}

class EmailLinkAppCredential extends AppCredential {
  final String email;
  final String emailLink;

  const EmailLinkAppCredential({required this.email, required this.emailLink});
}

class EmailPasswordAppCredential extends AppCredential {
  final String email;
  final String password;

  const EmailPasswordAppCredential({
    required this.email,
    required this.password,
  });
}
