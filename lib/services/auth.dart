import 'dart:developer';
import 'package:chat_app/modals/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;
  Users username(User user) {
    return Users(userId: user.uid);
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? firebaseUser = userCredential.user;
      return username(firebaseUser!);
      // username(userCredential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        log('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        log('Wrong password provided for that user.');
      }
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) {
    try {
      final userCredential =
          auth.createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
      // username(userCredential);
    } catch (e) {
      log(e.toString());
      return auth.createUserWithEmailAndPassword(
          email: email, password: password);
    }
  }

  Future resetPass(String email) {
    try {
      final userCredential = auth.sendPasswordResetEmail(email: email);
      print(userCredential);
    } catch (e) {
      log(e.toString());
    }
    return auth.sendPasswordResetEmail(email: email.trim());
  }

  Future signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      log(e.toString());
    }
  }
}
