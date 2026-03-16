// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'link_events_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ネイティブから送信される URI イベントの Stream を提供する。

@ProviderFor(linkEvents)
final linkEventsProvider = LinkEventsProvider._();

/// ネイティブから送信される URI イベントの Stream を提供する。

final class LinkEventsProvider
    extends $FunctionalProvider<AsyncValue<Uri>, Uri, Stream<Uri>>
    with $FutureModifier<Uri>, $StreamProvider<Uri> {
  /// ネイティブから送信される URI イベントの Stream を提供する。
  LinkEventsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'linkEventsProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$linkEventsHash();

  @$internal
  @override
  $StreamProviderElement<Uri> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Uri> create(Ref ref) {
    return linkEvents(ref);
  }
}

String _$linkEventsHash() => r'0d453181eead9fd650d4e49ad8a81de849d932b8';
