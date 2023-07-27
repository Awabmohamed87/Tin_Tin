import 'package:chat_app/widgets/messages.dart';
import 'package:chat_app/widgets/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String liveUserId;
  final String contactId;
  const ChatScreen(
      {super.key, required this.liveUserId, required this.contactId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop()),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Chats'),
        actions: [
          DropdownButton(
              icon: const Icon(Icons.more_vert),
              items: const [
                DropdownMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app),
                      SizedBox(width: 10),
                      Text('LogOut')
                    ],
                  ),
                )
              ],
              onChanged: (value) {
                if (value == 'logout') {
                  FirebaseAuth.instance.signOut();
                }
              })
        ],
      ),
      body: const Column(
        children: [Expanded(child: Messages()), NewMesasageBar()],
      ),
    );
  }
}
