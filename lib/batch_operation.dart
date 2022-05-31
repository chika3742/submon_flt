import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BatchOperation {
  BatchOperationType type;
  DocumentReference doc;
  dynamic data;
  SetOptions? setOptions;

  BatchOperation.set({required this.doc, this.data, this.setOptions})
      : type = BatchOperationType.set;

  BatchOperation.delete({required this.doc}) : type = BatchOperationType.delete;

  @override
  String toString() {
    return "${doc.path}: ${type.name}:$data";
  }

  static Future<void> commit(List<BatchOperation> operations) async {
    var chunks = operations.partition(500);

    debugPrint(chunks.toString());

    for (var chunk in chunks) {
      var batch = FirebaseFirestore.instance.batch();
      for (var operation in chunk) {
        switch (operation.type) {
          case BatchOperationType.set:
            batch.set(operation.doc, operation.data, operation.setOptions);
            break;
          case BatchOperationType.delete:
            batch.delete(operation.doc);
            break;
        }
      }

      await batch.commit();
    }
  }
}

enum BatchOperationType { set, delete }

extension Partition<T> on List<T> {
  List<List<T>> partition(int chunkSize) {
    var chunks = <List<T>>[];
    var count = 0;

    do {
      chunks.add(skip(count * chunkSize).take(chunkSize).toList());
      count++;
    } while (count * chunkSize < length);

    return chunks;
  }
}
