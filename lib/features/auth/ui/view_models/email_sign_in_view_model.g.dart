// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_sign_in_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EmailSignInViewModel)
final emailSignInViewModelProvider = EmailSignInViewModelProvider._();

final class EmailSignInViewModelProvider
    extends $NotifierProvider<EmailSignInViewModel, EmailSignInPageState> {
  EmailSignInViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'emailSignInViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$emailSignInViewModelHash();

  @$internal
  @override
  EmailSignInViewModel create() => EmailSignInViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EmailSignInPageState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EmailSignInPageState>(value),
    );
  }
}

String _$emailSignInViewModelHash() =>
    r'ceb8a291aa8e3ba7ab13bff1ee85f321e42702d0';

abstract class _$EmailSignInViewModel extends $Notifier<EmailSignInPageState> {
  EmailSignInPageState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<EmailSignInPageState, EmailSignInPageState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<EmailSignInPageState, EmailSignInPageState>,
              EmailSignInPageState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
