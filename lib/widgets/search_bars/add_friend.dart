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
  final TextEditingController _controller = TextEditingController();

  void addFriend(String email) async {
    String id = '';
    final response =
        FirebaseFirestore.instance.collection('/users').snapshots();
    await response.forEach((element) {
      for (var element in element.docs) {
        if (element['username'] == email) {
          id = element.id;
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
                  contactName: element['username'],
                  liveUserId: FirebaseAuth.instance.currentUser!.uid,
                  contactId: element.id,
                  profileImage: element['profileImage'])));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Enter user name..',
              focusedBorder: UnderlineInputBorder(),
              border: UnderlineInputBorder(),
            ),
          )),
          IconButton(
              icon: const Icon(
                Icons.person_add_alt_outlined,
                color: Colors.grey,
              ),
              onPressed: () {
                Scaffold.of(context).closeDrawer();
                addFriend(_controller.text.toString());
              })
        ],
      ),
    );
  }
}
