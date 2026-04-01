// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'link_social_use_case.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(linkSocialUseCase)
final linkSocialUseCaseProvider = LinkSocialUseCaseProvider._();

final class LinkSocialUseCaseProvider
    extends
        $FunctionalProvider<
          LinkSocialUseCase,
          LinkSocialUseCase,
          LinkSocialUseCase
        >
    with $Provider<LinkSocialUseCase> {
  LinkSocialUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'linkSocialUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$linkSocialUseCaseHash();

  @$internal
  @override
  $ProviderElement<LinkSocialUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LinkSocialUseCase create(Ref ref) {
    return linkSocialUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LinkSocialUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LinkSocialUseCase>(value),
    );
  }
}

String _$linkSocialUseCaseHash() => r'2839bbb2775bd517b847d3b8be26386fcce3ab3c';
