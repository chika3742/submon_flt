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

# Code generation (freezed, riverpod_generator, Isar schemas)
fvm dart run build_runner build --delete-conflicting-outputs

# Regenerate Pigeon platform channel code
./pigeon.sh   # outputs lib/src/pigeons.g.dart + native Kotlin/Swift files
```

## Architecture

### State Management: Riverpod

State management uses **Riverpod** with `riverpod_generator` and `riverpod_lint`. All new providers use `@riverpod` or `@Riverpod(keepAlive: true)` annotations. Widgets are `ConsumerWidget` or `ConsumerStatefulWidget`.

Key provider files live in `lib/providers/`:
- `core_providers.dart` — Isar, SharedPrefs, FirebaseAuth, GoogleSignIn, Crashlytics, Analytics
- `firestore_providers.dart` — Firestore collection/user references
- `submission_providers.dart`, `digestive_providers.dart`, `timetable_providers.dart` — Repository providers + data stream watchers
- `data_sync_service.dart` — Firestore → Isar sync on app launch
- `link_events_provider.dart` — Deep link event stream

**SharedPreferences** are accessed via `PrefNotifier<T>` with `PrefKey` enum (`lib/core/pref_key.dart`). Use `ref.watchPref(PrefKey.xxx)` / `ref.readPref(PrefKey.xxx)` / `ref.updatePref(PrefKey.xxx, value)`.

### Data Layer: Offline-First with Isar + Firestore

Local data lives in **Isar** (community edition); the server source-of-truth is **Cloud Firestore**.

**Repository pattern** (`lib/repositories/`):
- `SyncedRepository<T>` is the abstract base class that auto-syncs writes to Firestore.
- `SubmissionRepository`, `DigestiveRepository` extend `SyncedRepository<T>`.
- `TimetableRepository`, `TimetableTableRepository`, `TimetableClassTimeRepository` use custom sync patterns.
- Repository's `put()` / `delete()` are `@protected`. External callers use purpose-specific public methods (e.g., `create`, `update`, `markDone`). Always separate create vs update methods.

**Sync flow** (via `DataSyncService`):
- On app launch, `DataSyncService` compares Firestore timestamps and pulls changes into Isar.
- Writes go to Isar first, then sync to Firestore automatically via `SyncedRepository`.

Firestore path: `users/{uid}/submission/{id}`, `users/{uid}/digestive/{id}`, etc.

**Isar models** are defined in `lib/isar_db/` (model classes only — no provider logic). Each file contains the `@Collection()` annotated class with `toMap()` / `fromMap()` for Firestore serialization.

### Auth: Clean Architecture (`lib/features/auth/`)

```
lib/features/auth/
├── models/
│   ├── auth_exception.dart          ← AuthErrorCode enum (userFriendlyMessage)
│   └── auth_continue_destination.dart ← freezed: Email link → route mapping
├── repositories/
│   └── auth_repository.dart         ← Firebase Auth wrapper (interface + impl)
├── use_cases/
│   ├── common.dart                  ← AuthMode enum (signIn/reauthenticate/upgrade)
│   ├── social_auth_use_case.dart    ← Google/Apple credential → auth
│   ├── sign_out_use_case.dart       ← Token cleanup → signOut → widget update
│   ├── complete_sign_in_use_case.dart ← Post-login setup (Isar, notifications, user doc)
│   └── email_link_auth_use_case.dart  ← Email link auth flow
└── presentation/
    ├── sign_in_state_notifier.dart   ← freezed sealed SignInState + NotifierStateGuard
    ├── email_link_auth_notifier.dart ← keepAlive, listens to deep links
    ├── auth_action_notifier.dart     ← keepAlive, verifyAndChangeEmail handler
    ├── account_link_notifier.dart    ← Account linking state
    └── auth_messages.dart            ← Shared message utility (signInSuccessMessage, authErrorMessage)
```

**Key patterns:**
- **No BuildContext in Notifiers** — UI navigation/display logic stays in widgets or `main.dart`.
- **NotifierStateGuard mixin** — Standardized error handling in async Notifier methods.
- **freezed sealed classes** — Used for auth state machines (e.g., `SignInState`, `EmailLinkAuthState`).

### Navigation

Named routes with `MaterialApp.onGenerateRoute`. Pages define `static const routeName`. Platform-adaptive transitions (Cupertino on iOS, Material on Android) via `generatePageRoute<T>()`.

### Platform Channels (Pigeon)

Native APIs (FCM tokens, OAuth custom tabs, DND control, widget updates) are accessed via Pigeon-generated type-safe interfaces defined in `pigeons/pigeons.dart`. Three host APIs: `MessagingApi`, `BrowserApi`, `GeneralApi`/`DndApi`.

### Firebase Services

Auth (Google, Apple, Email), Firestore, Cloud Functions (region: `asia-northeast1`), Analytics, Crashlytics, Performance Monitoring, and Google Mobile Ads.

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
- **`riverpod_lint`** enabled for Riverpod best practices

### Generated code

- `*.g.dart` files are generated by `build_runner` (freezed, riverpod_generator, Isar schemas). Excluded from analysis via `analyzer.exclude: - lib/**.g.dart`.
- Pigeon outputs to `lib/src/pigeons.g.dart` + native platform files.
- Never edit generated files directly.

### Isar Model Pattern

All Isar models live in `lib/isar_db/` and follow this structure:

```dart
part "isar_example.g.dart";

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

## Known Technical Debt

- **`globalContext`**: Deprecated but still used in ~6 files. Should be replaced with widget tree `context`.
- **`EventBus`**: 1 active usage (`SwitchBottomNav`). Will be replaced when `go_router` is introduced.
- **Some pages remain `StatefulWidget`** without Riverpod — incremental migration ongoing.

## CI/CD

- **Test & Lint** (`test.yaml`): Runs `fvm flutter analyze` + `fvm flutter test` on push to `main` and PRs.
- **Deploy Web** (`deploy-web.yml`): Builds and deploys to Firebase Hosting on push to `web` branch.
- **Deploy Apps** (`deploy-apps.yml`): Triggered by `v*` tags. Builds and deploys to App Store and Play Store via reusable workflows and Fastlane.

## Language

UI strings are currently hardcoded in Japanese. `flutter_localizations` and `intl` are imported but ARB-based localization is not yet implemented.
