import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String? userId;
  String? username;
  String? profileImage;
  String? userPassword;
  String? status;
  int numOfRequests = 0;
  Future setLiveUser(id) async {
    try {
      final result = await FirebaseFirestore.instance.doc('/users/$id').get();
      username = result['username'];
      profileImage = result['profileImage'];
      userPassword = result['password'];
      userId = id;
      status = 'Online';
      notifyListeners();
      setStatus('Online');
    } catch (e) {
      await FirebaseAuth.instance.signOut();
    }
  }

  setStatus(String status) async {
    try {
      await FirebaseFirestore.instance
          .doc('/users/$userId')
          .update({'status': status});
    } catch (error) {
      await FirebaseFirestore.instance.doc('/users/$userId').set({
        'username': username,
        'password': userPassword,
        'profileImage': profileImage,
        'status': status
      });
    }
  }

  Future<int> setUnseenMessagesNumber(contactId) async {
    try {
      var response = await FirebaseFirestore.instance
          .collection('/chats')
          .doc('/${FirebaseAuth.instance.currentUser!.uid}')
          .collection('/contacts')
          .doc(contactId)
          .collection('/unreadMessages')
          .get();
      return response.docs[0]['count'];
    } catch (e) {
      return 0;
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

  void setNumberOfUsers() async {
    QuerySnapshot<Map<String, dynamic>> response = await FirebaseFirestore
        .instance
        .collection('/chats/${FirebaseAuth.instance.currentUser!.uid}/requests')
        .get();

    numOfRequests = response.docs.length;
    notifyListeners();
  }

  logout() async {
    await setStatus('Offline');
    await FirebaseAuth.instance.signOut();
  }

  setAllMessagesToSeen(contactId) async {
    try {
      var response = await FirebaseFirestore.instance
          .collection('/chats')
          .doc('/$userId')
          .collection('/contacts')
          .doc(contactId)
          .collection('/unreadMessages')
          .get();
      await FirebaseFirestore.instance
          .collection('/chats')
          .doc('/$userId')
          .collection('/contacts')
          .doc(contactId)
          .collection('/unreadMessages')
          .doc(response.docs[0].id)
          .update({'count': 0});
    } catch (error) {}
  }
}
