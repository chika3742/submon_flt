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

final class LinkEventsProvider extends $FunctionalProvider<
        AsyncValue<Distinguish<Uri>>,
        Distinguish<Uri>,
        Stream<Distinguish<Uri>>>
    with $FutureModifier<Distinguish<Uri>>, $StreamProvider<Distinguish<Uri>> {
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
  $StreamProviderElement<Distinguish<Uri>> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Distinguish<Uri>> create(Ref ref) {
    return linkEvents(ref);
  }
}

String _$linkEventsHash() => r'f029f9eebf350bfc42bd073601de14ca9775b83c';
