---
name: flutter-riverpod-architecture
description: >
  Flutter アプリのアーキテクチャ設計と Riverpod を用いた状態管理の実装ガイド。
  Flutter 公式推奨の MVVM + Repository パターン、Clean Architecture の層設計、
  Riverpod 3.0 の Notifier / AsyncNotifier / StreamNotifier API、
  コード生成（riverpod_generator）、テスト戦略、例外処理パターンを網羅する。
  以下のいずれかの文脈で必ずこの Skill を参照すること：
  - Flutter アプリの設計・ディレクトリ構造・レイヤー分割について質問・実装するとき
  - Riverpod の Provider 種別・Notifier・ref.watch/read の使い分けについて質問・実装するとき
  - Repository / UseCase / ViewModel の設計・インターフェース注入について質問するとき
  - Riverpod を使ったテスト（ProviderContainer / Mockito）について質問するとき
  - StateNotifier / Provider（旧 API）の移行や比較について質問するとき
---

# Flutter アーキテクチャ & Riverpod 状態管理 Skill

> 対象バージョン: Flutter 3.x / Dart 3.x / Riverpod 3.0（2025年9月リリース）

---

## 1. アーキテクチャ全体像

Flutter 公式（flutter.dev）は **MVVM + Repository パターン**を推奨する。
層は大きく **UI 層** と **データ層** に分かれ、大規模アプリでは **Domain 層（UseCase）** を追加する。

```
┌─────────────────────────────────────┐
│           UI 層                      │
│  View（Widget）  ←→  ViewModel       │
│  （ConsumerWidget）   （Notifier）    │
└──────────────┬──────────────────────┘
               │ 依存（抽象インターフェース）
┌──────────────▼──────────────────────┐
│        Domain 層（任意）             │
│  UseCase  /  Entity  /  Repository IF│
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│        データ層                      │
│  Repository（実装）  ←→  DataSource  │
│  （Remote API / Local DB / Cache）   │
└─────────────────────────────────────┘
```

### 依存方向の鉄則
- 上位層は **下位層の抽象（インターフェース）にのみ依存**する
- 下位層は上位層を知らない
- Repository 同士は直接依存しない（必要なら UseCase 経由）

---

## 2. ディレクトリ構造

Feature-First（機能単位）構成が 2025 年のデファクト。

```
lib/
├── main.dart
├── core/                    # 全機能横断の共通コード
│   ├── error/               # 例外・Failure クラス
│   ├── network/             # HTTP クライアント設定
│   └── utils/
├── features/
│   └── {feature_name}/
│       ├── data/
│       │   ├── datasource/  # Remote / Local DataSource
│       │   ├── model/       # DTO（JSON マッピング付き）
│       │   └── repository/  # Repository 実装
│       ├── domain/          # （任意）UseCase / Entity / Repository IF
│       └── presentation/
│           ├── provider/    # Riverpod Notifier / Provider 定義
│           ├── screen/      # ページ Widget（ConsumerWidget）
│           └── widget/      # 再利用 Widget
└── shared/                  # 複数 feature で共有する Widget / Provider
```

---

## 3. 各層の責務と実装パターン

### 3-1. DataSource（最下層）

外部との通信のみ担当。例外はここで `AppException` に変換する。

```dart
abstract interface class UserRemoteDataSource {
  Future<UserDto> fetchUser(String id);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio _dio;
  UserRemoteDataSourceImpl(this._dio);

  @override
  Future<UserDto> fetchUser(String id) async {
    try {
      final res = await _dio.get('/users/$id');
      return UserDto.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw AppException.fromDioException(e);
    }
  }
}
```

### 3-2. Repository（データ層の窓口）

- DataSource を束ね、キャッシュ戦略を持つ
- 返り値は **Domain Entity**（DTO ではない）
- インターフェースを定義し、Notifier はインターフェースに依存させる（テスト可能性）

