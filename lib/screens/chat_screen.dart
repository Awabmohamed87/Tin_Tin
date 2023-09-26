import 'package:chat_app/providers/user_provider.dart';
import 'package:chat_app/widgets/messages.dart';
import 'package:chat_app/widgets/search_bars/new_message.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';

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
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false)
        .setStatus(widget.contactName);

    FirebaseMessaging fbm = FirebaseMessaging.instance;
    fbm.requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Provider.of<UserProvider>(context, listen: false).setStatus('Online');
        return true;
      },
      child: Scaffold(
        backgroundColor: Provider.of<ThemeProvider>(context).secondryColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Provider.of<ThemeProvider>(context).mainColor,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Provider.of<UserProvider>(context, listen: false)
                      .setStatus('Online');
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.arrow_back_ios,
                    color: Provider.of<ThemeProvider>(context).mainFontColor),
              ),
              CircleAvatar(
                backgroundImage: NetworkImage(widget.profileImage),
              ),
              const SizedBox(width: 10),
              Text(
                widget.contactName,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Provider.of<ThemeProvider>(context).mainFontColor),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(child: Messages(widget.liveUserId, widget.contactId)),
            NewMesasageBar(widget.liveUserId, widget.contactId)
          ],
        ),
      ),
    );
  }
}
