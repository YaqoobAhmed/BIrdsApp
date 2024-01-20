import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  static FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static Future<dynamic> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

  static Future<dynamic> createUserWithEmailAndPassword(
      String email, String password, String name, String phoneNumber) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      FirebaseFirestore _firestore = FirebaseFirestore.instance;
      Map<String, dynamic> userdata = {
        "name": name,
        "email": email,
        "phone": phoneNumber,
      };
      await _firestore.collection("user").add(userdata);
      return userCredential.user;
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

  static Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}
