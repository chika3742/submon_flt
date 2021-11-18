import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreProvider {
  late final FirebaseFirestore db;

  FirestoreProvider() {
    db = FirebaseFirestore.instance;
  }



}