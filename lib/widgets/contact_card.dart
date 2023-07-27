import 'package:chat_app/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ContactBubble extends StatefulWidget {
  final String contactName;
  final String contactId;
  const ContactBubble(
      {super.key, required this.contactName, required this.contactId});

  @override
  State<ContactBubble> createState() => _ContactBubbleState();
}

class _ContactBubbleState extends State<ContactBubble> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ChatScreen(
                liveUserId: FirebaseAuth.instance.currentUser!.uid,
                contactId: widget.contactId)));
      },
      child: Container(
        color: Colors.grey[100],
        width: double.infinity,
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          children: [
            const CircleAvatar(radius: 27),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.contactName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text('latest message')
              ],
            )
          ],
        ),
      ),
    );
  }
}
