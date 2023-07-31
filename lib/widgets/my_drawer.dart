import 'package:chat_app/widgets/search_bars/add_friend.dart';
import 'package:chat_app/widgets/bubbles/request_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final scaffoldKey;
  const MyDrawer({super.key, required this.scaffoldKey});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          SizedBox(
            height: 90,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Pending Requests',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                    ),
                    onPressed: () =>
                        widget.scaffoldKey.currentState!.closeDrawer(),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
              child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(
                    '/chats/${FirebaseAuth.instance.currentUser!.uid}/requests')
                .snapshots(),
            builder: (context, snapshot) {
              return snapshot.connectionState == ConnectionState.waiting
                  ? const Center(child: CircularProgressIndicator())
                  : snapshot.data!.docs.isEmpty
                      ? Text('No pending requests',
                          style: TextStyle(color: Colors.grey[500]))
                      : ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) =>
                              RequestBubble(snapshot.data!.docs[index].id),
                        );
            },
          )),
          const AddFriendBar()
        ],
      ),
    );
  }
}
