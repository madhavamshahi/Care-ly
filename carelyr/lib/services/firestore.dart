import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Firestore {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  Future addUser({required String name, required List major}) async {
    CollectionReference ref = firestore.collection("users");

    var h = await ref
        .doc(auth.currentUser!.uid)
        .set({
          "name": name,
          "uid": auth.currentUser!.uid,
          "major": major,
        })
        .onError((error, stackTrace) => error)
        .then((value) => null);

    if (h is String) {
      return h;
    }
  }

  Future getMajor(String uid) async {
    CollectionReference ref = firestore.collection("users");
    DocumentSnapshot doc = await ref.doc(uid).get();

    final data = doc.data() as Map<String, dynamic>;

    return data['major'][0];
  }
}
