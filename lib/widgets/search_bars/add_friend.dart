import 'package:chat_app/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddFriendBar extends StatefulWidget {
  const AddFriendBar({super.key});

  @override
  State<AddFriendBar> createState() => _AddFriendBarState();
}

class _AddFriendBarState extends State<AddFriendBar> {
  String searchString = '';
  final TextEditingController _controller = TextEditingController();

  void addFriend(String email, context) async {
    final QuerySnapshot<Map<String, dynamic>> response =
        await FirebaseFirestore.instance.collection('/users').get();
    final data = response.docs.map((e) => e.data()).toList();

    var searchedUser =
        data.firstWhere((element) => element['username'] == email);
    int idIndex = data.indexWhere((element) => element['username'] == email);
    String id = response.docs[idIndex].id;
    FirebaseFirestore.instance
        .collection('/chats')
        .doc('/${FirebaseAuth.instance.currentUser!.uid}')
        .collection('/contacts')
        .doc('/$id')
        .set({});
    FirebaseFirestore.instance
        .collection('/chats')
        .doc('/$id')
        .collection('/requests')
        .doc('/${FirebaseAuth.instance.currentUser!.uid}')
        .set({});
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => ChatScreen(
            contactName: searchedUser['username'],
            liveUserId: FirebaseAuth.instance.currentUser!.uid,
            contactId: id,
            profileImage: searchedUser['profileImage'])));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          right: 8,
          left: 8,
          top: 8),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            onChanged: (value) {
              setState(() {
                searchString = value;
              });
            },
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Enter user name..',
              focusedBorder: UnderlineInputBorder(),
              border: UnderlineInputBorder(),
            ),
          )),
          IconButton(
              color: Theme.of(context).primaryColor,
              icon: const Icon(
                Icons.person_add_alt_outlined,
              ),
              onPressed: searchString.trim().isEmpty
                  ? null
                  : () {
                      Scaffold.of(context).closeDrawer();
                      addFriend(_controller.text.toString(), context);
                    })
        ],
      ),
    );
  }
}
