///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsEnUs extends Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsEnUs({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.enUs,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		super.$meta.setFlatMapFunction($meta.getTranslation); // copy base translations to super.$meta
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en-US>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	late final TranslationsEnUs _root = this; // ignore: unused_field

	// Translations
	@override late final _TranslationsPagesEnUs pages = _TranslationsPagesEnUs._(_root);
}

// Path: pages
class _TranslationsPagesEnUs extends TranslationsPagesJa {
	_TranslationsPagesEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get submissions => 'Submissions';
	@override String get digestives => 'Digestives';
	@override String get timetable => 'Timetable';
	@override String get more => 'More';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on TranslationsEnUs {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'pages.submissions': return 'Submissions';
			case 'pages.digestives': return 'Digestives';
			case 'pages.timetable': return 'Timetable';
			case 'pages.more': return 'More';
			default: return null;
		}
	}
}

