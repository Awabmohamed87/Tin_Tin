import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/widgets/focusable_profile_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  int _numOfUnSeenMessages = 0;
  @override
  void initState() {
    setLiveUsersNumber();
    super.initState();
  }

  void setLiveUsersNumber() async {
    try {
      var response = await FirebaseFirestore.instance
          .collection('/chats')
          .doc('/${FirebaseAuth.instance.currentUser!.uid}')
          .collection('/contacts')
          .doc('/${widget.contactId}')
          .collection('/unreadMessages')
          .get();
      setState(() {
        _numOfUnSeenMessages = response.docs[0]['count'];
      });
    } catch (e) {
      setState(() {
        _numOfUnSeenMessages = 0;
      });
    }
  }

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
            FocusableProfileImage(widget.userProfile),
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
            if (_numOfUnSeenMessages > 0)
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$_numOfUnSeenMessages',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ),
            const SizedBox(width: 10)
          ],
        ),
      ),
    );
  }
}
