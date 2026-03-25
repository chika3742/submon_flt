// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_link_auth_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EmailLinkAuthNotifier)
final emailLinkAuthProvider = EmailLinkAuthNotifierProvider._();

final class EmailLinkAuthNotifierProvider
    extends $NotifierProvider<EmailLinkAuthNotifier, EmailLinkAuthState> {
  EmailLinkAuthNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'emailLinkAuthProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$emailLinkAuthNotifierHash();

  @$internal
  @override
  EmailLinkAuthNotifier create() => EmailLinkAuthNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EmailLinkAuthState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EmailLinkAuthState>(value),
    );
  }
}

String _$emailLinkAuthNotifierHash() =>
    r'9daca8811551e90c880dc2c2689173c4ec0d853a';

abstract class _$EmailLinkAuthNotifier extends $Notifier<EmailLinkAuthState> {
  EmailLinkAuthState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<EmailLinkAuthState, EmailLinkAuthState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<EmailLinkAuthState, EmailLinkAuthState>,
        EmailLinkAuthState,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
