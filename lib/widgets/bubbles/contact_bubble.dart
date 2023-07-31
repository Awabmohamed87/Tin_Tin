import 'package:chat_app/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ContactBubble extends StatefulWidget {
  final String contactName;
  final String contactId;
  final String userProfile;
  const ContactBubble(
      {super.key,
      required this.contactName,
      required this.contactId,
      required this.userProfile});

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
                  contactName: widget.contactName,
                  liveUserId: FirebaseAuth.instance.currentUser!.uid,
                  contactId: widget.contactId,
                  profileImage: widget.userProfile,
                )));
      },
      child: Container(
        color: Colors.grey[100],
        width: double.infinity,
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          children: [
            CircleAvatar(
              radius: 27,
              backgroundImage: NetworkImage(widget.userProfile),
            ),
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
            ),
            const Spacer(),
            Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                '0',
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(width: 10)
          ],
        ),
      ),
    );
  }
}
