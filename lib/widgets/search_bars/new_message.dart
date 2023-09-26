import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMesasageBar extends StatefulWidget {
  final String liveUserId, contactId;
  const NewMesasageBar(this.liveUserId, this.contactId, {super.key});

  @override
  State<NewMesasageBar> createState() => _NewMesasageBarState();
}

class _NewMesasageBarState extends State<NewMesasageBar> {
  String _message = '';
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void sendMessage() async {
      if (_message == '') return;

      _controller.clear();

      var userid = FirebaseAuth.instance.currentUser;
      var username = await FirebaseFirestore.instance
          .collection('users')
          .doc(userid!.uid)
          .get();
      await FirebaseFirestore.instance
          .collection(
              '/chats/${widget.liveUserId}/contacts/${widget.contactId}/messages')
          .add({
        'text': _message,
        'createdAt': Timestamp.now(),
        'userid': userid.uid,
        'username': username['username']
      });
      await FirebaseFirestore.instance
          .collection('/chats')
          .doc('/${widget.contactId}')
          .collection('/contacts')
          .doc('/${widget.liveUserId}')
          .collection('/messages')
          .add({
        'text': _message,
        'createdAt': Timestamp.now(),
        'userid': userid.uid,
        'username': username['username']
      });
      try {
        var response = await FirebaseFirestore.instance
            .collection('/chats')
            .doc('/${widget.contactId}')
            .collection('/contacts')
            .doc('/${widget.liveUserId}')
            .collection('/unreadMessages')
            .get();
        await FirebaseFirestore.instance
            .collection('/chats')
            .doc('/${widget.contactId}')
            .collection('/contacts')
            .doc('/${widget.liveUserId}')
            .collection('/unreadMessages')
            .doc(response.docs[0].id)
            .set({
          'count': response.docs[0]['count'] + 1,
        });
      } catch (e) {
        await FirebaseFirestore.instance
            .collection('/chats')
            .doc('/${widget.contactId}')
            .collection('/contacts')
            .doc('/${widget.liveUserId}')
            .collection('/unreadMessages')
            .add({'count': 1});
      }
      try {
        var response = await FirebaseFirestore.instance
            .collection('/chats')
            .doc('/${widget.contactId}')
            .collection('/contacts')
            .doc('/${widget.liveUserId}')
            .collection('/lastMessage')
            .get();
        await FirebaseFirestore.instance
            .collection('/chats')
            .doc('/${widget.contactId}')
            .collection('/contacts')
            .doc('/${widget.liveUserId}')
            .collection('/lastMessage')
            .doc(response.docs[0].id)
            .set({
          'content': _message,
        });
      } catch (error) {
        await FirebaseFirestore.instance
            .collection('/chats')
            .doc('/${widget.contactId}')
            .collection('/contacts')
            .doc('/${widget.liveUserId}')
            .collection('/lastMessage')
            .add({
          'content': _message,
        });
      }

      _message = '';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), border: Border.all()),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: (value) {
                setState(() {
                  _message = value;
                });
              },
              decoration: const InputDecoration(
                  hintText: 'New Message..',
                  focusedBorder:
                      UnderlineInputBorder(borderSide: BorderSide.none),
                  border: UnderlineInputBorder(borderSide: BorderSide.none)),
            ),
          ),
          IconButton(
              color: Theme.of(context).primaryColor,
              onPressed: _message.trim().isEmpty ? null : sendMessage,
              icon: const Icon(
                Icons.send_rounded,
                size: 30,
              ))
        ],
      ),
    );
  }
}
