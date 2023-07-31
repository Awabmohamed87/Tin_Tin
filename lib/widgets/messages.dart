import 'package:chat_app/widgets/bubbles/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatefulWidget {
  final String liveUserId, contactId;
  const Messages(this.liveUserId, this.contactId, {super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(
              '/chats/${widget.liveUserId}/contacts/${widget.contactId}/messages')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        return snapshot.connectionState == ConnectionState.waiting
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                reverse: true,
                itemBuilder: (ctx, index) => MessageBubble(
                    username: snapshot.data!.docs[index]['username'],
                    message: snapshot.data!.docs[index]['text'],
                    isMe: snapshot.data!.docs[index]['userid'] ==
                        FirebaseAuth.instance.currentUser!.uid,
                    mykey: ValueKey(snapshot.data!.docs[index].id)),
                itemCount: snapshot.data!.docs.length,
              );
      },
    );
  }
}
