import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../components/timetable/timetable.dart";
import "../core/pref_key.dart";
import "../providers/timetable_providers.dart";

class TimetableEditPage extends ConsumerWidget {
  const TimetableEditPage({super.key});

  static const routeName = "/timetable/edit";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tableId = ref.watchPref(PrefKey.intCurrentTimetableId);
    final undoRedoState = ref.watch(undoRedoProvider(tableId));
    final useCase = ref.read(timetableEditUseCaseProvider(tableId));

    return Scaffold(
      appBar: AppBar(
        title: const Text("時間割表編集"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            splashRadius: 24,
            onPressed: () async {
              await useCase.clearTable();
            },
          ),
          IconButton(
            icon: const Icon(Icons.undo),
            splashRadius: 24,
            onPressed: undoRedoState.undoStack.isNotEmpty
                ? () async {
                    await useCase.undo();
                  }
                : null,
          ),
          IconButton(
            icon: const Icon(Icons.redo),
            splashRadius: 24,
            onPressed: undoRedoState.redoStack.isNotEmpty
                ? () async {
                    await useCase.redo();
                  }
                : null,
          ),
        ],
      ),
      body: const Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("編集したい位置をタップしてください。"),
          ),
          Timetable(
            edit: true,
          ),
        ],
      ),
    );
  }
}

enum FieldValue { unselect }