```dart
abstract interface class UserRepository {
  Future<User> getUser(String id);
  Stream<List<User>> watchUsers();
}

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _remote;
  UserRepositoryImpl(this._remote);

  @override
  Future<User> getUser(String id) async {
    final dto = await _remote.fetchUser(id);
    return dto.toDomain(); // DTO → Entity 変換
  }

  @override
  Stream<List<User>> watchUsers() { /* ... */ }
}
```

### 3-3. ViewModel = Riverpod Notifier（UI 層）

詳細は §4 Riverpod 参照。

### 3-4. View（Widget）

- ロジックを持たない「表示専用」を目指す
- `ref.watch` で状態を購読、ユーザーアクションは `ref.read(...notifier).method()` で委譲

---

## 4. Riverpod 3.0 状態管理

> ⚠️ Riverpod 3.0（2025/09 リリース）で大きな API 変更あり。詳細は `references/riverpod3.md` を参照。

### 4-1. Provider 種別の選択基準

| やりたいこと | 使う Provider |
|---|---|
| 依存注入（Repository 等の生成） | `Provider` |
| 同期的な状態 + ミューテーション | `NotifierProvider` |
| 非同期データ取得 + ミューテーション | `AsyncNotifierProvider` |
| Stream の購読 + ミューテーション | `StreamNotifierProvider` |
| 読み取り専用の非同期データ | `FutureProvider`（シンプルな場合のみ） |

**StateNotifier / StateNotifierProvider / StateProvider / ChangeNotifierProvider は Riverpod 3.0 でレガシー化。新規コードでは使わない。**

### 4-2. Notifier（同期状態）

```dart
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0; // 初期値

  void increment() => state++;
  void decrement() => state--;
}
```

### 4-3. AsyncNotifier（非同期状態）

```dart
@riverpod
class UserList extends _$UserList {
  @override
  Future<List<User>> build() async {
    // ref.watch で Repository を取得（DI）
    final repo = ref.watch(userRepositoryProvider);
    return repo.getUsers();
  }

  Future<void> refresh() async {
    // 既存データを保持しつつローディング表示
    state = const AsyncLoading<List<User>>().copyWithPrevious(state);
    state = await AsyncValue.guard(() => ref.read(userRepositoryProvider).getUsers());
  }

  Future<void> addUser(User user) async {
    // 楽観的更新パターン
    final previous = state;
    state = AsyncData([...?state.valueOrNull, user]);
    try {
      await ref.read(userRepositoryProvider).createUser(user);
    } catch (e, st) {
      state = previous; // ロールバック
      Error.throwWithStackTrace(e, st);
    }
  }
}
```

### 4-4. StreamNotifier（ストリーム + ミューテーション）

```dart
@riverpod
class MessageStream extends _$MessageStream {
  @override
  Stream<List<Message>> build(String roomId) {
    final repo = ref.watch(messageRepositoryProvider);
    return repo.watchMessages(roomId);
  }

  Future<void> sendMessage(String text) async {
    await ref.read(messageRepositoryProvider).send(roomId: arg, text: text);
    // StreamNotifier は Stream が自動更新するため state の手動操作は不要なことが多い
  }
}
```

### 4-5. ref.watch vs ref.read

| 使う場面 | 使うメソッド |
|---|---|
| Widget の `build` 内で状態を購読 | `ref.watch` |
| Notifier の `build` 内で依存 Provider を購読 | `ref.watch` |
| コールバック・ボタン押下時などのアクション内 | `ref.read` |
| Notifier 内のメソッドで他 Provider を参照 | `ref.read`（副作用の起点）|

**`ref.watch` をコールバック内で使ってはいけない（再ビルド外での購読は予期しない動作を引き起こす）。**

### 4-6. family（引数付き Provider）

Riverpod 3.0 では `FamilyAsyncNotifier` が廃止され、`build()` に引数を直接定義する。

