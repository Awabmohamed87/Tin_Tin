import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String? userId;
  String? username;
  String? profileImage;
  String? userPassword;
  Future setLiveUser(id) async {
    try {
      final result = await FirebaseFirestore.instance.doc('/users/$id').get();
      username = result['username'];
      profileImage = result['profileImage'];
      userPassword = result['password'];
      userId = id;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future getName(id) async {
    final result = await FirebaseFirestore.instance.doc('/users/$id').get();
    return result;
  }

  void updateUserName(newname) async {
    await FirebaseFirestore.instance.doc('/users/$userId').set({
      'username': newname,
      'password': userPassword,
      'profileImage': profileImage
    });
    username = newname;
    notifyListeners();
  }

  void changePassword(oldPassword, newPassword) async {
    if (oldPassword == userPassword) {
      await FirebaseFirestore.instance.doc('/users/$userId').set({
        'username': username,
        'password': newPassword,
        'profileImage': profileImage
      });
      await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
    }

    notifyListeners();
  }

  void changeProfilePicture(newPhoto) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('profileImages')
        .child('$userId.jpg');

    await ref.putFile(newPhoto!);
    final imageUrl = await ref.getDownloadURL();

    await FirebaseFirestore.instance.doc('/users/$userId').set({
      'username': username,
      'password': userPassword,
      'profileImage': imageUrl
    });

    profileImage = imageUrl;
    notifyListeners();
  }
}
