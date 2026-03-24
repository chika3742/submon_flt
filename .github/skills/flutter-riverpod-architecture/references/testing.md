# Riverpod テスト詳細パターン

## 依存パッケージ

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.x
  build_runner: ^2.x
  riverpod_test: ^2.x  # オプション（AsyncNotifier のテストを簡略化）
```

---

## 基本構成：ProviderContainer

Riverpod のテストは `ProviderContainer` を使って Widget なしで実行する。
`overrides` で本番 Provider を Mock に差し替える。

```dart
void main() {
  late ProviderContainer container;
  late MockUserRepository mockRepo;

  setUp(() {
    mockRepo = MockUserRepository();
    container = ProviderContainer(
      overrides: [
        userRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
  });

  tearDown(() => container.dispose()); // メモリリーク防止に必須
}
```

---

## Mockito でのモック生成

```dart
// アノテーションでモック対象を指定
@GenerateMocks([UserRepository, UserRemoteDataSource])
void main() { ... }

// build_runner で生成
// dart run build_runner build --delete-conflicting-outputs
```

---

## Notifier（同期）のテスト

```dart
test('カウンターの初期値は 0', () {
  final container = ProviderContainer();
  addTearDown(container.dispose);

  expect(container.read(counterProvider), 0);
});

test('increment で +1 される', () {
  final container = ProviderContainer();
  addTearDown(container.dispose);

  container.read(counterProvider.notifier).increment();
  expect(container.read(counterProvider), 1);
});
```

---

## AsyncNotifier のテスト

```dart
test('ユーザー一覧の初期ロードが成功する', () async {
  final users = [User(id: '1', name: 'Alice')];
  when(mockRepo.getUsers()).thenAnswer((_) async => users);

  // .future で AsyncValue が解決するまで待つ
  final result = await container.read(userListProvider.future);
  expect(result, equals(users));
});

test('ローディング中は AsyncLoading が返る', () {
  when(mockRepo.getUsers()).thenAnswer(
    (_) => Future.delayed(const Duration(seconds: 1), () => []),
  );

  final state = container.read(userListProvider);
  expect(state, isA<AsyncLoading<List<User>>>());
});

test('エラー時は AsyncError が返る', () async {
  when(mockRepo.getUsers()).thenThrow(AppException('network error'));

  // エラーが返るまで待つ
  await expectLater(
    container.read(userListProvider.future),
    throwsA(isA<AppException>()),
  );

  final state = container.read(userListProvider);
  expect(state, isA<AsyncError<List<User>>>());
});
```

---

## AsyncNotifier のミューテーションテスト

```dart
test('addUser が成功すると一覧に追加される', () async {
  final initial = [User(id: '1', name: 'Alice')];
  final newUser = User(id: '2', name: 'Bob');

  when(mockRepo.getUsers()).thenAnswer((_) async => initial);
  when(mockRepo.createUser(newUser)).thenAnswer((_) async {});

  // 初期ロード完了を待つ
  await container.read(userListProvider.future);

  // ミューテーション実行
  await container.read(userListProvider.notifier).addUser(newUser);

  final result = container.read(userListProvider).value!;
  expect(result, contains(newUser));
});
```

---

## 状態変化の監視（listen）

```dart
test('状態変化を順番に検証する', () async {
  final states = <AsyncValue<List<User>>>[];

  container.listen(
    userListProvider,
    (previous, next) => states.add(next),
    fireImmediately: true,
  );

  await container.read(userListProvider.future);

  // AsyncLoading → AsyncData の順で遷移することを確認
  expect(states.first, isA<AsyncLoading>());
  expect(states.last, isA<AsyncData>());
});
```

---

## StreamNotifier のテスト

```dart
test('メッセージ Stream が更新を受け取る', () async {
  final streamController = StreamController<List<Message>>();
  when(mockRepo.watchMessages(roomId: 'room1'))
      .thenAnswer((_) => streamController.stream);

  final container = ProviderContainer(
    overrides: [messageRepositoryProvider.overrideWithValue(mockRepo)],
  );

  // ストリームにデータを流す
  streamController.add([Message(text: 'Hello')]);
  await Future.microtask(() {});

  final state = container.read(messageStreamProvider('room1'));
  expect(state.value, hasLength(1));

  streamController.close();
});
```

---

## Widget テストでの Riverpod（ProviderScope）

```dart
testWidgets('ユーザー一覧 Widget が正しく表示される', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        userRepositoryProvider.overrideWithValue(mockRepo),
      ],
      child: const MaterialApp(home: UserListScreen()),
    ),
  );

  // 非同期ロード完了を待つ
  await tester.pumpAndSettle();

  expect(find.text('Alice'), findsOneWidget);
});
```

---

## テストのベストプラクティス

1. **各テストは独立した ProviderContainer を使う**（状態の汚染防止）
2. **`addTearDown(container.dispose)` を必ず呼ぶ**（メモリリーク防止）
3. **非同期テストでは `.future` を await してから状態を検証する**
4. **ミューテーションテストは初期ロード完了後に実行する**
5. **UI ロジック（Notifier）と Widget テストは分離して書く**
6. **Mock の `verify` で期待される呼び出しを検証する**

```dart
// verify の例
verify(mockRepo.createUser(any)).called(1);
verifyNever(mockRepo.deleteUser(any));
```
