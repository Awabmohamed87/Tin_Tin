import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../widgets/auth/user_image_picker.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _username = '';

  bool _isLoggingIn = true;

  bool _isLoading = false;

  File? _userImage;
  // ignore: non_constant_identifier_names
  final FirebaseAuth database_auth = FirebaseAuth.instance;
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

  _submitForm(
      {required String email,
      required String password,
      required String username,
      required BuildContext ctx,
      File? image}) async {
    UserCredential authResult;
    try {
      if (_isLoggingIn) {
        authResult = await database_auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await database_auth.createUserWithEmailAndPassword(
            email: email, password: password);
        final ref = FirebaseStorage.instance
            .ref()
            .child('profileImages')
            .child('${authResult.user!.uid}.jpg');
        await ref.putFile(image!);
        final imageUrl = await ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('/users')
            .doc(authResult.user!.uid)
            .set({
          'username': username,
          'password': password,
          'profileImage': imageUrl
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (e.code == 'weak-password') {
        showDialogError('Password is Weak..');
      } else if (e.code == 'email-already-in-use') {
        showDialogError('Email is already taken..try a new one');
      } else if (e.code == 'user-not-found') {
        showDialogError('Email is not found');
      } else if (e.code == 'wrong-password') {
        showDialogError('Wrong Password!!');
      }
    }
  }

  void onImagePicked(pickedImage) {
    if (pickedImage != null) {
      _userImage = pickedImage;
    }
  }

  void _submit() {
    bool isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
      _submitForm(
          email: _email,
          password: _password,
          username: _username,
          ctx: context,
          image: !_isLoggingIn
              ? _userImage!
              : File(
                  'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(_isLoggingIn ? 'LogIn' : 'SignUp',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold)),
              Card(
                margin: const EdgeInsets.all(20),
                color: Colors.white,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        if (!_isLoggingIn) UserImagePicker(onImagePicked),
                        TextFormField(
                          key: const ValueKey('email'),
                          onChanged: (_) {},
                          decoration:
                              const InputDecoration(labelText: 'Email Address'),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty || !value.contains('@')) {
                              return 'Invalid email!';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            setState(() {
                              _email = value!;
                            });
                          },
                        ),
                        if (!_isLoggingIn)
                          TextFormField(
                            key: const ValueKey('username'),
                            onChanged: (_) {},
                            decoration:
                                const InputDecoration(labelText: 'User Name'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your name!';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              setState(() {
                                _username = value!;
                              });
                            },
                          ),
                        TextFormField(
                          key: const ValueKey('password'),
                          onChanged: (_) {},
                          decoration:
                              const InputDecoration(labelText: 'Password'),
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            setState(() {
                              _password = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        _isLoading
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  _submit();
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  fixedSize: Size(
                                      MediaQuery.of(context).size.width * 0.7,
                                      50),
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                ),
                                child: Text(
                                  _isLoggingIn ? 'Login' : 'SignUp',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                        const SizedBox(height: 20),
                        InkWell(
                            onTap: () {
                              setState(() {
                                _isLoggingIn = !_isLoggingIn;
                              });
                            },
                            child: Text(
                              _isLoggingIn
                                  ? "don't have an account?"
                                  : 'already have an account?',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
