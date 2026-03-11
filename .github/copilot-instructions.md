# Copilot Instructions for Submon

Submon (提出物管理アプリ) is a Flutter app for managing school submissions, timetables, digestive schedules, and focus timers. It targets iOS, Android, and Web.

## Build & Run

Flutter version is pinned via FVM (see `.fvmrc`). Prefix flutter/dart commands with `fvm`.

```sh
# Install dependencies
fvm flutter pub get

# Lint
fvm flutter analyze

# Run all tests (CI creates an empty .env if missing: `touch .env`)
fvm flutter test

# Run a single test file
fvm flutter test test/widget_test.dart

# Code generation (Isar schemas → lib/generated/)
fvm dart run build_runner build --delete-conflicting-outputs

# Regenerate Pigeon platform channel code
./pigeon.sh   # outputs lib/src/pigeons.g.dart + native Kotlin/Swift files
```

## Architecture

### Data Layer: Offline-First with Dual Databases

Local data lives in **Isar** (community edition); the server source-of-truth is **Cloud Firestore**. The sync flow:

- **Read**: On app launch, `FirestoreProvider.fetchData()` compares timestamps and pulls changes into Isar.
- **Write**: `IsarProvider.put(data)` writes locally first, then syncs to Firestore and updates the server timestamp.
- **Delete**: Removes from Isar, then deletes the Firestore document.

Firestore path: `users/{uid}/submission/{id}`, `users/{uid}/digestive/{id}`, etc.

### Providers (lib/isar_db/)

`IsarProvider<T>` is the abstract base for all data providers (`SubmissionProvider`, `DigestiveProvider`, `TimetableProvider`, etc.). Each provider exposes `open()`, `use()`, `put()`, `delete()`, `getAll()`, and handles Firestore sync internally.

### Navigation

Named routes with `MaterialApp.onGenerateRoute`. Pages define `static const routeName`. Platform-adaptive transitions (Cupertino on iOS, Material on Android) via `generatePageRoute<T>()`.

### State Management

No framework (no Riverpod, GetX, Provider package, or Bloc). State is managed with `StatefulWidget` + manual callbacks and Firestore listeners.

### Platform Channels (Pigeon)

Native APIs (FCM tokens, OAuth custom tabs, DND control, widget updates) are accessed via Pigeon-generated type-safe interfaces defined in `pigeons/pigeons.dart`. Three host APIs: `MessagingApi`, `BrowserApi`, `GeneralApi`/`DndApi`.

### Firebase Services

Auth (Google, Apple, Email), Firestore, Cloud Functions (region: `asia-northeast1`), Analytics, Crashlytics, Dynamic Links, Performance Monitoring, and Google Mobile Ads.

### External Integrations

- **Google Tasks API**: Syncs submissions to Google Tasks via `googleapis`.
- **Canvas LMS**: This integration has been deprecated. Remaining Canvas-related code is scheduled for removal — do not add new Canvas features or dependencies.

## Code Conventions

### Enforced by analysis_options.yaml

- **Double quotes** for all strings (`prefer_double_quotes`)
- **Relative imports** (`prefer_relative_imports`), ordered: `dart:` → `package:` → relative
- **`final` by default** for fields and locals (`prefer_final_fields`, `prefer_final_locals`)
- **Explicit return types** on all functions (`always_declare_return_types`)
- **No `async void`** (`avoid_void_async`) — use `Future<void>`
- **Trailing commas** enforced by `better_require_trailing_commas` plugin
- **Newline at EOF** (`eol_at_end_of_file`)

### Generated code

- Isar schemas output to `lib/generated/` (configured in `build.yaml`). These `*.g.dart` files are excluded from analysis.
- Pigeon outputs to `lib/src/pigeons.g.dart` + native platform files.
- Never edit generated files directly.

### Isar Model Pattern

All Isar models follow this structure:

```dart
part "generated/isar_db/isar_example.g.dart";

@Collection()
class Example {
  Id? id;
  late String title;
  // ...
  Map<String, dynamic> toMap() { /* for Firestore serialization */ }
  Example.fromMap(Map<String, dynamic> map) { /* from Firestore */ }
}
```

### Environment

App config is loaded from `.env` via `flutter_dotenv`. The `.env` file is listed in `pubspec.yaml` assets but not committed to git. For tests, an empty `.env` file suffices.

## CI/CD

- **Test & Lint** (`test.yaml`): Runs `fvm flutter analyze` + `fvm flutter test` on push to `main` and PRs.
- **Deploy Web** (`deploy-web.yml`): Builds and deploys to Firebase Hosting on push to `web` branch.
- **Deploy Apps** (`deploy-apps.yml`): Triggered by `v*` tags. Builds and deploys to App Store and Play Store via reusable workflows and Fastlane.

## Language

UI strings are currently hardcoded in Japanese. `flutter_localizations` and `intl` are imported but ARB-based localization is not yet implemented.
