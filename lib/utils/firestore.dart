import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";

@Deprecated("Use userDocProvider instead.")
DocumentReference? get userDoc => FirebaseAuth.instance.currentUser != null
    ? FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
    : null;
