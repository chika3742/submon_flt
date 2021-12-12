import 'dart:async';

import 'package:flutter/material.dart';
import 'package:submon/components/timetable.dart';
import 'package:submon/db/timetable.dart' as db;
import 'package:submon/events.dart';

class TimetableEditPage extends StatefulWidget {
  const TimetableEditPage({Key? key}) : super(key: key);

  @override
  _TimetableEditPageState createState() => _TimetableEditPageState();
}

class _TimetableEditPageState extends State<TimetableEditPage> {
  final _tableKey = GlobalKey<TimetableState>();
  StreamSubscription? subscription;

  @override
  void initState() {
    super.initState();
    subscription = eventBus.on<UndoRedoUpdatedEvent>().listen((event) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription?.cancel();
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
                db.Timetable.redoList.clear();
                db.Timetable.undoList
                    .insert(0, Map.from(_tableKey.currentState!.table));
              });
              _tableKey.currentState?.setState(() {
                _tableKey.currentState?.table.clear();
              });
              db.TimetableProvider().use((provider) async {
                await provider.deleteAll();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.undo),
            splashRadius: 24,
            onPressed: db.Timetable.undoList.isNotEmpty ? undo : null,
          ),
          IconButton(
            icon: const Icon(Icons.redo),
            splashRadius: 24,
            onPressed: db.Timetable.redoList.isNotEmpty ? redo : null,
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
      db.Timetable.redoList.insert(0, Map.from(_tableKey.currentState!.table));
      _tableKey.currentState?.table = db.Timetable.undoList[0];
      db.Timetable.undoList.removeAt(0);
    });
    updateLocalDb();
  }

  void redo() {
    setState(() {
      db.Timetable.undoList.insert(0, Map.from(_tableKey.currentState!.table));
      _tableKey.currentState?.table = db.Timetable.redoList[0];
      db.Timetable.redoList.removeAt(0);
    });
    updateLocalDb();
  }

  void updateLocalDb() {
    db.TimetableProvider().use((provider) async {
      await provider.setAllLocalOnly(_tableKey.currentState!.table.values
          .map((e) => db.TimetableProvider.objToMapStatic(e))
          .toList());
    });
  }
}

enum FieldValue { unselect }
