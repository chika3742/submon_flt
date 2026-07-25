// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_in_page_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SignInPageViewModelNotifier)
final signInPageViewModelProvider = SignInPageViewModelNotifierProvider._();

final class SignInPageViewModelNotifierProvider
    extends
        $NotifierProvider<SignInPageViewModelNotifier, SignInPageViewModel> {
  SignInPageViewModelNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signInPageViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signInPageViewModelNotifierHash();

  @$internal
  @override
  SignInPageViewModelNotifier create() => SignInPageViewModelNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SignInPageViewModel value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SignInPageViewModel>(value),
    );
  }
}

String _$signInPageViewModelNotifierHash() =>
    r'40e632b9e9570542148a1259aebf54acf87982f5';

abstract class _$SignInPageViewModelNotifier
    extends $Notifier<SignInPageViewModel> {
  SignInPageViewModel build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SignInPageViewModel, SignInPageViewModel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SignInPageViewModel, SignInPageViewModel>,
              SignInPageViewModel,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
