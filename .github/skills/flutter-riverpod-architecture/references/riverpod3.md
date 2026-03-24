# Riverpod 3.0 詳細リファレンス

> Riverpod 3.0 は 2025年9月にリリース。2.x から移行する場合に必ず確認すること。

---

## ⚠️ コード生成: Provider 命名規則の変更（破壊的変更）

riverpod_generator 3.0 で `provider_name_strip_pattern` がデフォルト `"Notifier$"` に設定された。
クラス名の末尾が `Notifier` の場合、その文字列を除去した名前で Provider が生成される。

```dart
@riverpod
class CounterNotifier extends _$CounterNotifier { ... }

// 2.x: counterNotifierProvider が生成されていた
// 3.0: counterProvider が生成される ← 破壊的変更！
```

**影響範囲**: クラス名を `XxxNotifier` と命名していた全ての Provider。
参照箇所が一斉にビルドエラーになる。

### 対応方針（3択）

**① クラス名から `Notifier` を除去する（推奨）**

```dart
// Before
@riverpod
class UserListNotifier extends _$UserListNotifier { ... }
// → 生成: userListNotifierProvider（2.x）/ userListProvider（3.0 ← 意図通り）

// After（命名を変更して 3.0 の挙動に合わせる）
@riverpod
class UserList extends _$UserList { ... }
// → 生成: userListProvider（変わらない）
```

**② `build.yaml` で strip パターンを無効化して 2.x 互換にする**

```yaml
# build.yaml（プロジェクトルート）
targets:
  $default:
    builders:
      riverpod_generator:
        options:
          provider_name_strip_pattern: ""  # strip を無効化
```

これで `CounterNotifier` → `counterNotifierProvider` の 2.x 挙動を維持できる。

**③ `@Riverpod(name: 'myProvider')` で明示指定する**

```dart
@Riverpod(name: 'counter')
class CounterNotifier extends _$CounterNotifier { ... }
// → 生成: counterProvider（strip パターンに関わらず固定）
```

### build.yaml のデフォルト設定（3.0）

```yaml
targets:
  $default:
    builders:
      riverpod_generator:
        options:
          provider_name_prefix: ""           # プレフィックス
          provider_family_name_prefix: ""    # family 用プレフィックス
          provider_name_suffix: "Provider"   # サフィックス（"Pod" 等に変更可）
          provider_family_name_suffix: "Provider"
          provider_name_strip_pattern: "Notifier$"  # ← 3.0 で新追加（デフォルト有効）
```

---

## 主な変更点サマリー

| 項目 | 2.x | 3.0 |
|---|---|---|
| Ref の型 | `FutureProviderRef<T>`, `NotifierProviderRef` 等 | `Ref` に統一（型パラメータなし） |
| autoDispose | `.autoDispose` モディファイア / `AutoDisposeNotifier` | デフォルトが autoDispose、`isAutoDispose: true` パラメータ |
| Family Notifier | `FamilyAsyncNotifier<State, Arg>` | `AsyncNotifier` に統合（build に引数を直接定義） |
| 等値比較 | `identical`（参照比較） | `==`（等値比較）で再描画判定 |
| レガシー API | 通常 import で使用可能 | `package:flutter_riverpod/legacy.dart` からのみ |
| リスナー休止 | なし | 非表示 Widget のリスナーを自動で休止（TickerMode 連動） |
| 状態永続化 | 非公式パッケージ | `JsonSqFliteStorage` 等の実験的サポート |

---

## Ref の統一

```dart
// 2.x（旧）
@riverpod
Future<User> fetchUser(FetchUserRef ref, String id) async { ... }

// 3.0（新）
@riverpod
Future<User> fetchUser(Ref ref, String id) async { ... }
```

`WidgetRef` は変更なし。`Ref` と `WidgetRef` は別物。

---

## AutoDispose の変更

コード生成を使う場合：

```dart
// keepAlive: false（デフォルト）= autoDispose
@riverpod
class MyNotifier extends _$MyNotifier { ... }

// keepAlive: true = キャッシュ保持
@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier { ... }
```

手書きの場合（コード生成なし）：

```dart
// 3.0
final myProvider = Provider(
  (ref) => MyObject(),
  isAutoDispose: true,
);

// AutoDisposeNotifier → Notifier に置き換え可
class MyNotifier extends Notifier<int> { ... }  // AutoDispose不要
```

---

## Family の変更

`FamilyAsyncNotifier` / `FamilyNotifier` が廃止。`build()` に引数を直接受け取る。

```dart
// 2.x（旧）
class UserNotifier extends FamilyAsyncNotifier<User, String> {
  @override
  Future<User> build(String userId) async { ... }
}

// 3.0（新）—— コード生成使用
@riverpod
class UserDetail extends _$UserDetail {
  @override
  Future<User> build(String userId) async {
    return ref.watch(userRepositoryProvider).getUser(userId);
  }
}

// 呼び出し側は変わらず
final user = ref.watch(userDetailProvider('user-123'));
```

---

## == 等値比較への変更

3.0 から全 Provider が `identical` ではなく `==` で状態変化を判定する。

**影響範囲**：`Freezed` や `Equatable` を使っていないカスタムクラスの場合、
同じ内容でも新しいインスタンスが返ると再描画が起きる可能性がある。
→ **Entity / State クラスには `Freezed` または `==` オーバーライドを推奨**。

```dart
// Freezed を使う例
@freezed
class User with _$User {
  const factory User({
    required String id,
    required String name,
  }) = _User;
}
```

---

## レガシー API の移行

`StateProvider`, `StateNotifierProvider`, `ChangeNotifierProvider` は
3.0 でレガシーに分類。引き続き動作はするが、新規コードでは使わない。

```dart
// レガシー API を使い続ける場合（非推奨）
import 'package:flutter_riverpod/legacy.dart';

// 移行先
// StateProvider<int> → Notifier<int>
// StateNotifierProvider → NotifierProvider / AsyncNotifierProvider
// ChangeNotifierProvider → NotifierProvider
```

---

## リスナーの自動休止（新機能）

`TickerMode` が false（Widget が非表示）のとき、そのウィジェットのリスナーが自動的に休止される。

**具体例**：
- ホーム画面が WebSocket を購読
- 設定画面（別ルート）に遷移
- → 3.0 ではホーム画面の WebSocket リスナーが休止され、リソース節約

通常のアプリコードへの影響は少ないが、バックグラウンドで継続的に状態更新が必要な
Provider は `keepAlive: true` を設定すること。

---

## Provider 依存グラフのベストプラクティス（3.0）

```dart
// DI チェーン例
@riverpod
Dio dio(Ref ref) => Dio(BaseOptions(baseUrl: 'https://api.example.com'));

@riverpod
UserRemoteDataSource userRemoteDataSource(Ref ref) =>
    UserRemoteDataSourceImpl(ref.watch(dioProvider));

@riverpod
UserRepository userRepository(Ref ref) =>
    UserRepositoryImpl(ref.watch(userRemoteDataSourceProvider));

@riverpod
class UserList extends _$UserList {
  @override
  Future<List<User>> build() =>
      ref.watch(userRepositoryProvider).getUsers();
}
```

---

## updateShouldNotify（カスタム再描画制御）

3.0 で追加。Provider が通知を出すべきか制御できる。

```dart
final myProvider = Provider(
  (ref) => MyState(),
  updateShouldNotify: (previous, next) => previous.id != next.id,
);
```
