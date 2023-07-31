import 'dart:io';

import 'package:chat_app/widgets/auth/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthCard extends StatefulWidget {
  final Function(
      {required String email,
      required String password,
      required String username,
      required bool isLoggingIn,
      required BuildContext ctx,
      File image}) submitFunc;
  const AuthCard(this.submitFunc, {super.key});

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _username = '';

  bool _isLoggingIn = true;

  bool _isLoading = false;

  File? _userImage;

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
      widget.submitFunc(
          email: _email,
          password: _password,
          username: _username,
          isLoggingIn: _isLoggingIn,
          ctx: context,
          image: !_isLoggingIn
              ? _userImage!
              : File(
                  'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg '));
      setState(() {
        _isLoading = false;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
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
                  decoration: const InputDecoration(labelText: 'Email Address'),
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
                    decoration: const InputDecoration(labelText: 'User Name'),
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
                  decoration: const InputDecoration(labelText: 'Password'),
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
                          fixedSize:
                              Size(MediaQuery.of(context).size.width * 0.7, 50),
                          backgroundColor: Theme.of(context).primaryColor,
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
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
