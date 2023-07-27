import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/auth_card.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // ignore: non_constant_identifier_names
  final database_auth = FirebaseAuth.instance;

  _submitForm(
      {required String email,
      required String password,
      required String username,
      required bool isLoggingIn,
      required BuildContext ctx}) async {
    UserCredential authResult;
    try {
      if (isLoggingIn) {
        authResult = await database_auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await database_auth.createUserWithEmailAndPassword(
            email: email, password: password);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set({'username': username, 'password': password});
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showDialogError('Password is Weak..');
      } else if (e.code == 'email-already-in-use') {
        showDialogError('Email is already taken..try a new one');
      } else if (e.code == 'user-not-found') {
        showDialogError('Email is not found');
      } else if (e.code == 'wrong-password') {
        showDialogError('Wrong Password!!');
      }
    } catch (e) {
      rethrow;
    }
  }

  showDialogError(msg) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        showCloseIcon: true,
        closeIconColor: Colors.black,
        duration: const Duration(milliseconds: 1500),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.warning_outlined),
            const SizedBox(width: 20),
            Text(
              msg,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthCard(_submitForm),
    );
  }
}
