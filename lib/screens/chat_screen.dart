import 'package:chat_app/widgets/messages.dart';
import 'package:chat_app/widgets/search_bars/new_message.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String liveUserId;
  final String contactId;
  final String contactName;
  final String profileImage;
  const ChatScreen(
      {super.key,
      required this.contactName,
      required this.liveUserId,
      required this.contactId,
      required this.profileImage});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(Icons.arrow_back_ios),
            ),
            CircleAvatar(
              backgroundImage: NetworkImage(widget.profileImage),
            ),
            const SizedBox(width: 10),
            Text(widget.contactName,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(child: Messages(widget.liveUserId, widget.contactId)),
          NewMesasageBar(widget.liveUserId, widget.contactId)
        ],
      ),
    );
  }
}
