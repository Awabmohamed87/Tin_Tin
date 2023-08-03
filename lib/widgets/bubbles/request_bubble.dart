import 'package:chat_app/widgets/focusable_profile_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RequestBubble extends StatefulWidget {
  final String id;
  const RequestBubble(this.id, {super.key});

  @override
  State<RequestBubble> createState() => _RequestBubbleState();
}

class _RequestBubbleState extends State<RequestBubble> {
  Future<Map<String, dynamic>> getName() async {
    final result = await FirebaseFirestore.instance
        .collection('/users')
        .doc('/${widget.id}')
        .get();
    return {
      'username': result['username'],
      'profileImage': result['profileImage'],
      'id': result.id
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getName(),
        builder: (context, snapshot) => snapshot.connectionState !=
                ConnectionState.waiting
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FocusableProfileImage(snapshot.data!['profileImage'],
                        radius: 18),
                    const SizedBox(width: 10),
                    Text(snapshot.data!['username'],
                        style: const TextStyle(fontSize: 22)),
                    const Spacer(),
                    GestureDetector(
                        onTap: () {
                          FirebaseFirestore.instance
                              .collection('/chats')
                              .doc('/${FirebaseAuth.instance.currentUser!.uid}')
                              .collection('/contacts')
                              .doc('/${widget.id}')
                              .set({});
                          FirebaseFirestore.instance
                              .collection('/chats')
                              .doc('/${FirebaseAuth.instance.currentUser!.uid}')
                              .collection('requests')
                              .doc(snapshot.data!['id'])
                              .delete();
                        },
                        child: Container(
                            width: 25,
                            height: 25,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child:
                                const Icon(Icons.check, color: Colors.white))),
                    const SizedBox(width: 10),
                    GestureDetector(
                        onTap: () {},
                        child: Container(
                            width: 25,
                            height: 25,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child:
                                const Icon(Icons.close, color: Colors.white))),
                  ],
                ),
              )
            : Container());
  }
}
