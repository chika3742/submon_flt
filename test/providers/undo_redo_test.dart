import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_test/flutter_test.dart";
import "package:submon/isar_db/isar_timetable.dart";
import "package:submon/providers/timetable_providers.dart";

/// `UndoRedo` Notifier のスタック遷移ロジックのテスト。
/// `TimetableEditUseCase` 側では `UndoRedoHandler` をモックするため、
/// スタックの不変条件 (push で redo クリア、pop で current を反対側へ積む) は
/// ここで直接検証する。
void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
  });

  tearDown(() => container.dispose());

  UndoRedo handler() => container.read(undoRedoProvider(-1).notifier);

  Timetable cell(int cellId) {
    return Timetable()
      ..tableId = -1
      ..cellId = cellId
      ..subject = "s$cellId";
  }

  TimetableSnapshot snapshot(int cellId) => {cellId: cell(cellId)};

  test("初期状態は両スタック空で popUndo/popRedo は null", () {
    final h = handler();
    expect(h.popUndo(snapshot(0)), isNull);
    expect(h.popRedo(snapshot(0)), isNull);
  });

  test("pushSnapshot → popUndo で同じ snapshot が返り、current が redo へ積まれる", () {
    final h = handler();
    final s1 = snapshot(1);
    final current = snapshot(2);

    h.pushSnapshot(s1);
    final popped = h.popUndo(current);

    expect(popped, s1);
    // current が redo スタックに積まれ、popRedo で取り出せる
    expect(h.popRedo(snapshot(3)), current);
  });

  test("pushSnapshot は redo スタックをクリアする", () {
    final h = handler();
    h.pushSnapshot(snapshot(1));
    h.popUndo(snapshot(2)); // redo スタックに積まれる

    // 新しい操作 (pushSnapshot) で redo はクリアされる
    h.pushSnapshot(snapshot(3));
    expect(h.popRedo(snapshot(4)), isNull);
  });

  test("clear で両スタックが空になる", () {
    final h = handler();
    h.pushSnapshot(snapshot(1));
    h.clear();

    expect(h.popUndo(snapshot(2)), isNull);
    expect(h.popRedo(snapshot(2)), isNull);
  });
}