```dart
@riverpod
class UserDetail extends _$UserDetail {
  @override
  Future<User> build(String userId) async { // ← 引数は build に直接書く
    return ref.watch(userRepositoryProvider).getUser(userId);
  }
}

// 使用側
final user = ref.watch(userDetailProvider('user-123'));
```

### 4-7. keepAlive / autoDispose

Riverpod 3.0 では全 Provider がデフォルト `autoDispose`（リスナーが 0 になると破棄）。
状態を保持したい場合は `keepAlive: true` を指定。

```dart
@Riverpod(keepAlive: true)
class AuthState extends _$AuthState { /* ... */ }
```

---

## 5. 依存注入（DI）パターン

Repository のインターフェースを Provider で提供し、Notifier はインターフェースに依存させる。
テスト時は `ProviderContainer` の `overrides` で Mock に差し替える。

```dart
// Provider 定義（本番）
@riverpod
UserRepository userRepository(Ref ref) {
  return UserRepositoryImpl(ref.watch(userRemoteDataSourceProvider));
}

// ViewModel は抽象に依存
@riverpod
class UserList extends _$UserList {
  @override
  Future<List<User>> build() async {
    return ref.watch(userRepositoryProvider).getUsers(); // IF に依存
  }
}

// テスト
final container = ProviderContainer(
  overrides: [
    userRepositoryProvider.overrideWithValue(MockUserRepository()),
  ],
);
```

---

## 6. 例外処理パターン

### AsyncValue での一元管理

```dart
// UI 側：AsyncValue のパターンマッチングで網羅的に処理
ref.watch(userListProvider).when(
  data: (users) => UserListWidget(users),
  loading: () => const CircularProgressIndicator(),
  error: (e, st) => ErrorWidget(e),
);

// または switch 式（Dart 3）
return switch (ref.watch(userListProvider)) {
  AsyncData(:final value) => UserListWidget(value),
  AsyncError(:final error) => ErrorWidget(error),
  _ => const CircularProgressIndicator(),
};
```

### Notifier 内の例外処理

```dart
Future<void> deleteUser(String id) async {
  try {
    await ref.read(userRepositoryProvider).deleteUser(id);
    // 成功: state を更新
    state = AsyncData(state.requireValue.where((u) => u.id != id).toList());
  } on AppException catch (e) {
    // 失敗: UI に通知（状態は変えない）
    state = AsyncError(e, StackTrace.current);
  }
}
```

---

## 7. テスト戦略

詳細は `references/testing.md` を参照。

### Notifier の単体テスト（ProviderContainer）

```dart
void main() {
  late ProviderContainer container;
  late MockUserRepository mockRepo;

  setUp(() {
    mockRepo = MockUserRepository();
    container = ProviderContainer(
      overrides: [userRepositoryProvider.overrideWithValue(mockRepo)],
    );
  });
  tearDown(() => container.dispose());

  test('ユーザー一覧を取得できる', () async {
    when(mockRepo.getUsers()).thenAnswer((_) async => [testUser]);

    final result = await container.read(userListProvider.future);
    expect(result, [testUser]);
  });
}
```

---

## 8. チェックリスト（設計レビュー用）

- [ ] View（Widget）にビジネスロジックが混入していないか
- [ ] Repository はインターフェース経由で参照されているか
- [ ] Repository 同士が直接依存していないか
- [ ] `ref.watch` をコールバック内で使っていないか
- [ ] StateNotifier など旧 API を使っていないか
- [ ] 例外は DataSource レベルで `AppException` に変換されているか
- [ ] AsyncNotifier で状態が `AsyncLoading` / `AsyncData` / `AsyncError` の 3 状態を適切に扱っているか
- [ ] keepAlive が必要な Provider を適切に設定しているか

---

## 参照ファイル

詳細な情報が必要な場合は以下を `view` で読み込むこと：

- `references/riverpod3.md` — Riverpod 3.0 の変更点・移行ガイド・旧 API との比較
- `references/testing.md` — Riverpod + Mockito によるテスト詳細パターン
