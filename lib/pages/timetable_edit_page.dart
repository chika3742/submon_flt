import 'dart:async';

import 'package:flutter/material.dart';
import 'package:submon/components/timetable/timetable.dart';
import 'package:submon/events.dart';
import 'package:submon/isar_db/isar_timetable.dart' as db;

class TimetableEditPage extends StatefulWidget {
  const TimetableEditPage({super.key});

  static const routeName = "/timetable/edit";

  @override
  State<TimetableEditPage> createState() => _TimetableEditPageState();
}

class _TimetableEditPageState extends State<TimetableEditPage> {
  final _tableKey = GlobalKey<TimetableState>();
  StreamSubscription? _listener;

  @override
  void initState() {
    super.initState();
    _listener = eventBus.on<UndoRedoUpdatedEvent>().listen((event) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _listener?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("時間割表編集"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            splashRadius: 24,
            onPressed: () {
              setState(() {
                db.TimetableProvider.redoList.clear();
                db.TimetableProvider.undoList
                    .insert(0, Map.from(_tableKey.currentState!.table));
              });
              _tableKey.currentState?.setState(() {
                _tableKey.currentState?.table.clear();
              });
              db.TimetableProvider().use((provider) async {
                provider.writeTransaction(() async {
                  await provider.clearCurrentTable();
                });
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.undo),
            splashRadius: 24,
            onPressed: db.TimetableProvider.undoList.isNotEmpty ? undo : null,
          ),
          IconButton(
            icon: const Icon(Icons.redo),
            splashRadius: 24,
            onPressed: db.TimetableProvider.redoList.isNotEmpty ? redo : null,
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("編集したい位置をタップしてください。"),
          ),
          Timetable(
            key: _tableKey,
            edit: true,
          ),
        ],
      ),
    );
  }

  void undo() {
    setState(() {
      db.TimetableProvider.redoList
          .insert(0, Map.from(_tableKey.currentState!.table));
      _tableKey.currentState?.table = db.TimetableProvider.undoList[0];
      db.TimetableProvider.undoList.removeAt(0);
    });
    updateLocalDb();
  }

  void redo() {
    setState(() {
      db.TimetableProvider.undoList
          .insert(0, Map.from(_tableKey.currentState!.table));
      _tableKey.currentState?.table = db.TimetableProvider.redoList[0];
      db.TimetableProvider.redoList.removeAt(0);
    });
    updateLocalDb();
  }

  void updateLocalDb() {
    db.TimetableProvider().use((provider) async {
      provider.writeTransaction(() async {
        await provider
            .putAllLocalOnly(_tableKey.currentState!.table.values.toList());
      });
    });
  }
}

enum FieldValue { unselect }
